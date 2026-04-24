package DAO;

import model.Product;
import model.ProductImage;
import model.ProductVariant;
import util.DBConnect;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    // ========================================
    // 1. LẤY TẤT CẢ SẢN PHẨM (Admin & Public)
    // ========================================
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.status != 'deleted'
            ORDER BY p.id DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                products.add(product);
            }
            System.out.println("✅ Loaded " + products.size() + " products");
        } catch (SQLException e) {
            System.err.println("❌ getAllProducts: " + e.getMessage());
        }
        return products;
    }
    
    // Lấy sản phẩm active (cho public)
    public List<Product> getActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.status = 'active' 
            ORDER BY p.is_featured DESC, p.created_at DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("❌ getActiveProducts: " + e.getMessage());
        }
        return products;
    }
    
    // ========================================
    // 2. LẤY SẢN PHẨM THEO ID (Kèm rating)
    // ========================================
    public Product getProductById(int id) {
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.id = ?
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = extractProductFull(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                
                // Load images & variants
                product.setImages(getProductImages(id));
                product.setVariants(getProductVariants(id));
                
                return product;
            }
        } catch (SQLException e) {
            System.err.println("❌ getProductById: " + e.getMessage());
        }
        return null;
    }
    
    // ========================================
    // 3. LỌC THEO DANH MỤC
    // ========================================
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.category_id = ? AND p.status = 'active' 
            ORDER BY p.created_at DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("❌ getProductsByCategory: " + e.getMessage());
        }
        return products;
    }
    
    // Lấy sản phẩm theo danh mục cha (bao gồm cả con)
    public List<Product> getProductsByParentCategory(int parentCategoryId) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE (p.category_id = ? OR p.category_id IN (SELECT id FROM categories WHERE parent_id = ?)) 
            AND p.status = 'active' 
            ORDER BY p.created_at DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentCategoryId);
            ps.setInt(2, parentCategoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("❌ getProductsByParentCategory: " + e.getMessage());
        }
        return products;
    }
    
    // ========================================
    // 4. SẢN PHẨM NỔI BẬT
    // ========================================
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> featured = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.is_featured = TRUE AND p.status = 'active' 
            ORDER BY p.created_at DESC LIMIT ?
            """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                featured.add(product);
            }
        } catch (SQLException e) {
            System.err.println("❌ getFeaturedProducts: " + e.getMessage());
        }
        return featured;
    }
    
    // ========================================
    // 5. TÌM KIẾM SẢN PHẨM
    // ========================================
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE (p.name LIKE ? OR p.brand LIKE ?) AND p.status != 'deleted'
            ORDER BY p.id DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("❌ searchProducts: " + e.getMessage());
        }
        return products;
    }
    
    /**
     * Tìm kiếm sản phẩm nâng cao với nhiều bộ lọc
     */
    public List<Product> searchProductsAdvanced(String keyword, String categoryId, String minPrice, 
                                                 String maxPrice, String gender, String frameMaterial, String sort) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.status = 'active'
            """);
        
        List<Object> params = new ArrayList<>();
        
        // Tìm kiếm theo từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.brand LIKE ? OR p.description LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Lọc theo danh mục
        if (categoryId != null && !categoryId.isEmpty() && !categoryId.equals("0")) {
            sql.append(" AND p.category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }
        
        // Lọc theo giá
        if (minPrice != null && !minPrice.isEmpty()) {
            sql.append(" AND p.sale_price >= ?");
            params.add(new BigDecimal(minPrice));
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql.append(" AND p.sale_price <= ?");
            params.add(new BigDecimal(maxPrice));
        }
        
        // Lọc theo giới tính
        if (gender != null && !gender.isEmpty() && !gender.equals("all")) {
            sql.append(" AND p.gender = ?");
            params.add(gender);
        }
        
        // Lọc theo chất liệu gọng
        if (frameMaterial != null && !frameMaterial.isEmpty() && !frameMaterial.equals("all")) {
            sql.append(" AND p.frame_material = ?");
            params.add(frameMaterial);
        }
        
        // Sắp xếp
        switch (sort) {
            case "price_asc":
                sql.append(" ORDER BY p.sale_price ASC");
                break;
            case "price_desc":
                sql.append(" ORDER BY p.sale_price DESC");
                break;
            case "name_asc":
                sql.append(" ORDER BY p.name ASC");
                break;
            case "best_seller":
                sql.append(" ORDER BY p.sold_quantity DESC");
                break;
            default: // newest
                sql.append(" ORDER BY p.created_at DESC");
                break;
        }
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("❌ searchProductsAdvanced: " + e.getMessage());
        }
        return products;
    }
    
    // ========================================
    // 6. LỌC THEO TRẠNG THÁI (Admin)
    // ========================================
    public List<Product> getProductsByStatus(String status) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name,
                   COALESCE(p.average_rating, 0) as average_rating,
                   COALESCE(p.total_reviews, 0) as total_reviews
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.status = ? 
            ORDER BY p.id DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = extractProductBasic(rs);
                product.setAverageRating(rs.getDouble("average_rating"));
                product.setTotalReviews(rs.getInt("total_reviews"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.err.println("❌ getProductsByStatus: " + e.getMessage());
        }
        return products;
    }
    
    // ========================================
    // 7. ADMIN - CRUD
    // ========================================
    
//    public boolean addProduct(Product p) {
//        String sql = """
//            INSERT INTO products (name, brand, category_id, stock, price, sale_price, description, 
//            image, is_featured, uv_protection, status, gender, frame_material, lens_type) 
//            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
//            """;
//        
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            
//            ps.setString(1, p.getName());
//            ps.setString(2, p.getBrand());
//            ps.setInt(3, p.getCategoryId());
//            ps.setInt(4, p.getStock());
//            ps.setBigDecimal(5, p.getPrice());
//            ps.setBigDecimal(6, p.getSalePrice());
//            ps.setString(7, p.getDescription());
//            ps.setString(8, p.getImage());
//            ps.setBoolean(9, p.isFeatured());
//            ps.setBoolean(10, p.isUvProtection());
//            ps.setString(11, p.getStatus() != null ? p.getStatus() : "active");
//            ps.setString(12, p.getGender());
//            ps.setString(13, p.getFrameMaterial());
//            ps.setString(14, p.getLensType());
//            
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                ResultSet rs = ps.getGeneratedKeys();
//                if (rs.next()) {
//                    p.setId(rs.getInt(1));
//                }
//                System.out.println("✅ Added product: " + p.getName());
//                return true;
//            }
//        } catch (SQLException e) {
//            System.err.println("❌ addProduct: " + e.getMessage());
//            e.printStackTrace();
//        }
//        return false;
//    }
//    
//    public boolean updateProduct(Product product) {
//        String sql = """
//            UPDATE products SET name=?, description=?, price=?, sale_price=?, stock=?, 
//            category_id=?, brand=?, gender=?, frame_material=?, lens_type=?, 
//            uv_protection=?, is_featured=?, image=? WHERE id=?
//            """;
//        
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setString(1, product.getName());
//            ps.setString(2, product.getDescription());
//            ps.setBigDecimal(3, product.getPrice());
//            ps.setBigDecimal(4, product.getSalePrice());
//            ps.setInt(5, product.getStock());
//            ps.setInt(6, product.getCategoryId());
//            ps.setString(7, product.getBrand());
//            ps.setString(8, product.getGender());
//            ps.setString(9, product.getFrameMaterial());
//            ps.setString(10, product.getLensType());
//            ps.setBoolean(11, product.isUvProtection());
//            ps.setBoolean(12, product.isFeatured());
//            ps.setString(13, product.getImage());
//            ps.setInt(14, product.getId());
//            
//            int rows = ps.executeUpdate();
//            System.out.println("✅ Updated " + rows + " product(s)");
//            return rows > 0;
//        } catch (SQLException e) {
//            System.err.println("❌ updateProduct: " + e.getMessage());
//            e.printStackTrace();
//        }
//        return false;
//    }
    
//    public boolean updateProductStatus(int productId, String status) {
//        String sql = "UPDATE products SET status = ? WHERE id = ?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, status);
//            ps.setInt(2, productId);
//            int rows = ps.executeUpdate();
//            System.out.println("✅ Updated status to " + status + " for product " + productId);
//            return rows > 0;
//        } catch (SQLException e) {
//            System.err.println("❌ updateProductStatus: " + e.getMessage());
//        }
//        return false;
//    }
    public boolean addProduct(Product p) {
    String sql = """
        INSERT INTO products (name, brand, category_id, stock, price, sale_price, description, 
        image, is_featured, uv_protection, status, gender, frame_material, lens_type) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
    
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        ps.setString(1, p.getName());
        ps.setString(2, p.getBrand());
        ps.setInt(3, p.getCategoryId());
        ps.setInt(4, p.getStock());
        ps.setBigDecimal(5, p.getPrice());
        
        // Xử lý sale_price: nếu null thì set price
        BigDecimal salePrice = p.getSalePrice();
        if (salePrice == null || salePrice.compareTo(BigDecimal.ZERO) == 0) {
            salePrice = p.getPrice();
        }
        ps.setBigDecimal(6, salePrice);
        
        ps.setString(7, p.getDescription());
        ps.setString(8, p.getImage());
        ps.setBoolean(9, p.isFeatured());
        ps.setBoolean(10, p.isUvProtection());
        ps.setString(11, p.getStatus() != null ? p.getStatus() : "active");
        
        // SỬA: Chuyển đổi gender từ "Nam/Nữ/Unisex" sang "male/female/unisex"
        String genderValue = convertGender(p.getGender());
        ps.setString(12, genderValue);
        
        ps.setString(13, p.getFrameMaterial());
        ps.setString(14, p.getLensType());
        
        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                p.setId(rs.getInt(1));
            }
            System.out.println("✅ Added product: " + p.getName());
            return true;
        }
    } catch (SQLException e) {
        System.err.println("❌ addProduct: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}

public boolean updateProduct(Product product) {
    String sql = """
        UPDATE products SET name=?, description=?, price=?, sale_price=?, stock=?, 
        category_id=?, brand=?, gender=?, frame_material=?, lens_type=?, 
        uv_protection=?, is_featured=?, image=? WHERE id=?
        """;
    
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, product.getName());
        ps.setString(2, product.getDescription());
        ps.setBigDecimal(3, product.getPrice());
        
        // Xử lý sale_price
        BigDecimal salePrice = product.getSalePrice();
        if (salePrice == null || salePrice.compareTo(BigDecimal.ZERO) == 0) {
            salePrice = product.getPrice();
        }
        ps.setBigDecimal(4, salePrice);
        
        ps.setInt(5, product.getStock());
        ps.setInt(6, product.getCategoryId());
        ps.setString(7, product.getBrand());
        
        // SỬA: Chuyển đổi gender
        String genderValue = convertGender(product.getGender());
        ps.setString(8, genderValue);
        
        ps.setString(9, product.getFrameMaterial());
        ps.setString(10, product.getLensType());
        ps.setBoolean(11, product.isUvProtection());
        ps.setBoolean(12, product.isFeatured());
        ps.setString(13, product.getImage());
        ps.setInt(14, product.getId());
        
        int rows = ps.executeUpdate();
        System.out.println("✅ Updated " + rows + " product(s)");
        return rows > 0;
    } catch (SQLException e) {
        System.err.println("❌ updateProduct: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}

/**
 * Chuyển đổi gender từ dạng hiển thị sang dạng lưu trong database
 * @param displayGender "Nam", "Nữ", "Unisex"
 * @return "male", "female", "unisex"
 */
private String convertGender(String displayGender) {
    if (displayGender == null || displayGender.isEmpty()) {
        return "unisex";
    }
    switch (displayGender) {
        case "Nam":
            return "male";
        case "Nữ":
            return "female";
        case "Unisex":
            return "unisex";
        default:
            return "unisex";
    }
}
 public boolean updateProductStatus(int productId, String status) {
        String sql = "UPDATE products SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, productId);
            int rows = ps.executeUpdate();
            System.out.println("✅ Updated status to " + status + " for product " + productId);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ updateProductStatus: " + e.getMessage());
        }
        return false;
    }
    public boolean deleteProduct(int id) {
        String sql = "UPDATE products SET status = 'deleted' WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            System.out.println("✅ Soft deleted product: " + id);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ deleteProduct: " + e.getMessage());
        }
        return false;
    }
    
    public boolean hardDeleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            System.out.println("✅ Hard deleted product: " + id);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ hardDeleteProduct: " + e.getMessage());
        }
        return false;
    }
    
    // ========================================
    // 8. THỐNG KÊ (Admin Dashboard)
    // ========================================
    
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) as total FROM products WHERE status != 'deleted'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("❌ getTotalProducts: " + e.getMessage());
        }
        return 0;
    }
    
    public int getActiveProductsCount() {
        String sql = "SELECT COUNT(*) as total FROM products WHERE status = 'active'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("❌ getActiveProductsCount: " + e.getMessage());
        }
        return 0;
    }
    
    public int getLowStockProductsCount() {
        String sql = "SELECT COUNT(*) as total FROM products WHERE stock > 0 AND stock < 10 AND status = 'active'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("❌ getLowStockProductsCount: " + e.getMessage());
        }
        return 0;
    }
    
    public int getOutOfStockProductsCount() {
        String sql = "SELECT COUNT(*) as total FROM products WHERE stock = 0 AND status = 'active'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("❌ getOutOfStockProductsCount: " + e.getMessage());
        }
        return 0;
    }
    
    // ========================================
    // 9. PRODUCT IMAGES & VARIANTS
    // ========================================
    
    public List<ProductImage> getProductImages(int productId) {
        List<ProductImage> images = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY is_main DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImage img = new ProductImage();
                img.setId(rs.getInt("id"));
                img.setId(rs.getInt("product_id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setIsMain(rs.getBoolean("is_main"));
                images.add(img);
            }
        } catch (SQLException e) {
            System.err.println("❌ getProductImages: " + e.getMessage());
        }
        return images;
    }
    
    public boolean addProductImage(int productId, String imageUrl, boolean isMain) {
        String sql = "INSERT INTO product_images (product_id, image_url, is_main) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, imageUrl);
            ps.setBoolean(3, isMain);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ addProductImage: " + e.getMessage());
        }
        return false;
    }
    
    public List<ProductVariant> getProductVariants(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariant v = new ProductVariant();
                v.setId(rs.getInt("id"));
                v.setId(rs.getInt("product_id"));
                v.setColor(rs.getString("color"));
                v.setSize(rs.getString("size"));
                v.setPrice(rs.getBigDecimal("price"));
                v.setStock(rs.getInt("stock"));
                v.setSku(rs.getString("sku"));
                variants.add(v);
            }
        } catch (SQLException e) {
            System.err.println("❌ getProductVariants: " + e.getMessage());
        }
        return variants;
    }
    
    // ========================================
    // 10. HELPER METHODS (Extract)
    // ========================================
    
    private Product extractProductBasic(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setSalePrice(rs.getBigDecimal("sale_price"));
        p.setStock(rs.getInt("stock"));
        p.setBrand(rs.getString("brand"));
        p.setImage(rs.getString("image"));
        p.setFeatured(rs.getBoolean("is_featured"));
        p.setUvProtection(rs.getBoolean("uv_protection"));
        p.setGender(rs.getString("gender"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setStatus(rs.getString("status"));
        p.setCategoryName(rs.getString("category_name"));
        return p;
    }
    
    private Product extractProductFull(ResultSet rs) throws SQLException {
        Product p = extractProductBasic(rs);
        p.setFrameMaterial(rs.getString("frame_material"));
        p.setLensType(rs.getString("lens_type"));
        return p;
    }
}