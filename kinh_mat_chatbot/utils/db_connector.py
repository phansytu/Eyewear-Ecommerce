"""
=============================================================
DATABASE CONNECTOR - Kết nối MySQL Workbench
=============================================================
"""

import mysql.connector
from mysql.connector import pooling, Error
import logging
from typing import List, Dict, Optional, Any
from config import Config

logger = logging.getLogger(__name__)


class DatabaseConnector:
    """
    Quản lý kết nối và truy vấn MySQL.
    Sử dụng connection pool để tối ưu hiệu suất.
    """

    def __init__(self):
        self._pool = None
        self._init_pool()

    # ─── Khởi tạo ─────────────────────────────────────────

    def _init_pool(self):
        """Khởi tạo connection pool"""
        try:
            self._pool = pooling.MySQLConnectionPool(
                pool_name="kinh_mat_pool",
                pool_size=Config.DB_POOL_SIZE,
                host=Config.DB_HOST,
                port=Config.DB_PORT,
                user=Config.DB_USER,
                password=Config.DB_PASSWORD,
                database=Config.DB_NAME,
                charset=Config.DB_CHARSET,
                use_unicode=True,
                connect_timeout=Config.DB_CONNECT_TIMEOUT,
                # Tự động reconnect
                autocommit=True
            )
            logger.info(f"✅ MySQL pool initialized: {Config.DB_HOST}:{Config.DB_PORT}/{Config.DB_NAME}")
        except Error as e:
            logger.error(f"❌ MySQL connection failed: {e}")
            logger.warning("⚠️  Chatbot sẽ chạy ở chế độ Knowledge-only (không có database)")
            self._pool = None

    def test_connection(self) -> bool:
        """Kiểm tra kết nối database"""
        try:
            conn = self._get_connection()
            if conn:
                conn.close()
                return True
        except Exception:
            pass
        return False

    def _get_connection(self):
        """Lấy connection từ pool"""
        if self._pool is None:
            return None
        try:
            return self._pool.get_connection()
        except Error as e:
            logger.error(f"Get connection error: {e}")
            return None

    # ─── Tìm kiếm sản phẩm ───────────────────────────────

    def search_products(self, filters: Dict) -> List[Dict]:
        """
        Tìm kiếm sản phẩm theo nhiều điều kiện.
        
        Args:
            filters: dict chứa các điều kiện lọc:
                - keyword: từ khóa tìm trong name, brand, description
                - brand: tên thương hiệu
                - gender: male | female | unisex
                - material: chất liệu gọng
                - min_price, max_price: khoảng giá (theo sale_price)
                - limit: số kết quả tối đa
        
        Returns:
            List[Dict] danh sách sản phẩm
        """
        conn = self._get_connection()
        if not conn:
            return []

        try:
            cursor = conn.cursor(dictionary=True)

            conditions = ["p.status = 'active'"]
            params = []

            # Từ khóa tìm kiếm
            keyword = (filters.get('keyword') or '').strip()
            if keyword:
                conditions.append("""
                    (p.name LIKE %s 
                     OR p.brand LIKE %s 
                     OR p.description LIKE %s
                     OR p.frame_material LIKE %s)
                """)
                like_kw = f'%{keyword}%'
                params.extend([like_kw, like_kw, like_kw, like_kw])

            # Thương hiệu
            brand = (filters.get('brand') or '').strip()
            if brand:
                conditions.append("p.brand LIKE %s")
                params.append(f'%{brand}%')

            # Giới tính
            gender = (filters.get('gender') or '').strip().lower()
            if gender in ('male', 'female', 'unisex'):
                conditions.append("(p.gender = %s OR p.gender = 'unisex')")
                params.append(gender)

            # Chất liệu
            material = (filters.get('material') or '').strip()
            if material:
                conditions.append("p.frame_material LIKE %s")
                params.append(f'%{material}%')

            # Khoảng giá
            min_price = filters.get('min_price')
            if min_price is not None:
                conditions.append("COALESCE(p.sale_price, p.price) >= %s")
                params.append(float(min_price))

            max_price = filters.get('max_price')
            if max_price is not None:
                conditions.append("COALESCE(p.sale_price, p.price) <= %s")
                params.append(float(max_price))

            # Stock > 0
            conditions.append("p.stock > 0")

            where_clause = " AND ".join(conditions)
            limit = min(int(filters.get('limit', 10)), 20)

            sql = f"""
                SELECT 
                    p.id,
                    p.name,
                    p.brand,
                    p.price,
                    p.sale_price,
                    p.description,
                    p.gender,
                    p.frame_material,
                    p.stock,
                    p.image,
                    COALESCE(p.sale_price, p.price) AS effective_price,
                    CASE 
                        WHEN p.sale_price IS NOT NULL AND p.sale_price < p.price 
                        THEN ROUND((1 - p.sale_price/p.price)*100)
                        ELSE 0 
                    END AS discount_percent
                FROM products p
                WHERE {where_clause}
                ORDER BY 
                    CASE WHEN p.stock > 5 THEN 0 ELSE 1 END,
                    effective_price ASC
                LIMIT {limit}
            """

            cursor.execute(sql, params)
            results = cursor.fetchall()

            # Chuyển Decimal sang float để JSON serialize
            return [self._serialize_product(row) for row in results]

        except Error as e:
            logger.error(f"Search products error: {e}")
            return []
        finally:
            cursor.close()
            conn.close()

    def get_product_by_id(self, product_id: int) -> Optional[Dict]:
        """Lấy thông tin chi tiết một sản phẩm theo ID"""
        conn = self._get_connection()
        if not conn:
            return None
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("""
                SELECT id, name, brand, price, sale_price, description,
                       gender, frame_material, stock, image, status
                FROM products 
                WHERE id = %s AND status = 'active'
            """, (product_id,))
            row = cursor.fetchone()
            return self._serialize_product(row) if row else None
        except Error as e:
            logger.error(f"Get product error: {e}")
            return None
        finally:
            cursor.close()
            conn.close()

    def search_by_price_range(self, max_price: float, min_price: float = 0,
                               limit: int = 5) -> List[Dict]:
        """Tìm sản phẩm theo khoảng giá"""
        return self.search_products({
            'min_price': min_price,
            'max_price': max_price,
            'limit': limit
        })

    def search_by_gender(self, gender: str, limit: int = 5) -> List[Dict]:
        """Tìm sản phẩm theo giới tính"""
        return self.search_products({'gender': gender, 'limit': limit})

    def search_by_material(self, material: str, limit: int = 5) -> List[Dict]:
        """Tìm sản phẩm theo chất liệu"""
        return self.search_products({'material': material, 'limit': limit})

    def get_all_brands(self) -> List[str]:
        """Lấy danh sách tất cả thương hiệu"""
        conn = self._get_connection()
        if not conn:
            return []
        try:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT DISTINCT brand FROM products 
                WHERE status = 'active' 
                ORDER BY brand
            """)
            return [row[0] for row in cursor.fetchall()]
        except Error:
            return []
        finally:
            cursor.close()
            conn.close()

    def get_featured_products(self, limit: int = 5) -> List[Dict]:
        """Lấy sản phẩm nổi bật (có giảm giá, còn hàng)"""
        conn = self._get_connection()
        if not conn:
            return []
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("""
                SELECT id, name, brand, price, sale_price, description,
                       gender, frame_material, stock, image
                FROM products
                WHERE status = 'active' 
                  AND stock > 0
                  AND sale_price IS NOT NULL 
                  AND sale_price < price
                ORDER BY (1 - sale_price/price) DESC
                LIMIT %s
            """, (limit,))
            return [self._serialize_product(r) for r in cursor.fetchall()]
        except Error as e:
            logger.error(f"Get featured products error: {e}")
            return []
        finally:
            cursor.close()
            conn.close()

    # ─── Helpers ──────────────────────────────────────────

    @staticmethod
    def _serialize_product(row: Dict) -> Dict:
        """Chuyển đổi kiểu dữ liệu MySQL → JSON-serializable"""
        if not row:
            return {}
        result = {}
        for key, value in row.items():
            if hasattr(value, '__float__'):  # Decimal
                result[key] = float(value)
            elif hasattr(value, 'isoformat'):  # datetime
                result[key] = value.isoformat()
            else:
                result[key] = value
        return result
