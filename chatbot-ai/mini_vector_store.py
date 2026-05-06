import mysql.connector
import numpy as np
import os
from config import DB_CONFIG

# Vô hiệu hóa ONNX
os.environ["DISABLE_ONNX_PRECOMPILED"] = "1"
os.environ["HF_HUB_DISABLE_ONNX_DOWNLOADS"] = "1"
os.environ["TRANSFORMERS_OFFLINE"] = "0"  # Cho phép tải online

class MiniVectorStore:
    def __init__(self):
        self.model = None
        self.tokenizer = None
        self.products_cache = []
        # Thử tải model, nếu không được thì bỏ qua
        self._init_model_transformers()
    
    def _init_model_transformers(self):
        """Khởi tạo model - nếu lỗi thì bỏ qua"""
        try:
            from transformers import AutoTokenizer, AutoModel
            import torch
            
            model_name = 'paraphrase-multilingual-MiniLM-L12-v2'
            
            print("🔄 Downloading model (first time may take a few minutes)...")
            self.tokenizer = AutoTokenizer.from_pretrained(model_name)
            self.model = AutoModel.from_pretrained(model_name)
            self.model.eval()
            
            print("✅ Model loaded successfully!")
            return True
        except Exception as e:
            print(f"⚠️ Model not loaded (chatbot will use keyword search only): {e}")
            self.model = None
            self.tokenizer = None
            return False
    
    def _get_embedding(self, text):
        """Tạo embedding - chỉ dùng nếu có model"""
        if self.model is None or self.tokenizer is None:
            return None
        
        try:
            import torch
            inputs = self.tokenizer(text, return_tensors="pt", truncation=True, max_length=128)
            with torch.no_grad():
                outputs = self.model(**inputs)
            embedding = outputs.last_hidden_state.mean(dim=1).numpy()
            return embedding[0]
        except:
            return None
    
    def get_products_from_db(self, limit=100):
        """Lấy sản phẩm từ database"""
        try:
            conn = mysql.connector.connect(**DB_CONFIG)
            cursor = conn.cursor(dictionary=True)
            
            query = """
                SELECT id, name, brand, description, sale_price, price, 
                       gender, frame_material, stock, average_rating
                FROM products 
                WHERE status = 'active'
                ORDER BY sold_quantity DESC
                LIMIT %s
            """
            cursor.execute(query, (limit,))
            products = cursor.fetchall()
            cursor.close()
            conn.close()
            print(f"✅ Loaded {len(products)} products from database")
            return products
        except Exception as e:
            print(f"Database error: {e}")
            return []
    
    def simple_text(self, product):
        """Tạo text đơn giản"""
        text = f"{product['name']} {product['brand']}"
        if product.get('frame_material'):
            text += f" {product['frame_material']}"
        if product.get('gender'):
            text += f" {product['gender']}"
        return text.lower()
    
    def simple_hash_search(self, query, products):
        """Tìm kiếm đơn giản bằng từ khóa (không cần model)"""
        stop_words = {'tìm', 'kiếm', 'cho', 'tôi', 'hãy', 'sản', 'phẩm', 
                      'kính', 'mắt', 'của', 'với', 'giá', 'bao', 'nhiêu',
                      'muốn', 'xem', 'có', 'không', 'là', 'một', 'những'}
        query_words = set(query.lower().split()) - stop_words
        
        if not query_words:
            return []
        
        scored_products = []
        for p in products:
            product_text = self.simple_text(p)
            product_words = set(product_text.split())
            intersection = query_words.intersection(product_words)
            if intersection:
                score = len(intersection) / max(len(query_words), 1)
                scored_products.append((score, p))
        
        scored_products.sort(key=lambda x: x[0], reverse=True)
        return [p for score, p in scored_products[:5]]
    
    def search(self, query, top_k=5):
        """Tìm kiếm sản phẩm"""
        if not self.products_cache:
            self.products_cache = self.get_products_from_db(limit=50)
        
        if not self.products_cache:
            return self._format_results([])
        
        # Dùng keyword search (luôn hoạt động)
        results = self.simple_hash_search(query, self.products_cache)
        if results:
            return self._format_results(results)
        
        return self._format_results(self.products_cache[:5])
    
    def _format_results(self, products):
        """Format kết quả"""
        if not products:
            return {'ids': [[]], 'metadatas': [[]], 'documents': [[]]}
        
        return {
            'ids': [[str(p['id']) for p in products]],
            'metadatas': [[{
                'id': p['id'],
                'name': p['name'],
                'brand': p['brand'],
                'price': float(p['sale_price'] or p['price'] or 0)
            } for p in products]],
            'documents': [[self.simple_text(p) for p in products]]
        }
    
    def get_product_detail(self, product_id):
        """Lấy chi tiết 1 sản phẩm"""
        try:
            conn = mysql.connector.connect(**DB_CONFIG)
            cursor = conn.cursor(dictionary=True)
            
            query = """
                SELECT id, name, brand, description, price, sale_price, stock,
                       gender, frame_material, lens_type, uv_protection,
                       average_rating, image
                FROM products 
                WHERE id = %s AND status = 'active'
            """
            cursor.execute(query, (product_id,))
            product = cursor.fetchone()
            cursor.close()
            conn.close()
            return product
        except Exception as e:
            print(f"Error getting product: {e}")
            return None
    
    def build_index(self):
        """Xây dựng index"""
        print("🔄 Loading products from database...")   
        self.products_cache = self.get_products_from_db(limit=50)
        print(f"✅ Ready with {len(self.products_cache)} products")