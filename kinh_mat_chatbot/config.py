"""
=============================================================
CONFIG - Cấu hình hệ thống Chatbot Kính Mắt
=============================================================
Chỉnh sửa các thông số kết nối database và cài đặt tại đây
=============================================================
"""

import os


class Config:
    # ─── Flask ────────────────────────────────────────────
    HOST = '0.0.0.0'
    PORT = 5000
    DEBUG = False  # Đặt True khi dev, False khi production
    SECRET_KEY = os.environ.get('SECRET_KEY', 'kinh-mat-chatbot-secret-2024')

    # ─── MySQL Database ────────────────────────────────────
    # ⚠️  Thay đổi các thông số này theo MySQL Workbench của bạn
    DB_HOST     = os.environ.get('DB_HOST', 'localhost')
    DB_PORT     = int(os.environ.get('DB_PORT', 3306))
    DB_USER     = os.environ.get('DB_USER', 'root')
    DB_PASSWORD = os.environ.get('DB_PASSWORD', '240805')
    DB_NAME     = os.environ.get('DB_NAME', 'eyewear_shop')
    DB_CHARSET  = 'utf8mb4'

    # Tùy chọn kết nối
    DB_POOL_SIZE      = 5
    DB_CONNECT_TIMEOUT = 10

    # ─── Chatbot ───────────────────────────────────────────
    # Đường dẫn file knowledge
    KNOWLEDGE_FILE = os.path.join('data', 'knowledge.txt')

    # Ngưỡng độ tương đồng để chấp nhận câu trả lời
    # (0.0 - 1.0, càng cao càng nghiêm ngặt)
    SIMILARITY_THRESHOLD = 0.35

    # Số sản phẩm tối đa trả về mỗi lần tìm kiếm
    MAX_PRODUCTS_RETURN = 5

    # Số câu trả lời backup khi không tìm được kết quả chính xác
    TOP_K_ANSWERS = 3

    # ─── Model Embedding (tùy chọn) ───────────────────────
    # Nếu muốn dùng sentence-transformers thì set USE_EMBEDDING = True
    # Nếu máy yếu hoặc không có internet để tải model thì để False
    # (sẽ dùng TF-IDF thay thế - vẫn hoạt động tốt với tiếng Việt)
    USE_EMBEDDING = False
    EMBEDDING_MODEL = 'paraphrase-multilingual-MiniLM-L12-v2'

    # ─── Session & History ────────────────────────────────
    # Số lượt hội thoại lưu trong memory mỗi session
    MAX_HISTORY_PER_SESSION = 10

    # ─── Logging ──────────────────────────────────────────
    LOG_FILE  = 'chatbot.log'
    LOG_LEVEL = 'INFO'
