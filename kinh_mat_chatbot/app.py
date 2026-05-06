"""
=============================================================
CHATBOT TU VAN KINH MAT - FLASK API
=============================================================
Author: KinhMat AI
Version: 1.0.0
Python: 3.8+
=============================================================
"""

from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import logging
import os
from datetime import datetime

from models.chatbot_engine import ChatbotEngine
from utils.db_connector import DatabaseConnector
from config import Config

# ─── Khởi tạo Flask ───────────────────────────────────────
app = Flask(__name__)
CORS(app)  # Cho phép Java frontend gọi API
app.config.from_object(Config)

# ─── Logging ──────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler('chatbot.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# ─── Khởi tạo engine ──────────────────────────────────────
db = DatabaseConnector()
engine = ChatbotEngine(db_connector=db)

# Load knowledge khi khởi động
knowledge_path = os.path.join('data', 'knowledge.txt')
if os.path.exists(knowledge_path):
    engine.load_knowledge(knowledge_path)
    logger.info("✅ Knowledge loaded successfully")
else:
    logger.warning("⚠️  knowledge.txt not found. Run /api/retrain after adding file.")


# =============================================================
#  API ENDPOINTS
# =============================================================

@app.route('/')
def index():
    """Giao diện test chatbot"""
    return render_template('index.html')


@app.route('/api/health', methods=['GET'])
def health_check():
    """Kiểm tra trạng thái server"""
    db_status = db.test_connection()
    return jsonify({
        'status': 'ok',
        'timestamp': datetime.now().isoformat(),
        'database': 'connected' if db_status else 'disconnected',
        'knowledge_loaded': engine.is_ready(),
        'topics_count': len(engine.get_topics()),
        'qa_pairs_count': engine.get_qa_count(),
        'version': '1.0.0'
    })


@app.route('/api/chat', methods=['POST'])
def chat():
    """
    Endpoint chính nhận tin nhắn và trả lời
    
    Request body (JSON):
    {
        "message": "string",
        "session_id": "string (optional)",
        "context": "products|knowledge|auto (optional, default: auto)"
    }
    
    Response:
    {
        "reply": "string",
        "source": "knowledge|database|hybrid|fallback",
        "products": [...] (nếu có),
        "confidence": 0.0-1.0,
        "session_id": "string"
    }
    """
    try:
        data = request.get_json()
        if not data or 'message' not in data:
            return jsonify({'error': 'Thiếu trường message'}), 400

        message = data.get('message', '').strip()
        session_id = data.get('session_id', 'default')
        context_mode = data.get('context', 'auto')

        if not message:
            return jsonify({'error': 'Tin nhắn không được để trống'}), 400

        if len(message) > 1000:
            return jsonify({'error': 'Tin nhắn quá dài (tối đa 1000 ký tự)'}), 400

        logger.info(f"[{session_id}] User: {message[:80]}...")

        # Xử lý tin nhắn
        result = engine.process_message(
            message=message,
            session_id=session_id,
            context_mode=context_mode
        )

        logger.info(f"[{session_id}] Bot ({result['source']}): {result['reply'][:60]}...")

        return jsonify({
            'reply': result['reply'],
            'source': result['source'],
            'products': result.get('products', []),
            'confidence': result.get('confidence', 0.0),
            'session_id': session_id,
            'timestamp': datetime.now().isoformat()
        })

    except Exception as e:
        logger.error(f"Chat error: {e}", exc_info=True)
        return jsonify({
            'reply': 'Xin lỗi, hệ thống đang gặp sự cố. Vui lòng thử lại sau!',
            'source': 'error',
            'error': str(e)
        }), 500


@app.route('/api/retrain', methods=['POST'])
def retrain():
    """
    Huấn luyện lại chatbot từ file knowledge.txt
    
    Request body (JSON, optional):
    {
        "file_path": "data/knowledge.txt"  (optional)
    }
    """
    try:
        data = request.get_json() or {}
        file_path = data.get('file_path', os.path.join('data', 'knowledge.txt'))

        if not os.path.exists(file_path):
            return jsonify({'error': f'File không tồn tại: {file_path}'}), 404

        stats = engine.load_knowledge(file_path)

        logger.info(f"✅ Retrain complete: {stats}")
        return jsonify({
            'status': 'success',
            'message': 'Huấn luyện lại thành công!',
            'stats': stats,
            'timestamp': datetime.now().isoformat()
        })

    except Exception as e:
        logger.error(f"Retrain error: {e}", exc_info=True)
        return jsonify({'error': str(e)}), 500


@app.route('/api/topics', methods=['GET'])
def get_topics():
    """Lấy danh sách chủ đề đã học"""
    topics = engine.get_topics()
    return jsonify({
        'topics': topics,
        'count': len(topics)
    })


@app.route('/api/products/search', methods=['GET'])
def search_products():
    """
    Tìm kiếm sản phẩm trực tiếp từ database
    
    Query params:
    - q: từ khóa tìm kiếm
    - brand: thương hiệu
    - gender: male|female|unisex
    - material: chất liệu
    - min_price, max_price: khoảng giá
    - limit: số kết quả (default 10)
    """
    try:
        filters = {
            'keyword': request.args.get('q', ''),
            'brand': request.args.get('brand', ''),
            'gender': request.args.get('gender', ''),
            'material': request.args.get('material', ''),
            'min_price': request.args.get('min_price', type=float),
            'max_price': request.args.get('max_price', type=float),
            'limit': request.args.get('limit', 10, type=int)
        }

        products = db.search_products(filters)
        return jsonify({
            'products': products,
            'count': len(products),
            'filters': filters
        })

    except Exception as e:
        logger.error(f"Product search error: {e}")
        return jsonify({'error': str(e)}), 500


@app.route('/api/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    """Lấy chi tiết một sản phẩm"""
    try:
        product = db.get_product_by_id(product_id)
        if not product:
            return jsonify({'error': 'Không tìm thấy sản phẩm'}), 404
        return jsonify({'product': product})
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# =============================================================
#  MAIN
# =============================================================

if __name__ == '__main__':
    print("=" * 60)
    print("  CHATBOT TU VAN KINH MAT - KinhMat AI v1.0")
    print("=" * 60)
    print(f"  Server: http://localhost:{Config.PORT}")
    print(f"  API:    http://localhost:{Config.PORT}/api/chat")
    print(f"  Health: http://localhost:{Config.PORT}/api/health")
    print("=" * 60)
    app.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=Config.DEBUG
    )
