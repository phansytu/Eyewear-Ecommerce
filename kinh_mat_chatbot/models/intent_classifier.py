"""
=============================================================
INTENT CLASSIFIER - Phân loại ý định của người dùng
=============================================================
Không dùng model AI nặng.
Sử dụng rule-based + keyword matching — đủ hiệu quả cho
chatbot bán hàng tiếng Việt.
=============================================================
"""

import re
from typing import Dict, List, Tuple, Optional


# =============================================================
#  ĐỊNH NGHĨA INTENT
# =============================================================

INTENTS = {
    # Tìm kiếm sản phẩm
    'search_product':       ['tìm', 'kiếm', 'có', 'bán', 'muốn mua', 'cho xem', 'giới thiệu', 'gợi ý', 'show'],
    'search_by_price':      ['giá', 'bao nhiêu', 'rẻ', 'đắt', 'tầm', 'khoảng', 'dưới', 'trên', 'budget', 'tiền'],
    'search_by_gender':     ['nam', 'nữ', 'unisex', 'con trai', 'con gái', 'bạn trai', 'bạn gái', 'chồng', 'vợ'],
    'search_by_material':   ['kim loại', 'nhựa', 'titan', 'acetate', 'tr90', 'inox', 'hợp kim', 'chất liệu'],
    'search_by_style':      ['phong cách', 'vintage', 'hàn quốc', 'thời trang', 'công sở', 'cá tính', 'classic', 'sport'],

    # Tư vấn
    'consult_face':         ['khuôn mặt', 'mặt tròn', 'mặt vuông', 'mặt dài', 'mặt trái xoan', 'hình dạng mặt'],
    'consult_general':      ['tư vấn', 'nên mua', 'phù hợp', 'thích hợp', 'hợp với', 'cho mình', 'giúp chọn'],

    # Thông tin kỹ thuật
    'ask_blue_light':       ['chống ánh sáng xanh', 'blue light', 'chống sáng xanh', 'anti blue', 'chống xanh'],
    'ask_uv':               ['chống uv', 'uv400', 'tia cực tím', 'chống nắng', 'bảo vệ mắt'],
    'ask_photochromic':     ['đổi màu', 'photochromic', 'đổi màu tự động', 'transition'],
    'ask_lens':             ['tròng kính', 'mắt kính', 'trong kinh', 'lens', 'độ cận', 'độ loạn'],

    # Dịch vụ
    'ask_shipping':         ['ship', 'giao hàng', 'vận chuyển', 'giao đến', 'mấy ngày', 'bao lâu'],
    'ask_warranty':         ['bảo hành', 'đổi trả', 'hoàn tiền', 'đổi hàng', 'trả lại', 'hỏng'],
    'ask_try_on':           ['thử', 'ướm', 'xem mẫu', 'mặc thử'],
    'ask_payment':          ['thanh toán', 'chuyển khoản', 'cod', 'tiền mặt', 'momo', 'zalopay', 'vnpay'],
    'ask_location':         ['ở đâu', 'địa chỉ', 'cửa hàng', 'shop', 'chi nhánh', 'hà nội', 'hcm'],

    # Hành động
    'buy_intent':           ['mua', 'đặt hàng', 'order', 'chốt', 'lấy cái', 'cho mình'],
    'ask_discount':         ['giảm giá', 'khuyến mãi', 'sale', 'ưu đãi', 'coupon', 'mã giảm', 'combo'],

    # Chào hỏi & chung
    'greeting':             ['xin chào', 'hello', 'hi', 'chào', 'hey', 'alo', 'cho hỏi'],
    'thanks':               ['cảm ơn', 'thank', 'thanks', 'cám ơn'],
    'goodbye':              ['tạm biệt', 'bye', 'goodbye', 'thôi nhé', 'ok rồi'],
    'complaint':            ['tệ', 'kém', 'phàn nàn', 'không đúng', 'sai', 'khác hình', 'thất vọng'],
    'urgent':               ['gấp', 'nhanh', 'khẩn', 'ngay', 'hôm nay', 'sớm nhất'],
}

# =============================================================
#  ENTITY PATTERNS
# =============================================================

ENTITY_PATTERNS = {
    'price': [
        r'(\d+(?:\.\d+)?)\s*(?:nghìn|k|ngàn)',     # 200k, 300 nghìn
        r'(\d+(?:\.\d+)?)\s*(?:triệu|tr)',           # 1.5 triệu
        r'(\d{3,})\s*(?:đồng|vnd)?',                # 500000
        r'(?:dưới|trên|tầm|khoảng)\s*(\d+\w*)',     # dưới 500k
    ],
    'gender': [
        r'\b(nam|nữ|unisex|con trai|con gái)\b',
    ],
    'face_shape': [
        r'mặt\s+(tròn|vuông|dài|trái xoan|oval|tam giác)',
        r'(tròn|vuông|dài|trái xoan)\s+mặt',
    ],
    'material': [
        r'\b(titan|titanium|kim loại|nhựa|acetate|tr90|inox|hợp kim)\b',
    ],
    'style': [
        r'\b(vintage|retro|hàn quốc|korean|công sở|business|thời trang|cá tính|sport)\b',
    ],
    'brand': [
        r'\b(rayban|ray-ban|oakley|gucci|prada|dior|versace|polaroid)\b',
    ]
}


# =============================================================
#  CLASSIFIER
# =============================================================

class IntentClassifier:
    """
    Phân loại ý định và trích xuất thực thể từ tin nhắn tiếng Việt.
    Rule-based, không cần model ML.
    """

    def classify(self, message: str) -> Dict:
        """
        Phân tích tin nhắn, trả về intent và entities.
        
        Returns:
            {
                'intent': str,
                'sub_intents': [str, ...],
                'entities': {key: value, ...},
                'confidence': float,
                'is_question': bool
            }
        """
        msg_lower = self._normalize(message)

        # 1. Phát hiện tất cả intents có thể
        matched_intents = self._match_intents(msg_lower)

        # 2. Chọn intent chính
        primary_intent, confidence = self._select_primary(matched_intents, msg_lower)

        # 3. Trích xuất entities
        entities = self._extract_entities(msg_lower)

        # 4. Kiểm tra có phải câu hỏi không
        is_question = self._is_question(message)

        return {
            'intent': primary_intent,
            'sub_intents': [i for i, _ in matched_intents if i != primary_intent][:3],
            'entities': entities,
            'confidence': confidence,
            'is_question': is_question,
            'normalized': msg_lower
        }

    def _normalize(self, text: str) -> str:
        """Chuẩn hóa văn bản"""
        text = text.lower().strip()
        text = re.sub(r'\s+', ' ', text)
        # Một số chuẩn hóa thường gặp
        replacements = {
            'mk': 'mình',
            'bn': 'bạn',
            'ko': 'không',
            'k ': 'không ',
            'dc': 'được',
            'đc': 'được',
            'vs': 'với',
            'đt': 'điện thoại',
            'sdt': 'số điện thoại',
            'ng': 'người',
            'ntn': 'như thế nào',
            'bh': 'bao giờ',
            'bnh': 'bao nhiêu',
            'oke': 'ok',
            'oki': 'ok',
        }
        for abbr, full in replacements.items():
            text = text.replace(abbr, full)
        return text

    def _match_intents(self, msg: str) -> List[Tuple[str, float]]:
        """Tìm tất cả intents khớp với tin nhắn"""
        matched = []
        for intent, keywords in INTENTS.items():
            score = 0
            matched_kw = 0
            for kw in keywords:
                if kw in msg:
                    matched_kw += 1
                    # Từ khóa dài hơn = trọng số cao hơn
                    score += len(kw.split())
            if matched_kw > 0:
                # Normalize score
                confidence = min(0.95, score / (len(keywords) * 0.5 + 1))
                if matched_kw >= 2:
                    confidence = min(0.95, confidence * 1.3)
                matched.append((intent, confidence))

        matched.sort(key=lambda x: x[1], reverse=True)
        return matched

    def _select_primary(self, matched: List[Tuple], msg: str) -> Tuple[str, float]:
        """Chọn intent chính dựa trên priority rules"""
        if not matched:
            return 'unknown', 0.0

        # Priority override rules
        priority_rules = [
            # Nếu có giá + tìm kiếm → search_by_price
            ('search_by_price', ['search_product']),
            # Nếu có giới tính + tìm kiếm → search_by_gender
            ('search_by_gender', ['search_product']),
            # Complaint → cao hơn search
            ('complaint', ['search_product', 'consult_general']),
        ]

        matched_intents = {i for i, _ in matched}
        for primary, triggers in priority_rules:
            if primary in matched_intents and any(t in matched_intents for t in triggers):
                conf = next(c for i, c in matched if i == primary)
                return primary, conf

        return matched[0]

    def _extract_entities(self, msg: str) -> Dict:
        """Trích xuất các thực thể (giá, giới tính, khuôn mặt...)"""
        entities = {}

        for entity_type, patterns in ENTITY_PATTERNS.items():
            for pattern in patterns:
                match = re.search(pattern, msg, re.IGNORECASE)
                if match:
                    value = match.group(1) if match.lastindex else match.group(0)
                    entities[entity_type] = value.strip()
                    break

        # Xử lý giá tiền thành số
        if 'price' in entities:
            entities['price_value'] = self._parse_price(entities['price'], msg)

        return entities

    def _parse_price(self, price_str: str, full_msg: str) -> Optional[float]:
        """Chuyển đổi chuỗi giá thành số"""
        try:
            price_str = price_str.lower().replace(',', '').replace('.', '')
            # Kiểm tra đơn vị
            if 'triệu' in full_msg or 'tr' in full_msg:
                return float(price_str) * 1_000_000
            elif 'nghìn' in full_msg or 'k' in full_msg or 'ngàn' in full_msg:
                return float(price_str) * 1_000
            else:
                val = float(price_str)
                if val < 1000:
                    return val * 1_000  # 300 → 300k
                return val
        except Exception:
            return None

    def _is_question(self, text: str) -> bool:
        """Kiểm tra có phải câu hỏi"""
        question_indicators = [
            '?', 'không', 'chưa', 'sao', 'nào', 'nào',
            'bao nhiêu', 'như thế nào', 'tại sao', 'vì sao',
            'ở đâu', 'khi nào', 'ai', 'gì', 'mấy'
        ]
        text_lower = text.lower()
        return any(ind in text_lower for ind in question_indicators)
