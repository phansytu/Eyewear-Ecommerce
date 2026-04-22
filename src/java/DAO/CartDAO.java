package DAO;

import model.Cart;
import model.CartItem;
import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    // Lấy giỏ hàng của user (tạo mới nếu chưa có)
    public Cart getCartByUserId(int userId) {
        Cart cart = null;
        String sql = "SELECT * FROM carts WHERE user_id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                cart = new Cart();
                cart.setId(rs.getInt("id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setCreatedAt(rs.getTimestamp("created_at"));
            } else {
                // Tạo giỏ hàng mới
                cart = createCart(userId);
            }
            
            // Lấy danh sách items
            if (cart != null) {
                cart.setItems(getCartItems(cart.getId()));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return cart;
    }
    
    // Tạo giỏ hàng mới
    private Cart createCart(int userId) {
        String sql = "INSERT INTO carts (user_id) VALUES (?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, userId);
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                Cart cart = new Cart();
                cart.setId(rs.getInt(1));
                cart.setUserId(userId);
                return cart;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy danh sách items trong giỏ hàng (kèm thông tin sản phẩm)
    private List<CartItem> getCartItems(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.*, p.name as product_name, p.image_url as product_image, " +
                     "COALESCE(pv.price, p.price) as price, " +
                     "CONCAT(pv.color, ' - ', pv.size) as variant_name " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.product_id = p.id " +
                     "LEFT JOIN product_variants pv ON ci.variant_id = pv.id " +
                     "WHERE ci.cart_id = ? " +
                     "ORDER BY ci.id DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setCartId(rs.getInt("cart_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setVariantId(rs.getObject("variant_id", Integer.class));
                item.setQuantity(rs.getInt("quantity"));
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
                item.setPrice(rs.getDouble("price"));
                item.setVariantName(rs.getString("variant_name"));
                items.add(item);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    // Thêm sản phẩm vào giỏ hàng
    public boolean addToCart(int userId, int productId, Integer variantId, int quantity) {
        Cart cart = getCartByUserId(userId);
        if (cart == null) return false;
        
        // Kiểm tra sản phẩm đã có trong giỏ chưa
        CartItem existingItem = findCartItem(cart.getId(), productId, variantId);
        
        if (existingItem != null) {
            // Cập nhật số lượng
            return updateQuantity(existingItem.getId(), existingItem.getQuantity() + quantity);
        } else {
            // Thêm mới
            String sql = "INSERT INTO cart_items (cart_id, product_id, variant_id, quantity) VALUES (?, ?, ?, ?)";
            
            try (Connection conn = DBConnect.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setInt(1, cart.getId());
                ps.setInt(2, productId);
                if (variantId != null) {
                    ps.setInt(3, variantId);
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setInt(4, quantity);
                
                return ps.executeUpdate() > 0;
                
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
    }
    
    // Tìm item trong giỏ hàng
    private CartItem findCartItem(int cartId, int productId, Integer variantId) {
        String sql = "SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ? " +
                     "AND (variant_id = ? OR (variant_id IS NULL AND ? IS NULL))";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            if (variantId != null) {
                ps.setInt(3, variantId);
                ps.setInt(4, variantId);
            } else {
                ps.setNull(3, Types.INTEGER);
                ps.setNull(4, Types.INTEGER);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setCartId(rs.getInt("cart_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setVariantId(rs.getObject("variant_id", Integer.class));
                item.setQuantity(rs.getInt("quantity"));
                return item;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Cập nhật số lượng
    public boolean updateQuantity(int itemId, int quantity) {
        if (quantity <= 0) {
            return removeItem(itemId);
        }
        
        String sql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, itemId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa item khỏi giỏ hàng
    public boolean removeItem(int itemId) {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa toàn bộ giỏ hàng
    public boolean clearCart(int userId) {
        Cart cart = getCartByUserId(userId);
        if (cart == null) return false;
        
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cart.getId());
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy tổng số lượng sản phẩm trong giỏ
    public int getCartItemCount(int userId) {
        Cart cart = getCartByUserId(userId);
        if (cart == null) return 0;
        
        String sql = "SELECT SUM(quantity) as total FROM cart_items WHERE cart_id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cart.getId());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}