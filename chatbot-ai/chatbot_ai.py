import re
import json
from product_data import ProductData

class ChatbotAI:
    def __init__(self):
        self.product_data = ProductData()
        self.context = {}
        
        # Định nghĩa các intent và patterns
        self.intents = {
            'greeting': {
                'patterns': ['chào', 'hi', 'hello', 'xin chào', 'mấy giờ'],
                'responses': [
                    "Xin chào! Tôi là trợ lý ảo của TuKhanhHuy. Tôi có thể giúp gì cho bạn ạ?",
                    "Chào bạn! Bạn cần tư vấn về sản phẩm kính mắt không?",
                    "Hi! Rất vui được hỗ trợ bạn!"
                ]
            },
            'goodbye': {
                'patterns': ['tạm biệt', 'bye', 'cảm ơn', 'thank'],
                'responses': [
                    "Cảm ơn bạn đã trò chuyện! Chúc bạn một ngày tốt lành!",
                    "Hẹn gặp lại bạn nhé!",
                    "Cảm ơn! Nếu cần hỗ trợ thêm, hãy quay lại nhé!"
                ]
            },
            'product_list': {
                'patterns': ['sản phẩm', 'có những', 'dòng kính', 'kính gì'],
                'handler': 'handle_product_list'
            },
            'search_product': {
                'patterns': ['tìm', 'kiếm', 'sản phẩm', 'kính', 'gọng', 'râm'],
                'handler': 'handle_search_product'
            },
            'price_range': {
                'patterns': ['giá', 'bao nhiêu', 'tiền', 'đắt', 'rẻ', 'mắc'],
                'handler': 'handle_price_range'
            },
            'gender_filter': {
                'patterns': ['kính nam', 'kính nữ', 'nam', 'nữ', 'unisex'],
                'handler': 'handle_gender_filter'
            },
            'material_filter': {
                'patterns': ['chất liệu', 'titanium', 'acetate', 'metal', 'plastic', 'tr90'],
                'handler': 'handle_material_filter'
            },
            'top_selling': {
                'patterns': ['bán chạy', 'hot', 'best seller', 'phổ biến'],
                'handler': 'handle_top_selling'
            },
            'help': {
                'patterns': ['giúp', 'hướng dẫn', 'cách', 'làm sao'],
                'handler': 'handle_help'
            }
        }
    
    def extract_keywords(self, text):
        """Trích xuất từ khóa từ câu hỏi"""
        words = re.findall(r'[\w\s]+', text.lower())
        return ' '.join(words).strip()
    
    def extract_price_range(self, text):
        """Trích xuất khoảng giá từ câu hỏi"""
        price_pattern = r'(\d+(?:\.\d+)?)\s*(?:triệu|k|ngàn|nghìn)?'
        prices = re.findall(price_pattern, text)
        
        if len(prices) >= 2:
            return int(prices[0]), int(prices[1])
        elif len(prices) == 1:
            if 'dưới' in text or 'dưới' in text:
                return 0, int(prices[0])
            elif 'trên' in text or 'trên' in text:
                return int(prices[0]), 5000000
        return None, None
    
    def handle_product_list(self):
        """Xử lý yêu cầu danh sách sản phẩm"""
        products = self.product_data.get_all_products_info()
        if not products:
            return "Hiện tại chưa có sản phẩm nào."
        
        response = "📋 **Các dòng sản phẩm nổi bật của TuKhanhHuy:**\n\n"
        for i, p in enumerate(products[:8]):
            response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
            response += f"   💰 Giá: {format_price(p['sale_price'])}đ\n\n"
        
        response += "👉 Bạn có thể xem thêm tại website hoặc hỏi tôi chi tiết về sản phẩm!"
        return response
    
    def handle_search_product(self, text):
        """Xử lý tìm kiếm sản phẩm"""
        keyword = self.extract_keywords(text)
        # Loại bỏ các từ không cần thiết
        stop_words = ['tìm', 'kiếm', 'sản phẩm', 'kính', 'cho', 'tôi']
        for word in stop_words:
            keyword = keyword.replace(word, '').strip()
        
        if not keyword or len(keyword) < 2:
            return "Bạn muốn tìm sản phẩm gì? Hãy cho tôi biết tên hoặc thương hiệu nhé!"
        
        products = self.product_data.search_products_by_keyword(keyword)
        if not products:
            return f"Rất tiếc, tôi không tìm thấy sản phẩm nào liên quan đến '{keyword}'. Bạn có thể thử từ khóa khác nhé!"
        
        response = f"🔍 **Kết quả tìm kiếm cho '{keyword}':**\n\n"
        for i, p in enumerate(products[:5]):
            response += f"{i+1}. **{p['name']}**\n"
            response += f"   🏷️ Thương hiệu: {p['brand']}\n"
            response += f"   💰 Giá: {format_price(p['sale_price'])}đ\n"
            response += f"   👤 Giới tính: {p['gender']}\n\n"
        
        response += "👉 Bạn có muốn xem chi tiết sản phẩm nào không?"
        return response
    
    def handle_price_range(self, text):
        """Xử lý lọc theo giá"""
        min_price, max_price = self.extract_price_range(text)
        
        if min_price is None and max_price is None:
            # Hỏi lại người dùng
            return "Bạn muốn xem sản phẩm trong khoảng giá nào? Ví dụ: 200k đến 500k"
        
        if min_price is None:
            min_price = 0
        if max_price is None:
            max_price = 5000000
        
        # Chuyển đổi đơn vị (k, triệu)
        if 'k' in text.lower():
            min_price = min_price * 1000 if min_price else 0
            max_price = max_price * 1000 if max_price else 5000000
        elif 'triệu' in text.lower() or 'tr' in text.lower():
            min_price = min_price * 1000000 if min_price else 0
            max_price = max_price * 1000000 if max_price else 5000000
        
        products = self.product_data.get_products_by_price_range(min_price, max_price)
        
        if not products:
            return f"Không tìm thấy sản phẩm nào trong khoảng giá {format_price(min_price)}đ - {format_price(max_price)}đ"
        
        response = f"💰 **Sản phẩm trong khoảng giá {format_price(min_price)}đ - {format_price(max_price)}đ:**\n\n"
        for i, p in enumerate(products[:5]):
            response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
            response += f"   💰 Giá: {format_price(p['sale_price'])}đ\n\n"
        
        return response
    
    def handle_gender_filter(self, text):
        """Xử lý lọc theo giới tính"""
        gender = None
        if 'nam' in text.lower():
            gender = 'Nam'
        elif 'nữ' in text.lower():
            gender = 'Nữ'
        elif 'unisex' in text.lower():
            gender = 'Unisex'
        
        if not gender:
            return "Bạn muốn xem kính nam, kính nữ hay unisex?"
        
        products = self.product_data.get_products_by_gender(gender)
        
        if not products:
            return f"Hiện chưa có sản phẩm kính {gender} nào."
        
        response = f"👤 **Kính {gender} tại TuKhanhHuy:**\n\n"
        for i, p in enumerate(products[:5]):
            response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
            response += f"   💰 Giá: {format_price(p['sale_price'])}đ\n"
            response += f"   🔧 Chất liệu: {p['frame_material']}\n\n"
        
        return response
    
    def handle_material_filter(self, text):
        """Xử lý lọc theo chất liệu"""
        material = None
        materials = ['titanium', 'acetate', 'metal', 'plastic', 'tr90']
        for mat in materials:
            if mat in text.lower():
                material = mat.capitalize()
                break
        
        if not material:
            return "Bạn muốn tìm kính với chất liệu nào? (Titanium, Acetate, Metal, Plastic, TR90)"
        
        products = self.product_data.get_products_by_material(material)
        
        if not products:
            return f"Hiện chưa có sản phẩm nào với chất liệu {material}."
        
        response = f"🔧 **Kính chất liệu {material}:**\n\n"
        for i, p in enumerate(products[:5]):
            response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
            response += f"   💰 Giá: {format_price(p['sale_price'])}đ\n"
            response += f"   👤 Giới tính: {p['gender']}\n\n"
        
        return response
    
    def handle_top_selling(self):
        """Xử lý sản phẩm bán chạy"""
        products = self.product_data.get_top_selling_products(5)
        
        if not products:
            return "Chưa có dữ liệu sản phẩm bán chạy."
        
        response = "🔥 **Top sản phẩm bán chạy nhất:**\n\n"
        for i, p in enumerate(products):
            sold = p.get('sold_quantity', 0)
            response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
            response += f"   💰 Giá: {format_price(p['sale_price'])}đ\n"
            response += f"   📦 Đã bán: {sold} sản phẩm\n\n"
        
        return response
    
    def handle_help(self):
        """Hướng dẫn sử dụng"""
        help_text = """
🤖 **Tôi có thể giúp gì cho bạn?**

📦 **Xem sản phẩm** - "Cho tôi xem sản phẩm", "Có những kính gì?"
🔍 **Tìm kiếm** - "Tìm kính Ray-Ban", "Kính chống ánh sáng xanh"
💰 **Giá** - "Kính giá 200k-500k", "Kính dưới 300k"
👤 **Giới tính** - "Kính nam", "Kính nữ", "Kính unisex"
🔧 **Chất liệu** - "Kính titanium", "Kính acetate"
🔥 **Bán chạy** - "Sản phẩm bán chạy", "Top best seller"
📞 **Liên hệ** - "Số điện thoại", "Địa chỉ shop"

👉 Bạn hãy thử hỏi tôi nhé!
"""
        return help_text
    
    def get_response(self, user_message):
        """Lấy phản hồi từ chatbot"""
        user_message_lower = user_message.lower().strip()
        
        # Kiểm tra từng intent
        for intent_name, intent_data in self.intents.items():
            for pattern in intent_data['patterns']:
                if pattern in user_message_lower:
                    if 'handler' in intent_data:
                        handler = getattr(self, intent_data['handler'])
                        if intent_name in ['search_product', 'price_range', 'gender_filter', 'material_filter']:
                            return handler(user_message_lower)
                        else:
                            return handler()
                    else:
                        import random
                        return random.choice(intent_data['responses'])
        
        # Nếu không match intent nào, hỗ trợ tìm kiếm chung
        return self.handle_search_product(user_message_lower)
    
    def close(self):
        self.product_data.close()

def format_price(price):
    """Định dạng giá tiền"""
    if price is None:
        return "0"
    return f"{int(price):,}".replace(',', '.')

# Singleton instance
chatbot_instance = None

def get_chatbot():
    global chatbot_instance
    if chatbot_instance is None:
        chatbot_instance = ChatbotAI()
    return chatbot_instance