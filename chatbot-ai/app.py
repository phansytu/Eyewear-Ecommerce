from flask import Flask, request, jsonify
from flask_cors import CORS
from mini_vector_store import MiniVectorStore
from mini_chatbot import MiniChatbot
import uuid
import os

# Vô hiệu hóa ONNX - ĐẶT ĐẦU TIÊN
os.environ["DISABLE_ONNX_PRECOMPILED"] = "1"
os.environ["HF_HUB_DISABLE_ONNX_DOWNLOADS"] = "1"
os.environ["TRANSFORMERS_OFFLINE"] = "1"

app = Flask(__name__)
CORS(app)

print("🔄 Initializing Vector Store...")
vector_store = MiniVectorStore()
print("🔄 Initializing Chatbot...")
chatbot = MiniChatbot(vector_store)

@app.route('/api/chat', methods=['POST', 'OPTIONS'])
def chat():
    if request.method == 'OPTIONS':
        return '', 200
    
    try:
        data = request.get_json()
        user_message = data.get('message', '')
        session_id = data.get('session_id', str(uuid.uuid4()))
        
        if not user_message:
            return jsonify({'success': False, 'reply': 'Vui lòng nhập tin nhắn!'})
        
        print(f"📨 Received: {user_message[:100]}")
        response_text = chatbot.get_response(user_message, session_id)
        
        return jsonify({
            'success': True,
            'reply': response_text,
            'message': user_message,
            'recommend_questions': [
                'Tìm sản phẩm kính',
                'Giá kính Ray-Ban',
                'Chính sách bảo hành',
                'Liên hệ tư vấn'
            ]
        })
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'reply': f'Lỗi: {str(e)}'})

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok', 'message': 'Chatbot API is running'})

if __name__ == '__main__':
    print("=" * 50)
    print("🚀 Mini Chatbot Server (NO ONNX)")
    print("=" * 50)
    print("📍 http://localhost:5000")
    print("📍 POST /api/chat")
    print("📍 GET /api/health")
    print("=" * 50)
    
    vector_store.build_index()
    
    print("✅ Server ready!")
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)