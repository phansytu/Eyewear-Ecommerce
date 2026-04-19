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
    // 1. LẤY TẤT CẢ SẢN PHẨM (Public)
    // ========================================
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name 
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.status = 'active' 
            ORDER BY p.is_featured DESC, p.created_at DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                products.add(extractProductBasic(rs));
            }
            System.out.println("✅ Loaded " + products.size() + " active products");
        } catch (SQLException e) {
            System.err.println("❌ getAllProducts: " + e.getMessage());
        }
        return products;
    }
    
    // ========================================
    // 2. CHI TIẾT SẢN PHẨM (Product Detail)
    // ========================================
    public Product getProductById(int id) {
        String sql = """
            SELECT p.*, c.name as category_name 
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.id = ? AND p.status = 'active'
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = extractProductFull(rs);
                
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
    // 3. TÌM KIẾM SẢN PHẨM
    // ========================================
    public List<Product> searchProducts(String keyword, String category, String minPrice, String maxPrice, String gender) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT p.*, c.name as category_name 
            FROM products p LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.status = 'active'
            """);
        
        List<String> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.brand LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (category != null && !category.equals("0")) {
            sql.append(" AND p.category_id = ?");
            params.add(category);
        }
        if (minPrice != null && !minPrice.isEmpty()) {
            sql.append(" AND p.sale_price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql.append(" AND p.sale_price <= ?");
            params.add(maxPrice);
        }
        if (gender != null && !gender.equals("all")) {
            sql.append(" AND p.gender = ?");
            params.add(gender);
        }
        
        sql.append(" ORDER BY p.is_featured DESC, p.created_at DESC LIMIT 20");
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(extractProductBasic(rs));
            }
        } catch (SQLException e) {
            System.err.println("❌ searchProducts: " + e.getMessage());
        }
        return products;
    }

    // ========================================
    // 4. LỌC THEO DANH MỤC (Cha & Con)
    // ========================================

    // Lấy sản phẩm theo Danh mục CHA (Bao gồm cả sản phẩm của danh mục con)
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name 
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE (p.category_id = ? OR p.category_id IN (SELECT id FROM categories WHERE parent_id = ?)) 
            AND p.status = 'active' 
            ORDER BY p.created_at DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) { // Sửa lại chỗ này cho an toàn
            
            ps.setInt(1, categoryId); 
            ps.setInt(2, categoryId); 
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                products.add(extractProductBasic(rs));
            }
            System.out.println("✅ Loaded " + products.size() + " products for parent category " + categoryId);
            
        } catch (SQLException e) {
            System.err.println("❌ getProductsByCategory: " + e.getMessage());
        }
        return products;
    }

    // Lấy sản phẩm theo Danh mục CON (Chỉ lấy chính xác ID đó)
    public List<Product> getProductsBySubCategory(int subCategoryId) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.*, c.name as category_name 
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.category_id = ? AND p.status = 'active' 
            ORDER BY p.created_at DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, subCategoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                products.add(extractProductBasic(rs));
            }
            System.out.println("✅ Loaded " + products.size() + " products for sub-category " + subCategoryId);
            
        } catch (SQLException e) {
            System.err.println("❌ getProductsBySubCategory: " + e.getMessage());
        }
        return products;
    }
    
    // Sản phẩm nổi bật
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> featured = new ArrayList<>();
        // Cập nhật JOIN để đồng bộ với hàm extractProductBasic
        String sql = """
            SELECT p.*, c.name as category_name 
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
                featured.add(extractProductBasic(rs));
            }
        } catch (SQLException e) {
            System.err.println("❌ getFeaturedProducts: " + e.getMessage());
        }
        return featured;
    }
    
    // ========================================
    // 5. ADMIN - CRUD
    // ========================================
    
    public boolean addProduct(Product p) {
        // Bổ sung gender, frame_material, lens_type vào SQL
        String sql = "INSERT INTO products (name, brand, category_id, stock, price, sale_price, description, image, is_featured, uv_protection, status, gender, frame_material, lens_type) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getName());
            ps.setString(2, p.getBrand());
            ps.setInt(3, p.getCategoryId());
            ps.setInt(4, p.getStock());
            ps.setBigDecimal(5, p.getPrice());
            ps.setBigDecimal(6, p.getSalePrice());
            ps.setString(7, p.getDescription());
            ps.setString(8, p.getImage()); 
            ps.setBoolean(9, p.isFeatured());
            ps.setBoolean(10, p.isUvProtection());
            ps.setString(11, "active"); // Mặc định khi thêm mới
            
            // Set thêm 3 tham số mới
            ps.setString(12, p.getGender());
            ps.setString(13, p.getFrameMaterial());
            ps.setString(14, p.getLensType());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ Đã thêm sản phẩm thành công vào DB!");
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi thêm sản phẩm: " + e.getMessage());
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
            ps.setBigDecimal(4, product.getSalePrice());
            ps.setInt(5, product.getStock());
            ps.setInt(6, product.getCategoryId());
            ps.setString(7, product.getBrand());
            ps.setString(8, product.getGender());
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
        }
        return false;
    }
    
    public boolean deleteProduct(int id) {
        String sql = "UPDATE products SET status = 'inactive' WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            System.out.println("✅ Soft deleted " + rows + " product(s)");
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ deleteProduct: " + e.getMessage());
        }
        return false;
    }
    
    // ========================================
    // 6. HELPER METHODS
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
        p.setGender(rs.getString("gender"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setStatus(rs.getString("status")); // Nên lấy thêm status
        
        // MỞ COMMENT DÒNG NÀY ĐỂ HIỂN THỊ ĐƯỢC TÊN DANH MỤC TRÊN WEB
        p.setCategoryName(rs.getString("category_name")); 
        
        return p;
    }
    
    private Product extractProductFull(ResultSet rs) throws SQLException {
        Product p = extractProductBasic(rs);
        p.setFrameMaterial(rs.getString("frame_material"));
        p.setLensType(rs.getString("lens_type"));
        p.setUvProtection(rs.getBoolean("uv_protection"));
        return p;
    }
    
    private List<ProductImage> getProductImages(int productId) {
        List<ProductImage> images = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY is_main DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImage img = new ProductImage();
                img.setId(rs.getInt("id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setIsMain(rs.getBoolean("is_main"));
                images.add(img);
            }
        } catch (SQLException e) {
            System.err.println("❌ getProductImages: " + e.getMessage());
        }
        return images;
    }
    
    private List<ProductVariant> getProductVariants(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariant v = new ProductVariant();
                v.setId(rs.getInt("id"));
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
}