package DAO;

import model.Category;
import model.Product;
import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    // ========================================
    // 1. TẤT CẢ DANH MỤC (Tree structure)
    // ========================================
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY parent_id, name";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categories.add(extractCategory(rs));
            }
            
            // Build tree structure
            buildCategoryTree(categories);
            System.out.println("✅ Loaded " + categories.size() + " categories");
            
        } catch (SQLException e) {
            System.err.println("❌ getAllCategories: " + e.getMessage());
        }
        return categories;
    }
    
    // ========================================
    // 2. DANH MỤC THEO PARENT ID
    // ========================================
    public List<Category> getCategoriesByParent(int parentId) {
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
            e.printStackTrace();
        }
        return subCats;
    }
    
    // ========================================
    // 3. DANH MỤC + SẢN PHẨM CON
    // ========================================
    public Category getCategoryWithProducts(int categoryId) {
        Category category = getCategoryById(categoryId);
        if (category != null) {
            ProductDAO productDAO = new ProductDAO();
            category.setProducts(productDAO.getProductsByCategory(categoryId));
        }
        return category;
    }
    
    // ========================================
    // 4. ADMIN CRUD
    // ========================================
    
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (name, description, image, parent_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());
            ps.setInt(4, category.getParentId());
            
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
            ps.setInt(4, category.getParentId());
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
        cat.setParentId(rs.getInt("parent_id"));
        return cat;
    }
    
    private Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Build hierarchical tree
    private void buildCategoryTree(List<Category> categories) {
        for (Category cat : categories) {
            if (cat.isParent()) {
                cat.setSubCategories(getSubCategories(cat.getId(), categories));
            }
        }
    }
    
    private List<Category> getSubCategories(int parentId, List<Category> allCats) {
        List<Category> subs = new ArrayList<>();
        for (Category cat : allCats) {
            if (cat.getParentId() == parentId) {
                subs.add(cat);
            }
        }
        return subs;
    }
}