import sys
import os

# Thêm dòng này để fix lỗi pkgutil
import pkgutil
if not hasattr(pkgutil, 'get_loader'):
    pkgutil.get_loader = pkgutil.find_loader

from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error
import re
import json
from datetime import datetime

app = Flask(__name__)
CORS(app)  # Cho phép CORS để Java có thể gọi API

# ==================== CẤU HÌNH DATABASE ====================
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '',  # Thay bằng mật khẩu MySQL của bạn
    'database': 'BanKinhThoiTrang',
    'charset': 'utf8mb4'
}

def get_db_connection():
    """Kết nối database"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        print(f"Lỗi kết nối database: {e}")
        return None

# ==================== HÀM TIỆN ÍCH ====================
def format_price(price):
    """Định dạng giá tiền"""
    if price is None:
        return "0"
    return f"{int(price):,}".replace(',', '.')

def extract_keywords(text):
    """Trích xuất từ khóa từ câu hỏi"""
    text = text.lower()
    # Loại bỏ các từ không cần thiết
    stop_words = ['tìm', 'kiếm', 'cho', 'tôi', 'hãy', 'giúp', 'muốn', 'xem']
    for word in stop_words:
        text = text.replace(word, '')
    return text.strip()

def extract_price_range(text):
    """Trích xuất khoảng giá"""
    text = text.lower()
    numbers = re.findall(r'(\d+(?:\.\d+)?)', text)
    prices = []
    for num in numbers:
        val = float(num)
        if 'k' in text or 'ngàn' in text or 'nghìn' in text:
            val = int(val * 1000)
        elif 'triệu' in text or 'tr' in text:
            val = int(val * 1000000)
        else:
            val = int(val)
        prices.append(val)
    
    if len(prices) >= 2:
        return min(prices), max(prices)
    elif len(prices) == 1:
        if 'dưới' in text or 'dưới' in text:
            return 0, prices[0]
        elif 'trên' in text:
            return prices[0], 10000000
    return None, None

# ==================== API CHATBOT ====================
@app.route('/api/chat', methods=['POST'])
def chat():
    """API chính cho chatbot"""
    try:
        data = request.get_json()
        user_message = data.get('message', '')
        
        if not user_message:
            return jsonify({'error': 'No message provided'}), 400
        
        response = process_message(user_message)
        
        return jsonify({
            'success': True,
            'response': response,
            'message': user_message
        })
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

def process_message(message):
    """Xử lý tin nhắn và trả về phản hồi"""
    msg_lower = message.lower()
    
    # 1. Chào hỏi
    if any(word in msg_lower for word in ['chào', 'hi', 'hello', 'xin chào']):
        return get_greeting_response()
    
    # 2. Cảm ơn / tạm biệt
    if any(word in msg_lower for word in ['cảm ơn', 'thank', 'tạm biệt', 'bye']):
        return get_goodbye_response()
    
    # 3. Giới thiệu / giúp đỡ
    if any(word in msg_lower for word in ['giúp', 'hướng dẫn', 'có thể', 'làm gì']):
        return get_help_response()
    
    # 4. Tìm kiếm sản phẩm theo từ khóa
    if any(word in msg_lower for word in ['tìm', 'kiếm', 'sản phẩm', 'kính']):
        return search_products(message)
    
    # 5. Lọc theo giá
    if any(word in msg_lower for word in ['giá', 'bao nhiêu', 'tiền']):
        return filter_by_price(message)
    
    # 6. Lọc theo giới tính
    if any(word in msg_lower for word in ['kính nam', 'kính nữ', 'nam', 'nữ']):
        return filter_by_gender(message)
    
    # 7. Lọc theo chất liệu
    if any(word in msg_lower for word in ['chất liệu', 'titanium', 'acetate', 'metal', 'plastic']):
        return filter_by_material(message)
    
    # 8. Sản phẩm bán chạy
    if any(word in msg_lower for word in ['bán chạy', 'hot', 'best seller', 'top']):
        return get_top_selling()
    
    # 9. Liên hệ
    if any(word in msg_lower for word in ['liên hệ', 'địa chỉ', 'hotline', 'sdt', 'phone']):
        return get_contact_info()
    
    # 10. Mặc định - tìm kiếm sản phẩm
    return search_products(message)

def get_db_products(query, params=None):
    """Lấy sản phẩm từ database"""
    conn = get_db_connection()
    if not conn:
        return []
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(query, params or ())
        results = cursor.fetchall()
        return results
    except Error as e:
        print(f"Query error: {e}")
        return []
    finally:
        cursor.close()
        conn.close()

def search_products(message):
    """Tìm kiếm sản phẩm"""
    keyword = extract_keywords(message)
    if len(keyword) < 2:
        return "Bạn muốn tìm sản phẩm gì? Hãy cho tôi biết tên hoặc thương hiệu nhé!"
    
    query = """
        SELECT id, name, brand, sale_price, gender, frame_material, stock
        FROM products 
        WHERE status = 'active' 
        AND (name LIKE %s OR brand LIKE %s)
        LIMIT 8
    """
    search_term = f"%{keyword}%"
    products = get_db_products(query, (search_term, search_term))
    
    if not products:
        return f"🔍 Rất tiếc, tôi không tìm thấy sản phẩm nào liên quan đến '{keyword}'. Bạn có thể thử từ khóa khác nhé!"
    
    response = f"🔍 **Kết quả tìm kiếm cho '{keyword}':**\n\n"
    for i, p in enumerate(products[:5]):
        response += f"{i+1}. **{p['name']}**\n"
        response += f"   🏷️ {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}₫\n"
        response += f"   👤 {p['gender']}\n\n"
    
    response += "👉 Bạn có muốn xem chi tiết sản phẩm nào không? (Ví dụ: xem sản phẩm số 1)"
    return response

def filter_by_price(message):
    """Lọc sản phẩm theo giá"""
    min_price, max_price = extract_price_range(message)
    
    if min_price is None and max_price is None:
        return "💰 Bạn muốn xem sản phẩm trong khoảng giá nào? (Ví dụ: 200k đến 500k, dưới 300k, trên 1 triệu)"
    
    if min_price is None:
        min_price = 0
    if max_price is None:
        max_price = 10000000
    
    query = """
        SELECT id, name, brand, sale_price, gender, frame_material
        FROM products 
        WHERE status = 'active' 
        AND sale_price BETWEEN %s AND %s
        ORDER BY sale_price ASC
        LIMIT 8
    """
    products = get_db_products(query, (min_price, max_price))
    
    if not products:
        return f"💰 Không tìm thấy sản phẩm nào trong khoảng giá {format_price(min_price)}đ - {format_price(max_price)}đ"
    
    response = f"💰 **Sản phẩm giá từ {format_price(min_price)}đ - {format_price(max_price)}đ:**\n\n"
    for i, p in enumerate(products[:5]):
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}₫\n\n"
    
    return response

def filter_by_gender(message):
    """Lọc sản phẩm theo giới tính"""
    msg_lower = message.lower()
    if 'nữ' in msg_lower:
        gender = 'Nữ'
    elif 'nam' in msg_lower:
        gender = 'Nam'
    else:
        return "Bạn muốn xem kính nam hay kính nữ?"
    
    query = """
        SELECT id, name, brand, sale_price, frame_material
        FROM products 
        WHERE status = 'active' AND gender = %s
        LIMIT 8
    """
    products = get_db_products(query, (gender,))
    
    if not products:
        return f"👤 Hiện chưa có sản phẩm kính {gender} nào."
    
    response = f"👤 **Kính {gender} tại TuKhanhHuy:**\n\n"
    for i, p in enumerate(products[:5]):
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}₫\n"
        response += f"   🔧 {p['frame_material']}\n\n"
    
    return response

def filter_by_material(message):
    """Lọc sản phẩm theo chất liệu"""
    msg_lower = message.lower()
    materials = {
        'titanium': 'Titanium',
        'acetate': 'Acetate',
        'metal': 'Metal',
        'plastic': 'Plastic',
        'tr90': 'TR90'
    }
    
    material = None
    for key, value in materials.items():
        if key in msg_lower:
            material = value
            break
    
    if not material:
        return "Bạn muốn tìm kính chất liệu gì? (Titanium, Acetate, Metal, Plastic, TR90)"
    
    query = """
        SELECT id, name, brand, sale_price, gender
        FROM products 
        WHERE status = 'active' AND frame_material = %s
        LIMIT 8
    """
    products = get_db_products(query, (material,))
    
    if not products:
        return f"🔧 Hiện chưa có sản phẩm nào với chất liệu {material}."
    
    response = f"🔧 **Kính chất liệu {material}:**\n\n"
    for i, p in enumerate(products[:5]):
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}₫\n"
        response += f"   👤 {p['gender']}\n\n"
    
    return response

def get_top_selling():
    """Lấy sản phẩm bán chạy"""
    query = """
        SELECT id, name, brand, sale_price, sold_quantity
        FROM products 
        WHERE status = 'active' 
        ORDER BY sold_quantity DESC 
        LIMIT 5
    """
    products = get_db_products(query)
    
    if not products:
        return "Chưa có dữ liệu sản phẩm bán chạy."
    
    response = "🔥 **Top sản phẩm bán chạy nhất:**\n\n"
    for i, p in enumerate(products):
        sold = p.get('sold_quantity', 0)
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}₫\n"
        response += f"   📦 Đã bán: {sold} sản phẩm\n\n"
    
    return response

def get_greeting_response():
    return """👋 Xin chào! Tôi là trợ lý ảo của TuKhanhHuy.

Tôi có thể giúp bạn:
📦 Tìm kiếm sản phẩm kính mắt
💰 Xem giá và khuyến mãi
👤 Lọc kính theo giới tính
🔧 Lọc theo chất liệu
🔥 Xem sản phẩm bán chạy
📞 Thông tin liên hệ

Bạn cần tôi giúp gì ạ?"""

def get_goodbye_response():
    return "Cảm ơn bạn đã trò chuyện! Chúc bạn một ngày tốt lành! Nếu cần hỗ trợ, hãy quay lại nhé 💙"

def get_help_response():
    return """🤖 **Tôi có thể giúp gì cho bạn?**

📦 **Xem sản phẩm** - "Cho tôi xem sản phẩm", "Có những kính gì?"
🔍 **Tìm kiếm** - "Tìm kính Ray-Ban", "Kính chống ánh sáng xanh"
💰 **Giá** - "Kính giá 200k-500k", "Kính dưới 300k"
👤 **Giới tính** - "Kính nam", "Kính nữ"
🔧 **Chất liệu** - "Kính titanium", "Kính acetate"
🔥 **Bán chạy** - "Sản phẩm bán chạy", "Top best seller"
📞 **Liên hệ** - "Số điện thoại", "Địa chỉ shop"

👉 Bạn hãy thử hỏi tôi nhé!"""

def get_contact_info():
    return """📞 **Thông tin liên hệ TuKhanhHuy:**

📍 Địa chỉ: Quận 1, Thành phố Hồ Chí Minh
📱 Hotline: 1900 1234
📧 Email: cskh@tukhanhhuy.com
💬 Facebook: fb.com/tukhanhhuy
💚 Zalo: 1900 1234

⏰ Thời gian làm việc: 8h00 - 21h00 tất cả các ngày"""

# ==================== API KHÁC ====================
@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'ok', 'message': 'Chatbot API is running'})

@app.route('/api/products/search', methods=['GET'])
def api_search_products():
    keyword = request.args.get('q', '')
    if not keyword:
        return jsonify({'products': []})
    
    query = """
        SELECT id, name, brand, sale_price, gender, frame_material
        FROM products 
        WHERE status = 'active' 
        AND (name LIKE %s OR brand LIKE %s)
        LIMIT 10
    """
    search_term = f"%{keyword}%"
    products = get_db_products(query, (search_term, search_term))
    
    result = []
    for p in products:
        result.append({
            'id': p['id'],
            'name': p['name'],
            'brand': p['brand'],
            'price': format_price(p['sale_price']),
            'gender': p['gender'],
            'material': p['frame_material']
        })
    
    return jsonify({'products': result})

# ==================== CHẠY SERVER ====================
if __name__ == '__main__':
    print("=" * 50)
    print("🚀 TuKhanhHuy Chatbot AI Server")
    print("=" * 50)
    print("📍 API Endpoint: http://localhost:5000")
    print("📍 Chat API: http://localhost:5000/api/chat")
    print("📍 Search API: http://localhost:5000/api/products/search")
    print("📍 Health Check: http://localhost:5000/api/health")
    print("=" * 50)
    print("✅ Server đang chạy...")
    print("Nhấn Ctrl+C để dừng server")
    print("=" * 50)
    
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False)