"""
=============================================================
CHATBOT ENGINE - Điều phối toàn bộ logic chatbot
=============================================================
Kết nối: IntentClassifier → KnowledgeBase → DB → ResponseGenerator
=============================================================
"""

import logging
from typing import Dict, List, Optional
from collections import defaultdict

from models.knowledge_base import KnowledgeBase
from models.intent_classifier import IntentClassifier
from models.response_generator import ResponseGenerator
from config import Config

logger = logging.getLogger(__name__)


class ChatbotEngine:
    """
    Engine chính điều phối toàn bộ luồng xử lý chatbot.
    
    Luồng xử lý:
    1. Nhận tin nhắn
    2. Phân tích intent + entities
    3. Truy vấn knowledge base
    4. Truy vấn database (nếu cần)
    5. Tạo câu trả lời
    6. Lưu lịch sử session
    """

    def __init__(self, db_connector=None):
        self.db = db_connector
        self.knowledge = KnowledgeBase()
        self.classifier = IntentClassifier()
        self.generator = ResponseGenerator()

        # Lưu lịch sử hội thoại theo session
        # {session_id: [{'role': 'user'|'bot', 'message': str}, ...]}
        self._sessions: Dict[str, List] = defaultdict(list)

    # ─── Public API ───────────────────────────────────────

    def load_knowledge(self, file_path: str) -> Dict:
        """Load/reload knowledge từ file .txt"""
        return self.knowledge.load_file(file_path)

    def process_message(self, message: str, session_id: str = 'default',
                        context_mode: str = 'auto') -> Dict:
        """
        Xử lý tin nhắn và trả về câu trả lời.
        
        Args:
            message: nội dung tin nhắn
            session_id: ID phiên làm việc
            context_mode: 'auto' | 'knowledge' | 'products'
        
        Returns:
            {reply, source, products, confidence}
        """
        # 1. Phân tích intent
        analysis = self.classifier.classify(message)
        intent = analysis['intent']
        entities = analysis['entities']
        confidence = analysis['confidence']

        logger.debug(f"Intent: {intent} ({confidence:.2f}), entities: {entities}")

        # Lưu lịch sử
        self._add_to_history(session_id, 'user', message)

        # 2. Tìm kiếm knowledge
        knowledge_results = []
        if context_mode in ('auto', 'knowledge') and self.knowledge.is_loaded():
            knowledge_results = self.knowledge.search(
                query=message,
                top_k=Config.TOP_K_ANSWERS,
                threshold=Config.SIMILARITY_THRESHOLD
            )

        # 3. Truy vấn database
        db_products = []
        if context_mode in ('auto', 'products') and self.db:
            db_products = self._query_database(intent, entities, message)

        # 4. Tạo câu trả lời
        # Nếu có sản phẩm từ DB, ưu tiên kết hợp với knowledge
        top_confidence = knowledge_results[0]['confidence'] if knowledge_results else 0

        result = self.generator.generate(
            intent=intent,
            entities=entities,
            knowledge_results=knowledge_results,
            db_products=db_products,
            confidence=top_confidence
        )

        # 5. Lưu câu trả lời vào lịch sử
        self._add_to_history(session_id, 'bot', result['reply'])

        return result

    # ─── Database query logic ─────────────────────────────

    def _query_database(self, intent: str, entities: Dict, message: str) -> List[Dict]:
        """Quyết định truy vấn database như thế nào dựa trên intent"""
        if not self.db:
            return []

        filters = {}
        limit = Config.MAX_PRODUCTS_RETURN

        try:
            # Theo giá
            if intent == 'search_by_price' or entities.get('price_value'):
                price = entities.get('price_value')
                if price:
                    # Tìm xem "dưới" hay "trên"
                    msg_lower = message.lower()
                    if any(w in msg_lower for w in ['dưới', 'không quá', 'tầm', 'khoảng']):
                        filters['max_price'] = price * 1.1  # thêm 10% buffer
                    elif any(w in msg_lower for w in ['trên', 'từ', 'hơn']):
                        filters['min_price'] = price * 0.9
                    else:
                        filters['min_price'] = price * 0.7
                        filters['max_price'] = price * 1.3

            # Theo giới tính
            if intent == 'search_by_gender' or entities.get('gender'):
                gender_raw = entities.get('gender', '').lower()
                gender_map = {
                    'nam': 'male', 'con trai': 'male', 'bạn trai': 'male',
                    'nữ': 'female', 'con gái': 'female', 'bạn gái': 'female',
                    'male': 'male', 'female': 'female', 'unisex': 'unisex'
                }
                mapped = gender_map.get(gender_raw)
                if mapped:
                    filters['gender'] = mapped

            # Theo chất liệu
            if intent == 'search_by_material' or entities.get('material'):
                filters['material'] = entities.get('material', '')

            # Tìm kiếm chung theo từ khóa
            if intent in ('search_product', 'consult_general', 'buy_intent'):
                # Trích xuất từ khóa quan trọng từ message
                filters['keyword'] = self._extract_search_keyword(message)

            # Tìm kiếm theo thương hiệu
            if entities.get('brand'):
                filters['brand'] = entities['brand']

            # Sản phẩm nổi bật khi chào/hỏi chung
            if intent in ('greeting', 'consult_general') and not filters:
                return self.db.get_featured_products(limit=3)

            if filters:
                filters['limit'] = limit
                return self.db.search_products(filters)

        except Exception as e:
            logger.error(f"DB query error: {e}")

        return []

    def _extract_search_keyword(self, message: str) -> str:
        """Trích xuất từ khóa tìm kiếm từ tin nhắn"""
        # Loại bỏ các cụm từ thông dụng
        noise_phrases = [
            'shop ơi', 'cho mình', 'cho tôi', 'cho em', 'bạn ơi',
            'giúp mình', 'tư vấn', 'muốn mua', 'cần mua', 'tìm',
            'kiếm', 'có bán', 'giới thiệu', 'gợi ý'
        ]
        msg = message.lower()
        for phrase in noise_phrases:
            msg = msg.replace(phrase, '')

        # Giữ lại từ quan trọng (đủ dài)
        words = [w for w in msg.split() if len(w) > 2]
        return ' '.join(words[:5])  # Tối đa 5 từ đầu tiên

    # ─── Session management ───────────────────────────────

    def _add_to_history(self, session_id: str, role: str, message: str):
        """Thêm tin nhắn vào lịch sử session"""
        history = self._sessions[session_id]
        history.append({'role': role, 'message': message})

        # Giới hạn lịch sử
        max_len = Config.MAX_HISTORY_PER_SESSION * 2  # * 2 vì cả user + bot
        if len(history) > max_len:
            self._sessions[session_id] = history[-max_len:]

    def get_session_history(self, session_id: str) -> List[Dict]:
        """Lấy lịch sử hội thoại của một session"""
        return self._sessions.get(session_id, [])

    def clear_session(self, session_id: str):
        """Xóa lịch sử session"""
        if session_id in self._sessions:
            del self._sessions[session_id]

    # ─── Info methods ──────────────────────────────────────

    def is_ready(self) -> bool:
        """Kiểm tra chatbot đã sẵn sàng"""
        return self.knowledge.is_loaded()

    def get_topics(self) -> List[str]:
        """Lấy danh sách chủ đề đã học"""
        return self.knowledge.get_topic_names()

    def get_qa_count(self) -> int:
        """Số cặp Q&A đã học"""
        return self.knowledge.get_qa_count()
