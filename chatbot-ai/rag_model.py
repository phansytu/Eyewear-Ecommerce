import json
import numpy as np
import faiss
from sentence_transformers import SentenceTransformer
import mysql.connector
from typing import List, Dict
import os

class EyewearRAG:
    def __init__(self):
        # Khởi tạo model embedding
        self.model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')
        self.dimension = 768  # Kích thước vector output của model
        self.index = None
        self.products = []
        
        # Kết nối database
        self.db_config = {
            'host': 'localhost',
            'user': 'root',
            'password': '',  # Thay bằng mật khẩu MySQL của bạn
            'database': 'eyewear_store'
        }
        
        # Load hoặc tạo FAISS index
        self.load_or_create_index()
    
    def load_products_from_db(self) -> List[Dict]:
        """Tải sản phẩm từ MySQL"""
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        
        query = """
        SELECT p.*, c.name as category_name 
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.status = 'active'
        """
        cursor.execute(query)
        products = cursor.fetchall()
        
        cursor.close()
        conn.close()
        return products
    
    def create_product_text(self, product: Dict) -> str:
        """Tạo text representation cho sản phẩm"""
        text = f"""
        Tên: {product['name']}
        Thương hiệu: {product['brand']}
        Giá: {product['sale_price'] if product['sale_price'] else product['price']} VND
        Mô tả: {product['description']}
        Chất liệu khung: {product['frame_material']}
        Loại tròng: {product['lens_type']}
        Giới tính: {product['gender']}
        """
        return text.strip()
    
    def create_embeddings(self, products: List[Dict]) -> np.ndarray:
        """Tạo embeddings cho tất cả sản phẩm"""
        texts = [self.create_product_text(p) for p in products]
        embeddings = self.model.encode(texts, show_progress_bar=True)
        return np.array(embeddings).astype('float32')
    
    def save_to_faiss(self, embeddings: np.ndarray):
        """Lưu embeddings vào FAISS"""
        self.index = faiss.IndexFlatL2(self.dimension)
        self.index.add(embeddings)
        
        # Lưu FAISS index
        if not os.path.exists('faiss_index'):
            os.makedirs('faiss_index')
        faiss.write_index(self.index, 'faiss_index/eyewear.index')
    
    def load_or_create_index(self):
        """Load FAISS index hoặc tạo mới"""
        self.products = self.load_products_from_db()
        
        if os.path.exists('faiss_index/eyewear.index'):
            # Load existing index
            self.index = faiss.read_index('faiss_index/eyewear.index')
            print(f"Loaded existing FAISS index with {self.index.ntotal} products")
        else:
            # Create new index
            embeddings = self.create_embeddings(self.products)
            self.save_to_faiss(embeddings)
            print(f"Created new FAISS index with {len(self.products)} products")
    
    def search_similar_products(self, query: str, k: int = 3) -> List[Dict]:
        """Tìm sản phẩm tương tự với câu hỏi"""
        # Tạo embedding cho câu hỏi
        query_embedding = self.model.encode([query]).astype('float32')
        
        # Tìm kiếm
        distances, indices = self.index.search(query_embedding, k)
        
        # Lấy sản phẩm tương ứng
        similar_products = []
        for idx in indices[0]:
            if idx < len(self.products):
                similar_products.append(self.products[idx])
        
        return similar_products
    
    def generate_response(self, user_query: str, products: List[Dict]) -> str:
        """Tạo câu trả lời tự nhiên từ context"""
        if not products:
            return "Xin lỗi, tôi không tìm thấy sản phẩm phù hợp với yêu cầu của bạn. Bạn có thể thử hỏi khác được không ạ?"
        
        # Prompt template
        prompt = f"""Bạn là nhân viên tư vấn bán kính thời trang chuyên nghiệp, thân thiện. Hãy trả lời câu hỏi sau dựa trên thông tin sản phẩm có sẵn.

Câu hỏi của khách hàng: "{user_query}"

Danh sách sản phẩm phù hợp:
"""
        
        for i, p in enumerate(products, 1):
            price = p['sale_price'] if p['sale_price'] else p['price']
            price_str = f"{price:,.0f} VND"
            
            prompt += f"""
{i}. {p['name']} - {p['brand']}
   - Giá: {price_str}
   - Mô tả: {p['description'][:150]}
   - Chất liệu: {p['frame_material']}
   - Đánh giá: {p['average_rating']}/5 ({p['total_reviews']} đánh giá)
   - Tình trạng: {p['stock']} sản phẩm có sẵn
"""
        
        prompt += """
Hãy trả lời một cách tự nhiên, thân thiện, tư vấn cho khách hàng về những sản phẩm này. Gợi ý sản phẩm phù hợp nhất nếu có thể. Giữ câu trả lời ngắn gọn, dễ hiểu, khoảng 3-5 câu.
"""
        
        # Vì không có LLM, sử dụng template response
        # Trong thực tế, có thể gọi OpenAI hoặc local LLM
        return self.create_template_response(user_query, products)
    
    def create_template_response(self, user_query: str, products: List[Dict]) -> str:
        """Tạo response template (tạm thời - có thể thay bằng LLM sau)"""
        if "giá" in user_query.lower() or "bao nhiêu" in user_query.lower():
            response = f"Dạ, theo yêu cầu của anh/chị về giá, em gợi ý:\n"
            for p in products[:2]:
                price = p['sale_price'] if p['sale_price'] else p['price']
                response += f"• {p['name']} giá {price:,.0f} VND\n"
            response += "Anh/chị muốn xem chi tiết sản phẩm nào không ạ?"
            return response
        
        elif "kính mát" in user_query.lower() or "kính râm" in user_query.lower():
            response = f"Dạ, em có vài mẫu kính mát đẹp gợi ý cho anh/chị nè:\n"
            for p in products:
                response += f"• {p['name']} - {p['brand']}\n"
            response += "Các mẫu này đều có khả năng chống UV và thiết kế thời trang. Anh/chị thích mẫu nào để em tư vấn thêm ạ?"
            return response
        
        else:
            response = f"Dạ cảm ơn anh/chị đã quan tâm!\n"
            best = products[0]
            response += f"Em thấy {best['name']} của {best['brand']} rất phù hợp với nhu cầu của anh/chị.\n"
            response += f"Sản phẩm có giá {best['sale_price'] if best['sale_price'] else best['price']:,.0f} VND, đang có sẵn tại cửa hàng.\n"
            response += "Anh/chị có muốn em tư vấn thêm thông tin gì về sản phẩm này không ạ?"
            return response

# Khởi tạo global instance
rag = EyewearRAG()