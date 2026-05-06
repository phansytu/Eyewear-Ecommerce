"""
=============================================================
RESPONSE GENERATOR - Tạo câu trả lời tự nhiên tiếng Việt
=============================================================
Kết hợp kết quả từ knowledge base và database thành
câu trả lời tự nhiên, thân thiện.
=============================================================
"""

import random
from typing import List, Dict, Optional


# =============================================================
#  TEMPLATES CÂU TRẢ LỜI
# =============================================================

GREETINGS = [
    "Chào bạn! Mình là trợ lý tư vấn kính mắt của shop. Bạn đang cần tư vấn gì ạ? 😊",
    "Xin chào! Rất vui được gặp bạn. Bạn muốn tìm mẫu kính nào hôm nay ạ?",
    "Chào bạn nhé! Shop có thể giúp gì cho bạn về kính mắt không ạ? 🕶️",
    "Hello! Bạn cần tư vấn về kính mắt ạ? Mình luôn sẵn sàng hỗ trợ bạn!",
    "Chào mừng bạn đến với shop kính mắt! Hôm nay bạn đang tìm kiếm gì ạ?",
]

THANKS_RESPONSES = [
    "Cảm ơn bạn đã tin tưởng shop! Chúc bạn mua được mẫu kính ưng ý nhé 😊",
    "Dạ không có gì ạ! Nếu có câu hỏi gì thêm, bạn cứ hỏi shop nhé.",
    "Cảm ơn bạn! Shop luôn sẵn sàng hỗ trợ bạn bất cứ lúc nào ạ.",
    "Không có chi bạn ơi! Bạn mua kính vui vẻ nha! 🎉",
]

GOODBYE_RESPONSES = [
    "Tạm biệt bạn! Hẹn gặp lại nhé. Chúc bạn một ngày tốt lành! 👋",
    "Bạn đi nhé! Khi nào cần tư vấn kính cứ ghé shop lại nha.",
    "Tạm biệt! Nếu cần gì thêm bạn cứ nhắn shop nhé 😊",
]

FALLBACK_RESPONSES = [
    "Dạ bạn ơi, mình chưa hiểu rõ câu hỏi lắm. Bạn có thể hỏi lại cụ thể hơn không ạ? Ví dụ: 'Gợi ý kính cho mặt tròn' hoặc 'Kính dưới 300k có loại nào?'",
    "Shop chưa nắm được ý bạn hỏi ạ 😅 Bạn có thể nói rõ hơn không? Mình có thể tư vấn về: chọn kính theo khuôn mặt, giá cả, chất liệu, tính năng...",
    "Mình chưa hiểu lắm bạn ơi. Bạn đang cần tư vấn về kính mắt không? Shop sẵn sàng giúp bạn chọn kính phù hợp nhất!",
    "Xin lỗi bạn, shop không chắc bạn đang hỏi về gì ạ. Bạn muốn tìm kính theo giá, phong cách, hay khuôn mặt?",
]

PRODUCT_INTRO = [
    "Shop tìm được một số mẫu phù hợp cho bạn:",
    "Dựa theo yêu cầu của bạn, shop gợi ý những mẫu sau:",
    "Bạn có thể tham khảo những mẫu này nhé:",
    "Shop có những mẫu sau đây khá hợp với bạn:",
    "Đây là một số lựa chọn tốt cho bạn:",
]

NO_PRODUCT = [
    "Hiện shop chưa tìm thấy sản phẩm phù hợp với yêu cầu của bạn ạ. Bạn có thể mô tả rõ hơn không?",
    "Shop chưa có sản phẩm khớp với tiêu chí này. Bạn thử điều chỉnh bộ lọc xem sao?",
    "Rất tiếc, không tìm thấy sản phẩm phù hợp 😅 Bạn thử thay đổi khoảng giá hoặc phong cách nhé!",
]

URGENT_RESPONSES = [
    "Bạn cần gấp không ạ? Shop hỗ trợ ship hỏa tốc trong ngày cho các đơn nội thành! Bạn đang ở đâu để shop kiểm tra khu vực ạ?",
    "Shop hiểu bạn cần gấp! Nếu bạn ở nội thành, shop có thể ship trong 2-4 tiếng. Bạn cho shop địa chỉ để kiểm tra nhé!",
]

UPSELL_MESSAGES = [
    "\n\n💡 **Gợi ý thêm:** Bạn có muốn thêm tròng kính chống ánh sáng xanh không? Rất có lợi nếu bạn hay dùng điện thoại/máy tính, chỉ thêm khoảng 100-200k thôi ạ!",
    "\n\n✨ **Combo ưu đãi:** Mua gọng + tròng kính cùng lúc được giảm thêm 10-15% đó bạn! Tiết kiệm hơn mua riêng nhiều.",
    "\n\n🔥 **Nâng cấp tròng:** Nếu bạn cần cắt độ, shop gợi ý tròng 1.67 mỏng hơn, nhẹ hơn, đẹp hơn tròng thường, chỉ thêm 100-200k!",
]


# =============================================================
#  RESPONSE GENERATOR CLASS
# =============================================================

class ResponseGenerator:
    """Tạo câu trả lời tự nhiên cho chatbot kính mắt."""

    def generate(self, intent: str, entities: Dict,
                 knowledge_results: List[Dict],
                 db_products: List[Dict],
                 confidence: float) -> Dict:
        """
        Tạo câu trả lời cuối cùng.

        Returns:
            {
                'reply': str,
                'source': str,
                'products': list,
                'confidence': float
            }
        """
        # ─── Special intents ──────────────────────────────
        if intent == 'greeting':
            return self._build_reply(random.choice(GREETINGS), 'template', confidence=1.0)

        if intent == 'thanks':
            return self._build_reply(random.choice(THANKS_RESPONSES), 'template', confidence=1.0)

        if intent == 'goodbye':
            return self._build_reply(random.choice(GOODBYE_RESPONSES), 'template', confidence=1.0)

        if intent == 'urgent':
            reply = random.choice(URGENT_RESPONSES)
            if knowledge_results:
                best = knowledge_results[0]
                reply = best['answer'] + "\n\n" + random.choice(URGENT_RESPONSES)
            return self._build_reply(reply, 'template', confidence=0.9)

        # ─── Database + Knowledge hybrid ──────────────────
        if db_products and knowledge_results:
            return self._hybrid_response(knowledge_results, db_products, intent, entities)

        # ─── Database only ─────────────────────────────────
        if db_products:
            return self._product_response(db_products, intent, entities)

        # ─── Knowledge only ────────────────────────────────
        if knowledge_results and confidence >= 0.25:
            return self._knowledge_response(knowledge_results, intent, entities)

        # ─── Fallback ──────────────────────────────────────
        return self._fallback_response(intent, entities)

    # ─── Response builders ────────────────────────────────

    def _hybrid_response(self, knowledge: List[Dict], products: List[Dict],
                         intent: str, entities: Dict) -> Dict:
        """Kết hợp knowledge + sản phẩm"""
        best_knowledge = knowledge[0]['answer']

        # Tạo mở đầu từ knowledge
        reply = best_knowledge

        # Thêm sản phẩm
        if products:
            reply += f"\n\n{random.choice(PRODUCT_INTRO)}"

        # Thêm upsell tùy intent
        if intent in ('search_product', 'search_by_price', 'buy_intent'):
            if random.random() > 0.5:  # 50% chance
                reply += random.choice(UPSELL_MESSAGES)

        return self._build_reply(reply, 'hybrid', products=products,
                                 confidence=knowledge[0]['confidence'])

    def _product_response(self, products: List[Dict],
                          intent: str, entities: Dict) -> Dict:
        """Trả lời dựa trên sản phẩm từ database"""
        intro = random.choice(PRODUCT_INTRO)
        reply = intro

        # Context hint
        if entities.get('face_shape'):
            reply = f"Với khuôn mặt {entities['face_shape']}, " + reply.lower()
        elif entities.get('gender'):
            g = 'nam' if entities['gender'] == 'male' else 'nữ' if entities['gender'] == 'female' else 'unisex'
            reply = f"Dành cho {g}, " + reply.lower()

        # Upsell
        if len(products) > 0 and intent in ('search_product', 'search_by_price'):
            reply += random.choice(UPSELL_MESSAGES)

        return self._build_reply(reply, 'database', products=products, confidence=0.8)

    def _knowledge_response(self, results: List[Dict],
                            intent: str, entities: Dict) -> Dict:
        """Trả lời dựa trên knowledge base"""
        best = results[0]
        reply = best['answer']

        # Nếu hỏi về giá → thêm gợi ý xem sản phẩm
        if intent == 'search_by_price' and entities.get('price_value'):
            price = entities['price_value']
            if price:
                reply += f"\n\nBạn muốn xem ngay các mẫu trong tầm giá {self._format_price(price)}k không? Mình sẽ lọc cho bạn!"

        # Upsell cho một số intents
        if intent in ('ask_lens', 'ask_blue_light') and random.random() > 0.4:
            reply += "\n\n💡 **Combo gọng + tròng:** Mua cùng lúc tiết kiệm 10-15% so với mua riêng bạn nhé!"

        source = best.get('source', 'knowledge')
        return self._build_reply(reply, source, confidence=best['confidence'])

    def _fallback_response(self, intent: str, entities: Dict) -> Dict:
        """Trả lời khi không tìm được kết quả phù hợp"""
        reply = random.choice(FALLBACK_RESPONSES)

        # Thêm gợi ý cụ thể theo intent đoán được
        hints = {
            'search_product': " Bạn thử hỏi: 'Kính cho mặt tròn' hoặc 'Kính nam dưới 400k'?",
            'ask_shipping': " Bạn hỏi về ship hàng đúng không? Shop ship toàn quốc 1-3 ngày ạ!",
            'ask_warranty': " Bạn hỏi về bảo hành ạ? Shop bảo hành 6 tháng cho tất cả sản phẩm!",
            'complaint': " Bạn đang gặp vấn đề với đơn hàng ạ? Cho shop biết mã đơn để hỗ trợ ngay nha!",
        }

        if intent in hints:
            reply = hints[intent]

        return self._build_reply(reply, 'fallback', confidence=0.1)

    # ─── Format helpers ───────────────────────────────────

    @staticmethod
    def format_product(product: Dict) -> str:
        """Format thông tin sản phẩm thành text đẹp"""
        lines = []
        name = product.get('name', 'Sản phẩm')
        brand = product.get('brand', '')
        price = product.get('effective_price') or product.get('sale_price') or product.get('price', 0)
        original_price = product.get('price', 0)
        discount = product.get('discount_percent', 0)
        material = product.get('frame_material', '')
        gender = product.get('gender', '')
        stock = product.get('stock', 0)
        desc = product.get('description', '')

        # Tên + thương hiệu
        brand_str = f" ({brand})" if brand else ""
        lines.append(f"🕶️ **{name}{brand_str}**")

        # Giá
        price_str = f"{price:,.0f}₫"
        if discount and discount > 0:
            price_str += f" ~~{original_price:,.0f}₫~~ (-{discount:.0f}%)"
        lines.append(f"   💰 Giá: {price_str}")

        # Thông tin thêm
        if material:
            lines.append(f"   🔧 Chất liệu: {material}")

        gender_map = {'male': 'Nam', 'female': 'Nữ', 'unisex': 'Unisex'}
        if gender:
            lines.append(f"   👤 Dành cho: {gender_map.get(gender, gender)}")

        if desc:
            short_desc = desc[:80] + "..." if len(desc) > 80 else desc
            lines.append(f"   📝 {short_desc}")

        if stock <= 3:
            lines.append(f"   ⚠️ Chỉ còn {stock} sản phẩm!")
        elif stock > 0:
            lines.append(f"   ✅ Còn hàng")

        return "\n".join(lines)

    @staticmethod
    def _format_price(price: float) -> str:
        if price >= 1_000_000:
            return f"{price/1_000_000:.1f} triệu"
        elif price >= 1_000:
            return f"{price/1_000:.0f}k"
        return str(price)

    @staticmethod
    def _build_reply(reply: str, source: str,
                     products: List[Dict] = None,
                     confidence: float = 0.5) -> Dict:
        return {
            'reply': reply,
            'source': source,
            'products': products or [],
            'confidence': confidence
        }
