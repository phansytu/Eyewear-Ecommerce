package DAO;

import model.Category;
import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    // ========================================
    // 1. LẤY TẤT CẢ DANH MỤC (Phục vụ Header / Menu)
    // ========================================
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        // Chỉ lấy các danh mục CHA (parent_id IS NULL hoặc = 0) để hiển thị trên thanh menu chính
        String sql = "SELECT * FROM categories WHERE parent_id IS NULL OR parent_id = 0 ORDER BY id";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category cat = extractCategory(rs);
                // Lấy luôn danh sách danh mục con gán vào danh mục cha này
                cat.setSubCategories(getSubCategoriesByParentId(cat.getId()));
                categories.add(cat);
            }
            System.out.println("✅ Loaded " + categories.size() + " parent categories with their tree");
            
        } catch (SQLException e) {
            System.err.println("❌ getAllCategories: " + e.getMessage());
        }
        return categories;
    }
    
    // ========================================
    // 2. LẤY DANH MỤC CON THEO ID CHA (Phục vụ Sidebar JSP)
    // ========================================
    // Đã đổi tên hàm khớp với CategoryServlet: getSubCategoriesByParentId
    public List<Category> getSubCategoriesByParentId(int parentId) {
        List<Category> subCats = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE parent_id = ? ORDER BY name";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subCats.add(extractCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("❌ getSubCategoriesByParentId: " + e.getMessage());
        }
        return subCats;
    }
    
    // ========================================
    // 3. CHI TIẾT 1 DANH MỤC
    // ========================================
    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractCategory(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ getCategoryById: " + e.getMessage());
        }
        return null;
    }

    // Tiện ích: Lấy danh mục kèm luôn danh sách sản phẩm (Dành cho các logic đặc thù khác)
    public Category getCategoryWithProducts(int categoryId) {
        Category category = getCategoryById(categoryId);
        if (category != null) {
            ProductDAO productDAO = new ProductDAO();
            category.setProducts(productDAO.getProductsByCategory(categoryId));
        }
        return category;
    }
    
    // ========================================
    // 4. ADMIN CRUD (Thêm, Sửa, Xóa)
    // ========================================
    
    public boolean addCategory(Category category) {
        // Hỗ trợ trường hợp parent_id có thể NULL (Danh mục cha)
        String sql = "INSERT INTO categories (name, description, image, parent_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());
            
            if (category.getParentId() > 0) {
                ps.setInt(4, category.getParentId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    category.setId(rs.getInt(1));
                    System.out.println("✅ Added category ID: " + category.getId());
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ addCategory: " + e.getMessage());
        }
        return false;
    }
    
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET name=?, description=?, image=?, parent_id=? WHERE id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());
            
            if (category.getParentId() > 0) {
                ps.setInt(4, category.getParentId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            
            ps.setInt(5, category.getId());
            
            int rows = ps.executeUpdate();
            System.out.println("✅ Updated " + rows + " category(ies)");
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ updateCategory: " + e.getMessage());
        }
        return false;
    }
    
    public boolean deleteCategory(int id) {
        // Lưu ý: Nếu xóa danh mục cha, cần quyết định xử lý danh mục con (xóa theo hoặc set parent_id = null)
        // Ở đây mặc định chạy lệnh DELETE cơ bản. Hãy setup ON DELETE CASCADE trong DB nếu muốn tự động xóa con.
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            System.out.println("✅ Deleted " + rows + " category(ies)");
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ deleteCategory: " + e.getMessage());
        }
        return false;
    }
    
    // ========================================
    // 5. HELPER METHODS
    // ========================================
    
    private Category extractCategory(ResultSet rs) throws SQLException {
        Category cat = new Category();
        cat.setId(rs.getInt("id"));
        cat.setName(rs.getString("name"));
        cat.setDescription(rs.getString("description"));
        cat.setImage(rs.getString("image"));
        // Nếu DB trả về NULL cho INT, rs.getInt() sẽ trả về 0. Điều này hoàn toàn hợp lý.
        cat.setParentId(rs.getInt("parent_id")); 
        return cat;
    }
}