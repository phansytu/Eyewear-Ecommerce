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
                
                // Load images
                product.setImages(getProductImages(id));
                
                // Load variants
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
        
        // Keyword search
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.brand LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        
        // Category filter
        if (category != null && !category.equals("0")) {
            sql.append(" AND p.category_id = ?");
            params.add(category);
        }
        
        // Price range
        if (minPrice != null && !minPrice.isEmpty()) {
            sql.append(" AND p.sale_price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql.append(" AND p.sale_price <= ?");
            params.add(maxPrice);
        }
        
        // Gender filter
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
    // 4. ADMIN - CRUD
    // ========================================
    
    // Thêm sản phẩm
    public boolean addProduct(Product product) {
        String sql = """
            INSERT INTO products (name, description, price, sale_price, stock, category_id, brand, 
            gender, frame_material, lens_type, uv_protection, is_featured, image, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active')
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
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
            ps.setBoolean(12, product.isIsFeatured());
            ps.setString(13, product.getImage());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int newId = generatedKeys.getInt(1);
                    System.out.println("✅ Added product ID: " + newId);
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ addProduct: " + e.getMessage());
        }
        return false;
    }
    
    // Cập nhật sản phẩm
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
            ps.setBoolean(12, product.isIsFeatured());
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
    
    // Xóa sản phẩm (Soft delete)
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
    // 5. HELPER METHODS
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
        p.setIsFeatured(rs.getBoolean("is_featured"));
        p.setGender(rs.getString("gender"));
        p.setCategoryId(rs.getInt("category_id"));
        return p;
    }
    
    private Product extractProductFull(ResultSet rs) throws SQLException {
        Product p = extractProductBasic(rs);
        p.setFrameMaterial(rs.getString("frame_material"));
        p.setLensType(rs.getString("lens_type"));
        p.setUvProtection(rs.getBoolean("uv_protection"));
        return p;
    }
    
    // Lấy ảnh sản phẩm
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
            e.printStackTrace();
        }
        return images;
    }
    
    // Lấy biến thể sản phẩm
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
            e.printStackTrace();
        }
        return variants;
    }
    // Thêm method này vào ProductDAO class
public List<Product> getProductsByCategory(int categoryId) {
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
        
        ps.setInt(1, categoryId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            products.add(extractProductBasic(rs));
        }
        System.out.println("✅ Loaded " + products.size() + " products for category " + categoryId);
        
    } catch (SQLException e) {
        System.err.println("❌ getProductsByCategory: " + e.getMessage());
    }
    return products;
}
    // Sản phẩm nổi bật
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> featured = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_featured = TRUE AND status = 'active' ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                featured.add(extractProductBasic(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return featured;
    }
    
}   