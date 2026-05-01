import mysql.connector
from db_config import db_config
import re

class ProductData:
    def __init__(self):
        self.conn = db_config.get_connection()
    
    def get_all_products_info(self):
        """Lấy tất cả thông tin sản phẩm để training"""
        if not self.conn:
            return []
        
        cursor = self.conn.cursor(dictionary=True)
        query = """
            SELECT id, name, brand, price, sale_price, gender, 
                   frame_material, lens_type, uv_protection, 
                   stock, description, average_rating
            FROM products 
            WHERE status = 'active'
        """
        cursor.execute(query)
        products = cursor.fetchall()
        cursor.close()
        return products
    
    def search_products_by_keyword(self, keyword):
        """Tìm kiếm sản phẩm theo từ khóa"""
        if not self.conn:
            return []
        
        cursor = self.conn.cursor(dictionary=True)
        query = """
            SELECT id, name, brand, price, sale_price, gender, 
                   frame_material, stock, average_rating
            FROM products 
            WHERE status = 'active' 
            AND (name LIKE %s OR brand LIKE %s OR description LIKE %s)
            LIMIT 10
        """
        search_term = f"%{keyword}%"
        cursor.execute(query, (search_term, search_term, search_term))
        products = cursor.fetchall()
        cursor.close()
        return products
    
    def get_products_by_price_range(self, min_price, max_price):
        """Lọc sản phẩm theo giá"""
        if not self.conn:
            return []
        
        cursor = self.conn.cursor(dictionary=True)
        query = """
            SELECT id, name, brand, sale_price, gender, frame_material
            FROM products 
            WHERE status = 'active' 
            AND sale_price BETWEEN %s AND %s
            ORDER BY sale_price ASC
            LIMIT 10
        """
        cursor.execute(query, (min_price, max_price))
        products = cursor.fetchall()
        cursor.close()
        return products
    
    def get_products_by_gender(self, gender):
        """Lọc sản phẩm theo giới tính"""
        gender_map = {'nam': 'male', 'nữ': 'female', 'unisex': 'unisex'}
        db_gender = gender_map.get(gender.lower(), gender)
        
        if not self.conn:
            return []
        
        cursor = self.conn.cursor(dictionary=True)
        query = """
            SELECT id, name, brand, sale_price, frame_material
            FROM products 
            WHERE status = 'active' AND gender = %s
            LIMIT 10
        """
        cursor.execute(query, (db_gender,))
        products = cursor.fetchall()
        cursor.close()
        return products
    
    def get_products_by_material(self, material):
        """Lọc sản phẩm theo chất liệu"""
        if not self.conn:
            return []
        
        cursor = self.conn.cursor(dictionary=True)
        query = """
            SELECT id, name, brand, sale_price, gender
            FROM products 
            WHERE status = 'active' AND frame_material = %s
            LIMIT 10
        """
        cursor.execute(query, (material,))
        products = cursor.fetchall()
        cursor.close()
        return products
    
    def get_top_selling_products(self, limit=5):
        """Lấy sản phẩm bán chạy"""
        if not self.conn:
            return []
        
        cursor = self.conn.cursor(dictionary=True)
        query = """
            SELECT id, name, brand, sale_price, sold_quantity
            FROM products 
            WHERE status = 'active' 
            ORDER BY sold_quantity DESC 
            LIMIT %s
        """
        cursor.execute(query, (limit,))
        products = cursor.fetchall()
        cursor.close()
        return products
    
    def get_product_detail(self, product_id):
        """Lấy chi tiết sản phẩm theo ID"""
        if not self.conn:
            return None
        
        cursor = self.conn.cursor(dictionary=True)
        query = "SELECT * FROM products WHERE id = %s AND status = 'active'"
        cursor.execute(query, (product_id,))
        product = cursor.fetchone()
        cursor.close()
        return product
    
    def close(self):
        if self.conn:
            self.conn.close()