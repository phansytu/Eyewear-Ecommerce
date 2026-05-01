import sys
import types

# Monkey patch cho pkgutil trong Python 3.14
import pkgutil

def get_loader_fallback(module_name):
    """Fallback cho get_loader trong Python 3.14"""
    try:
        import importlib
        spec = importlib.util.find_spec(module_name)
        if spec and spec.loader:
            return spec.loader
        return None
    except:
        return None

if not hasattr(pkgutil, 'get_loader'):
    pkgutil.get_loader = get_loader_fallback

if not hasattr(pkgutil, 'find_loader'):
    pkgutil.find_loader = get_loader_fallback

from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error
import re

app = Flask(__name__)

# CORS configuration - QUAN TRỌNG
CORS(app, resources={
    r"/api/*": {
        "origins": "*",
        "methods": ["GET", "POST", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization"]
    }
})

# ==================== CẤU HÌNH DATABASE ====================
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '240805',
    'database': 'eyewear_shop',
    'charset': 'utf8mb4'
}

def get_db_connection():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        print(f"Lỗi database: {e}")
        return None

def format_price(price):
    if price is None:
        return "0"
    return f"{int(price):,}".replace(',', '.')

# ==================== API ====================
@app.route('/api/health', methods=['GET', 'OPTIONS'])
def health_check():
    if request.method == 'OPTIONS':
        return '', 200
    return jsonify({'status': 'ok', 'message': 'Chatbot API is running'})

@app.route('/api/chat', methods=['POST', 'OPTIONS'])
def chat():
    # Handle preflight request
    if request.method == 'OPTIONS':
        return '', 200
    
    try:
        # Log request
        print(f"📨 Request method: {request.method}")
        print(f"📨 Request headers: {dict(request.headers)}")
        
        # Get JSON data
        data = request.get_json()
        if not data:
            print("❌ No JSON data received")
            return jsonify({
                'success': False,
                'reply': 'Không nhận được dữ liệu. Vui lòng thử lại!'
            }), 200
        
        user_message = data.get('message', '')
        session_id = data.get('session_id', '')
        
        print(f"📨 Received message: {user_message}")
        print(f"📨 Session ID: {session_id}")
        
        if not user_message:
            return jsonify({
                'success': False,
                'reply': 'Vui lòng nhập tin nhắn!'
            }), 200
        
        response_text = process_message(user_message)
        
        result = {
            'success': True,
            'reply': response_text,
            'message': user_message,
            'session_id': session_id,
            'recommend_questions': get_recommend_questions(user_message)
        }
        
        print(f"📤 Response: {result['reply'][:100]}...")
        return jsonify(result), 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'reply': f'Xin lỗi, đã có lỗi xảy ra: {str(e)}',
            'error': str(e)
        }), 200

def get_recommend_questions(message):
    msg_lower = message.lower()
    
    if any(w in msg_lower for w in ['tìm', 'kiếm', 'sản phẩm']):
        return ['Kính râm Ray-Ban', 'Gọng kính Titanium', 'Kính chống ánh sáng xanh']
    elif any(w in msg_lower for w in ['giá', 'bao nhiêu']):
        return ['Sản phẩm dưới 500k', 'Sản phẩm 500k - 1 triệu', 'Sản phẩm trên 1 triệu']
    elif any(w in msg_lower for w in ['liên hệ', 'địa chỉ']):
        return ['Hotline hỗ trợ', 'Địa chỉ cửa hàng', 'Email liên hệ']
    else:
        return ['Xem sản phẩm', 'Bảng giá', 'Chính sách bảo hành', 'Liên hệ']

def process_message(message):
    msg_lower = message.lower()
    
    print(f"🔍 Processing message: {msg_lower}")
    
    if any(w in msg_lower for w in ['chào', 'hi', 'hello', 'xin chào']):
        return "👋 Xin chào! Tôi là trợ lý ảo của TuKhanhHuy. Tôi có thể giúp gì cho bạn hôm nay?\n\n💡 Gợi ý: 'tìm kính râm', 'giá kính', 'chính sách bảo hành', 'liên hệ'"
    
    if any(w in msg_lower for w in ['tìm', 'kiếm', 'sản phẩm', 'kính']):
        return search_products(message)
    
    if any(w in msg_lower for w in ['giá', 'bao nhiêu', 'tiền']):
        return filter_by_price(message)
    
    if any(w in msg_lower for w in ['kính nam', 'kính nữ', 'nam giới', 'nữ giới']):
        return filter_by_gender(message)
    
    if any(w in msg_lower for w in ['chất liệu', 'titanium', 'acetate', 'metal']):
        return filter_by_material(message)
    
    if any(w in msg_lower for w in ['bán chạy', 'hot', 'top']):
        return get_top_selling()
    
    if any(w in msg_lower for w in ['liên hệ', 'địa chỉ', 'hotline', 'sđt', 'phone']):
        return get_contact_info()
    
    if any(w in msg_lower for w in ['chính sách', 'bảo hành', 'đổi trả']):
        return get_policy_info()
    
    return search_products(message)

def search_products(message):
    keyword = message.lower()
    stop_words = ['tìm', 'kiếm', 'cho', 'tôi', 'hãy', 'sản phẩm', 'kính', 'mắt']
    for w in stop_words:
        keyword = keyword.replace(w, '')
    keyword = keyword.strip()
    
    if len(keyword) < 2:
        return "🔍 Bạn muốn tìm sản phẩm gì? Ví dụ: 'tìm kính Ray-Ban', 'kính râm', 'gọng kính Titanium'"
    
    print(f"🔍 Searching for: '{keyword}'")
    
    conn = get_db_connection()
    if not conn:
        return "❌ Xin lỗi, không thể kết nối database. Vui lòng thử lại sau!"
    
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT id, name, brand, sale_price, price, gender, stock 
        FROM products 
        WHERE status = 'active' 
        AND (name LIKE %s OR brand LIKE %s)
        LIMIT 5
    """
    search_term = f"%{keyword}%"
    cursor.execute(query, (search_term, search_term))
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not products:
        return f"🔍 Không tìm thấy sản phẩm nào liên quan đến '{keyword}'.\n\n💡 Gợi ý: Hãy thử tìm với từ khóa khác như 'kính râm', 'gọng kính', 'Ray-Ban'"
    
    response = f"🔍 **Kết quả tìm kiếm cho '{keyword}':**\n\n"
    for i, p in enumerate(products):
        price_display = format_price(p.get('sale_price') or p.get('price', 0))
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 Giá: {price_display}đ\n"
        response += f"   👤 Giới tính: {p.get('gender', 'Unisex')}\n"
        response += f"   📦 Tồn kho: {p.get('stock', 0)}\n\n"
    
    response += "👉 Bạn có thể hỏi thêm: 'giá sản phẩm này', 'còn hàng không'"
    return response

def filter_by_price(message):
    numbers = re.findall(r'\d+', message)
    
    if len(numbers) == 1:
        price = int(numbers[0])
        if 'k' in message.lower() or 'nghìn' in message.lower():
            price *= 1000
        elif 'triệu' in message.lower() or 'tr' in message.lower():
            price *= 1000000
        return f"💰 Bạn muốn xem sản phẩm giá khoảng {format_price(price)}đ.\n\n💡 Hãy thử hỏi: 'tìm kính giá {price}' hoặc 'sản phẩm dưới {price}đ'"
    
    if len(numbers) < 2:
        return "💰 Bạn muốn xem giá bao nhiêu? Ví dụ:\n- 'kính giá 200k đến 500k'\n- 'sản phẩm dưới 1 triệu'\n- 'kính trên 2 triệu'"
    
    min_price = int(numbers[0])
    max_price = int(numbers[1])
    
    if 'k' in message.lower() or 'nghìn' in message.lower():
        min_price *= 1000
        max_price *= 1000
    elif 'triệu' in message.lower() or 'tr' in message.lower():
        min_price *= 1000000
        max_price *= 1000000
    
    conn = get_db_connection()
    if not conn:
        return "❌ Xin lỗi, không thể kết nối database!"
    
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT id, name, brand, sale_price 
        FROM products 
        WHERE status = 'active' 
        AND sale_price BETWEEN %s AND %s
        LIMIT 5
    """
    cursor.execute(query, (min_price, max_price))
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not products:
        return f"💰 Không có sản phẩm nào trong khoảng {format_price(min_price)}đ - {format_price(max_price)}đ"
    
    response = f"💰 **Sản phẩm giá {format_price(min_price)}đ - {format_price(max_price)}đ:**\n\n"
    for i, p in enumerate(products):
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}đ\n\n"
    
    return response

def filter_by_gender(message):
    if 'nữ' in message.lower():
        gender = 'Nữ'
        display = 'nữ'
    else:
        gender = 'Nam'
        display = 'nam'
    
    conn = get_db_connection()
    if not conn:
        return "❌ Xin lỗi, không thể kết nối database!"
    
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT id, name, brand, sale_price 
        FROM products 
        WHERE status = 'active' AND gender = %s
        LIMIT 5
    """
    cursor.execute(query, (gender,))
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not products:
        return f"👤 Hiện chưa có sản phẩm kính {display} nào"
    
    response = f"👤 **Kính {display} tại TuKhanhHuy:**\n\n"
    for i, p in enumerate(products):
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}đ\n\n"
    
    return response

def filter_by_material(message):
    material_map = {'titanium': 'Titanium', 'acetate': 'Acetate', 'metal': 'Metal'}
    material = None
    for key, val in material_map.items():
        if key in message.lower():
            material = val
            break
    
    if not material:
        return "🔧 Bạn muốn tìm chất liệu gọng kính nào?\n\n💡 Gợi ý: 'gọng Titanium', 'kính Acetate', 'gọng kim loại'"
    
    conn = get_db_connection()
    if not conn:
        return "❌ Xin lỗi, không thể kết nối database!"
    
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT id, name, brand, sale_price 
        FROM products 
        WHERE status = 'active' AND frame_material = %s
        LIMIT 5
    """
    cursor.execute(query, (material,))
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not products:
        return f"🔧 Chưa có sản phẩm chất liệu {material}"
    
    response = f"🔧 **Kính gọng {material}:**\n\n"
    for i, p in enumerate(products):
        response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
        response += f"   💰 {format_price(p['sale_price'])}đ\n\n"
    
    return response

def get_top_selling():
    conn = get_db_connection()
    if not conn:
        return "❌ Xin lỗi, không thể kết nối database!"
    
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT id, name, brand, sale_price, sold_quantity
        FROM products 
        WHERE status = 'active' 
        ORDER BY sold_quantity DESC 
        LIMIT 5
    """
    cursor.execute(query)
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    
    if not products or all(p.get('sold_quantity', 0) == 0 for p in products):
        return "🔥 Chưa có dữ liệu sản phẩm bán chạy. Hãy quay lại sau nhé!"
    
    response = "🔥 **Top sản phẩm bán chạy nhất:**\n\n"
    for i, p in enumerate(products):
        sold = p.get('sold_quantity', 0)
        if sold > 0:
            response += f"{i+1}. **{p['name']}** - {p['brand']}\n"
            response += f"   💰 {format_price(p['sale_price'])}đ\n"
            response += f"   📦 Đã bán: {sold}\n\n"
    
    return response

def get_contact_info():
    return """📞 **Thông tin liên hệ TuKhanhHuy:**

📍 **Địa chỉ:** Quận 1, Thành phố Hồ Chí Minh
📱 **Hotline:** 1900 1234 (8h00 - 21h00)
📧 **Email:** cskh@tukhanhhuy.com
💬 **Facebook:** fb.com/tukhanhhuy
📲 **Zalo:** 1900 1234

⏰ **Thời gian làm việc:** 8h00 - 21h00 tất cả các ngày

👉 Chúng tôi luôn sẵn sàng hỗ trợ bạn!"""

def get_policy_info():
    return """📜 **Chính sách của TuKhanhHuy:**

✅ **Bảo hành:** Gọng kính được bảo hành 12 tháng
✅ **Đổi trả:** Hỗ trợ đổi trả trong vòng 30 ngày
✅ **Chính hãng:** 100% kính chính hãng, có giấy tờ đầy đủ
✅ **Tư vấn:** Đo mắt và tư vấn miễn phí tại cửa hàng
✅ **Vận chuyển:** Giao siêu tốc 2h (nội thành), miễn phí ship đơn từ 150.000đ

👉 Bạn cần hỗ trợ thêm về chính sách nào không?"""

@app.route('/api/products/search', methods=['GET'])
def api_search_products():
    keyword = request.args.get('q', '')
    if not keyword:
        return jsonify({'products': []})
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'products': []})
    
    cursor = conn.cursor(dictionary=True)
    search_term = f"%{keyword}%"
    query = """
        SELECT id, name, brand, sale_price, gender
        FROM products 
        WHERE status = 'active' 
        AND (name LIKE %s OR brand LIKE %s)
        LIMIT 10
    """
    cursor.execute(query, (search_term, search_term))
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    
    result = []
    for p in products:
        result.append({
            'id': p['id'],
            'name': p['name'],
            'brand': p['brand'],
            'price': format_price(p['sale_price']),
            'gender': p['gender']
        })
    
    return jsonify({'products': result})

if __name__ == '__main__':
    print("=" * 50)
    print("🚀 Chatbot AI Server Starting...")
    print("=" * 50)
    print(f"📍 API URL: http://localhost:5000")
    print(f"📍 Chat endpoint: POST http://localhost:5000/api/chat")
    print(f"📍 Health check: GET http://localhost:5000/api/health")
    print("=" * 50)
    print("✅ Server is running. Press Ctrl+C to stop.")
    print("=" * 50)
    
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False)