import re

class MiniChatbot:
    def __init__(self, vector_store):
        self.vector_store = vector_store
        self.keywords = {
            'price': ['giá', 'bao nhiêu', 'tiền', 'rẻ', 'đắt', 'mắc'],
            'search': ['tìm', 'kiếm', 'sản phẩm', 'kính', 'gọng', 'có'],
            'contact': ['liên hệ', 'hotline', 'địa chỉ', 'sđt', 'phone'],
            'policy': ['chính sách', 'bảo hành', 'đổi trả']
        }
    
    def get_response(self, message, session_id):
        msg_lower = message.lower()
        
        if any(w in msg_lower for w in ['chào', 'hi', 'hello', 'xin chào']):
            return self._greeting()
        elif any(w in msg_lower for w in self.keywords['search']):
            return self._search_product(message)
        elif any(w in msg_lower for w in self.keywords['price']):
            return self._price_query(msg_lower)
        elif any(w in msg_lower for w in self.keywords['contact']):
            return self._contact_info()
        elif any(w in msg_lower for w in self.keywords['policy']):
            return self._policy_info()
        else:
            return self._general_response(message)
    
    def _search_product(self, message):
        keyword = self._extract_keyword(message)
        
        if not keyword or len(keyword) < 2:
            return self._search_help()
        
        results = self.vector_store.search(keyword, top_k=3)
        
        if not results['ids'] or not results['ids'][0]:
            return f"🔍 Không tìm thấy sản phẩm liên quan đến '{keyword}'"
        
        response = f"🔍 **Kết quả tìm kiếm '{keyword}':**\n\n"
        for i, meta in enumerate(results['metadatas'][0][:3]):
            price = int(meta['price']) if meta['price'] else 0
            response += f"{i+1}. **{meta['name']}**\n"
            response += f"   🏷️ {meta['brand']}\n"
            response += f"   💰 {price:,}đ\n"
            response += f"   🔗 Xem: /product?id={meta['id']}\n\n"
        
        return response
    
    def _price_query(self, message):
        product_name = self._extract_product_name(message)
        
        if not product_name:
            return self._price_help()
        
        results = self.vector_store.search(product_name, top_k=1)
        
        if not results['ids'] or not results['ids'][0]:
            return f"💰 Không tìm thấy giá cho '{product_name}'"
        
        meta = results['metadatas'][0][0]
        price = int(meta['price']) if meta['price'] else 0
        
        return f"💰 **{meta['name']}** giá **{price:,}đ**\n🔗 /product?id={meta['id']}"
    
    def _extract_keyword(self, message):
        stop_words = {'tìm', 'kiếm', 'cho', 'tôi', 'hãy', 'có', 'sản', 'phẩm', 
                      'kính', 'mắt', 'gọng', 'nào', 'những', 'các', 'mà'}
        words = message.lower().split()
        keywords = [w for w in words if w not in stop_words and len(w) > 2]
        return ' '.join(keywords[:3]) if keywords else None
    
    def _extract_product_name(self, message):
        msg = message.lower()
        for w in ['giá', 'bao nhiêu', 'tiền', 'của', 'sản phẩm', 'kính']:
            msg = msg.replace(w, '')
        return msg.strip() if len(msg) > 2 else None
    
    def _greeting(self):
        return """👋 **Xin chào!** Tôi là trợ lý ảo TuKhanhHuy.

💡 **Tôi có thể giúp bạn:**
• 🔍 Tìm sản phẩm (VD: "tìm kính râm Ray-Ban")
• 💰 Xem giá (VD: "giá kính Ray-Ban")
• 📜 Chính sách bảo hành
• 📞 Liên hệ

Bạn cần tôi giúp gì?"""
    
    def _contact_info(self):
        return """📞 **Liên hệ TuKhanhHuy:**

📍 Quận 1, TP Hồ Chí Minh
📱 Hotline: 1900 1234 (8h-21h)
📧 Email: cskh@tukhanhhuy.com
💬 Facebook: fb.com/tukhanhhuy"""
    
    def _policy_info(self):
        return """📜 **Chính sách:**
✅ Bảo hành gọng 12 tháng
✅ Đổi trả 30 ngày
✅ 100% kính chính hãng
✅ Miễn phí ship đơn 150k+"""
    
    def _search_help(self):
        return """🔍 **Ví dụ tìm kiếm:**
• "tìm kính râm Ray-Ban"
• "kính nam chính hãng"
• "gọng kính Titanium"
• "kính chống ánh sáng xanh"

Hãy thử hỏi cụ thể hơn nhé!"""
    
    def _price_help(self):
        return """💰 **Ví dụ hỏi giá:**
• "giá kính Ray-Ban"
• "kính Titanium bao nhiêu tiền"
• "sản phẩm dưới 500k"

Bạn muốn xem giá sản phẩm nào?"""
    
    def _general_response(self, message):
        results = self.vector_store.search(message, top_k=2)
        if results['ids'] and results['ids'][0]:
            response = "🔍 **Sản phẩm liên quan:**\n\n"
            for meta in results['metadatas'][0]:
                price = int(meta['price']) if meta['price'] else 0
                response += f"• **{meta['name']}** - {price:,}đ\n"
            return response
        return self._search_help()