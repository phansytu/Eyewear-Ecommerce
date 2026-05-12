package DAO;

import model.Order;
import model.OrderDetail;
import model.Product;
import util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    /**
     * Lấy đơn hàng theo ID
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Hủy đơn hàng
     */
    public boolean cancelOrder(int orderId) {
        Order order = getOrderById(orderId);
        if (order == null) return false;
        
        if (!"pending".equals(order.getStatus()) && !"confirmed".equals(order.getStatus())) {
            return false;
        }
        
        String sql = "UPDATE orders SET status = 'cancelled' WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hủy đơn hàng kèm lý do
     */
    public boolean cancelOrder(int orderId, String reason) {
        Order order = getOrderById(orderId);
        if (order == null) return false;
        if ("delivered".equals(order.getStatus())) return false;
        
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);
            
            String sqlOrder = "UPDATE orders SET status = 'cancelled' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    /**
     * Lấy đơn hàng theo ngày
     */
    public List<Order> getOrdersByDate(String date) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE DATE(o.created_at) = ? ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Khôi phục đơn hàng đã hủy
     */
    public boolean restoreCancelledOrder(int orderId) {
        String sql = "UPDATE orders SET status = 'pending' WHERE id = ? AND status = 'cancelled'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy chi tiết đơn hàng theo order_id
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.*, p.name as product_name, p.image as product_image " +
                     "FROM order_details od " +
                     "LEFT JOIN products p ON od.product_id = p.id " +
                     "WHERE od.order_id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setId(rs.getInt("id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getDouble("price"));
                detail.setVariantId(rs.getInt("variant_id") == 0 ? null : rs.getInt("variant_id"));
                detail.setProductName(rs.getString("product_name"));
                detail.setProductImage(rs.getString("product_image"));
                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }
    
    /**
     * Lấy tất cả đơn hàng (Admin)
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Lấy danh sách đơn hàng theo trạng thái (Admin)
     */
    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.status = ? ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Tìm kiếm đơn hàng (Admin)
     */
    public List<Order> searchOrders(String keyword) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE CAST(o.id AS CHAR) LIKE ? OR u.username LIKE ? OR u.full_name LIKE ? OR o.phone LIKE ? " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    // ==========================================
    // CHECKOUT - TẠO ĐƠN HÀNG
    // ==========================================
    
    public int placeOrder(Order order, List<OrderDetail> details) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet generatedKeys = null;
        
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);
            
            String sqlOrder = "INSERT INTO orders (user_id, total_amount, status, address, phone, payment_status) " +
                              "VALUES (?, ?, 'pending', ?, ?, ?)";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, order.getAddress());
            psOrder.setString(4, order.getPhone());
            psOrder.setString(5, order.getPaymentStatus() != null ? order.getPaymentStatus() : "unpaid");
            
            int affectedRows = psOrder.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Tạo đơn hàng thất bại.");
            }
            
            generatedKeys = psOrder.getGeneratedKeys();
            int orderId;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Không lấy được ID đơn hàng.");
            }
            
            String sqlDetail = "INSERT INTO order_details (order_id, product_id, quantity, price, variant_id) " +
                               "VALUES (?, ?, ?, ?, ?)";
            psDetail = conn.prepareStatement(sqlDetail);
            
            for (OrderDetail detail : details) {
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, detail.getProductId());
                psDetail.setInt(3, detail.getQuantity());
                psDetail.setDouble(4, detail.getPrice());
                if (detail.getVariantId() != null) {
                    psDetail.setInt(5, detail.getVariantId());
                } else {
                    psDetail.setNull(5, Types.INTEGER);
                }
                psDetail.addBatch();
            }
            
            psDetail.executeBatch();
            
            conn.commit();
            return orderId;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return -1;
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (psDetail != null) psDetail.close();
                if (psOrder != null) psOrder.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    /**
     * Cập nhật trạng thái đơn hàng
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật trạng thái thanh toán
     */
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Thống kê đơn hàng theo trạng thái
     */
    public int[] getOrderStatistics() {
        int[] stats = new int[5];
        String sql = "SELECT status, COUNT(*) as count FROM orders GROUP BY status";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                switch (status) {
                    case "pending": stats[0] = count; break;
                    case "confirmed": stats[1] = count; break;
                    case "shipping": stats[2] = count; break;
                    case "delivered": stats[3] = count; break;
                    case "cancelled": stats[4] = count; break;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    /**
     * Tổng doanh thu
     */
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) as total FROM orders WHERE status = 'delivered' AND payment_status = 'paid'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Đơn hàng gần đây
     */
    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.created_at DESC LIMIT ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Top sản phẩm bán chạy
     */
    public List<Object[]> getTopSellingProducts(int limit) {
        List<Object[]> topProducts = new ArrayList<>();
        String sql = "SELECT p.id, p.name, SUM(od.quantity) as total_quantity, SUM(od.quantity * od.price) as total_revenue " +
                     "FROM order_details od " +
                     "JOIN products p ON od.product_id = p.id " +
                     "JOIN orders o ON od.order_id = o.id " +
                     "WHERE o.status = 'delivered' " +
                     "GROUP BY p.id, p.name ORDER BY total_quantity DESC LIMIT ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                topProducts.add(new Object[]{
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getInt("total_quantity"),
                    rs.getDouble("total_revenue")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topProducts;
    }
    
    /**
     * Doanh thu theo tháng
     */
    public List<Object[]> getMonthlyRevenue(int months) {
        List<Object[]> monthlyRevenue = new ArrayList<>();
        String sql = "SELECT YEAR(created_at) as year, MONTH(created_at) as month, SUM(total_amount) as revenue " +
                     "FROM orders WHERE status = 'delivered' AND payment_status = 'paid' " +
                     "AND created_at >= DATE_SUB(NOW(), INTERVAL ? MONTH) " +
                     "GROUP BY YEAR(created_at), MONTH(created_at) ORDER BY year DESC, month DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, months);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                monthlyRevenue.add(new Object[]{
                    rs.getInt("year"),
                    rs.getInt("month"),
                    rs.getDouble("revenue")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monthlyRevenue;
    }
    
    /**
     * Xác nhận giao hàng
     */
    public boolean confirmOrderDelivery(int orderId) {
        boolean updated = updateOrderStatus(orderId, "delivered");
        if (updated) {
            List<OrderDetail> details = getOrderDetailsByOrderId(orderId);
            ProductDAO productDAO = new ProductDAO();
            for (OrderDetail detail : details) {
                productDAO.updateProductSoldQuantity(detail.getProductId(), detail.getQuantity());
            }
        }
        return updated;
    }
    
    /**
     * Lấy đơn hàng theo user
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Lấy đơn hàng theo user và trạng thái
     */
    public List<Order> getOrdersByUserIdAndStatus(int userId, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? AND o.status = ? ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    // ==========================================
    // MAPPER
    // ==========================================
    
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setAddress(rs.getString("address"));
        order.setPhone(rs.getString("phone"));
        
        // Map thông tin user từ JOIN
        try {
            order.setCustomerUsername(rs.getString("username"));
            order.setCustomerFullName(rs.getString("full_name"));
            order.setCustomerEmail(rs.getString("email"));
        } catch (SQLException e) {
            // Bỏ qua nếu cột không tồn tại
        }
        
        try {
            int voucherId = rs.getInt("voucher_id");
            order.setVoucherId(rs.wasNull() ? null : voucherId);
        } catch (SQLException e) {
            // Bỏ qua nếu cột không tồn tại
        }
        
        try {
            order.setPaymentStatus(rs.getString("payment_status"));
        } catch (SQLException e) {
            order.setPaymentStatus("unpaid");
        }
        
        return order;
    }


/**
 * Kiểm tra user đã mua sản phẩm chưa (đơn hàng đã giao)
 */
public boolean hasUserPurchasedProduct(int userId, int productId) {
    String sql = "SELECT COUNT(*) FROM order_details od " +
                 "JOIN orders o ON od.order_id = o.id " +
                 "WHERE o.user_id = ? AND od.product_id = ? AND o.status = 'delivered'";
    
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.setInt(2, productId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

}