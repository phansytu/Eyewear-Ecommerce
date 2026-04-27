package DAO;

import model.Order;
import model.OrderDetail;
import model.Product;
import util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    // ==========================================
    // PHẦN CHO USER (Lấy đơn hàng của user)
    // ==========================================
    
    /**
     * Lấy danh sách đơn hàng của user
     * @param userId ID của user
     * @return List<Order>
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        
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
     * Lấy đơn hàng theo ID
     * @param orderId ID của đơn hàng
     * @return Order object
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        
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
    // Thêm vào OrderDAO.java

/**
 * Hủy đơn hàng (chỉ cho phép hủy khi đơn hàng đang ở trạng thái pending)
 * @param orderId ID đơn hàng cần hủy
 * @return true nếu hủy thành công
 */
public boolean cancelOrder(int orderId) {
    // Kiểm tra trạng thái hiện tại trước khi hủy
    Order order = getOrderById(orderId);
    if (order == null) {
        return false;
    }
    
    // Chỉ cho phép hủy đơn hàng đang ở trạng thái pending hoặc confirmed
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
 * Hủy đơn hàng kèm lý do (ghi log)
 * @param orderId ID đơn hàng
 * @param reason Lý do hủy
 * @return true nếu thành công
 */
public boolean cancelOrder(int orderId, String reason) {
    Order order = getOrderById(orderId);
    if (order == null) {
        return false;
    }
    
    // Chỉ cho phép hủy đơn hàng chưa giao
    if ("delivered".equals(order.getStatus())) {
        return false;
    }
    
    Connection conn = null;
    try {
        conn = DBConnect.getConnection();
        conn.setAutoCommit(false);
        
        // Cập nhật trạng thái đơn hàng
        String sqlOrder = "UPDATE orders SET status = 'cancelled' WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlOrder)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
        
        // Ghi log hủy đơn hàng (nếu có bảng order_cancel_logs)
        String sqlLog = "INSERT INTO order_cancel_logs (order_id, reason, cancelled_by, cancelled_at) VALUES (?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sqlLog)) {
            ps.setInt(1, orderId);
            ps.setString(2, reason);
            ps.setString(3, "system"); // Có thể lấy từ session user
            ps.executeUpdate();
        }
        
        conn.commit();
        return true;
    } catch (SQLException e) {
        e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return false;
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
// Thêm vào OrderDAO.java

/**
 * Lấy đơn hàng theo ngày
 * @param date Ngày cần lọc (format: yyyy-MM-dd)
 * @return List<Order>
 */
 // Lấy đơn hàng theo ngày
    public List<Order> getOrdersByDate(String date) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.full_name, u.email " +
                     "FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE DATE(o.created_at) = ? " +
                     "ORDER BY o.created_at DESC";
        
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
 * Khôi phục đơn hàng đã hủy (chuyển lại trạng thái pending)
 * @param orderId ID đơn hàng
 * @return true nếu thành công
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
     * @param orderId ID của đơn hàng
     * @return List<OrderDetail>
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
    
    // ==========================================
    // PHẦN CHO ADMIN (Lấy tất cả đơn hàng)
    // ==========================================
    
    /**
     * Lấy tất cả đơn hàng (cho admin)
     * @return List<Order>
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username as user_name FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // Thêm username vào order (có thể thêm field tạm thời)
                order.setOrderDetails(getOrderDetailsByOrderId(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * Lấy danh sách đơn hàng theo trạng thái (cho admin)
     * @param status Trạng thái đơn hàng
     * @return List<Order>
     */
    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username as user_name FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
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
     * Tìm kiếm đơn hàng theo nhiều tiêu chí (cho admin)
     * @param keyword Từ khóa tìm kiếm (mã đơn, tên khách, SĐT)
     * @return List<Order>
     */
    public List<Order> searchOrders(String keyword) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username as user_name FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE CAST(o.id AS CHAR) LIKE ? OR u.username LIKE ? OR o.phone LIKE ? " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
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
    // PHẦN CHO CHECKOUT (Tạo đơn hàng)
    // ==========================================
    
    /**
     * Đặt hàng (tạo đơn hàng và chi tiết đơn hàng)
     * @param order Order object
     * @param details List<OrderDetail>
     * @return true nếu thành công
     */
    public boolean placeOrder(Order order, List<OrderDetail> details) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet generatedKeys = null;
        
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // 1. Chèn vào bảng orders
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
                throw new SQLException("Tạo đơn hàng thất bại, không có dòng nào được thêm.");
            }
            
            // Lấy order_id vừa tạo
            generatedKeys = psOrder.getGeneratedKeys();
            int orderId;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Tạo đơn hàng thất bại, không lấy được ID.");
            }
            
            // 2. Chèn vào bảng order_details
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
            
            int[] detailResults = psDetail.executeBatch();
            
            // Kiểm tra tất cả detail đều được thêm thành công
            for (int result : detailResults) {
                if (result == Statement.EXECUTE_FAILED) {
                    throw new SQLException("Thêm chi tiết đơn hàng thất bại.");
                }
            }
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            // Đóng tất cả resources
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (psDetail != null) psDetail.close();
                if (psOrder != null) psOrder.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // ==========================================
    // PHẦN CHO ADMIN (Cập nhật đơn hàng)
    // ==========================================
    
    /**
     * Cập nhật trạng thái đơn hàng
     * @param orderId ID đơn hàng
     * @param status Trạng thái mới (pending, confirmed, shipping, delivered, cancelled)
     * @return true nếu thành công
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
     * @param orderId ID đơn hàng
     * @param paymentStatus Trạng thái thanh toán (unpaid, paid)
     * @return true nếu thành công
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
     * Cập nhật cả trạng thái đơn hàng và thanh toán
     * @param orderId ID đơn hàng
     * @param status Trạng thái đơn hàng
     * @param paymentStatus Trạng thái thanh toán
     * @return true nếu thành công
     */
    public boolean updateOrder(int orderId, String status, String paymentStatus) {
        String sql = "UPDATE orders SET status = ?, payment_status = ? WHERE id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, paymentStatus);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa đơn hàng (chỉ dùng cho testing, không nên xóa thực tế)
     * @param orderId ID đơn hàng
     * @return true nếu thành công
     */
    public boolean deleteOrder(int orderId) {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);
            
            // Xóa order_details trước
            String sqlDetails = "DELETE FROM order_details WHERE order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlDetails)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }
            
            // Xóa order
            String sqlOrder = "DELETE FROM orders WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder)) {
                ps.setInt(1, orderId);
                int result = ps.executeUpdate();
                conn.commit();
                return result > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Thống kê số lượng đơn hàng theo trạng thái
     * @return int[]
     */
    public int[] getOrderStatistics() {
        int[] stats = new int[5]; // pending, confirmed, shipping, delivered, cancelled
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
     * Tính tổng doanh thu
     * @return tổng doanh thu từ các đơn hàng đã delivered và paid
     */
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) as total FROM orders WHERE status = 'delivered' AND payment_status = 'paid'";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ==========================================
    // MAP ResultSet to Order Object
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
        
        // Xử lý voucher_id có thể null
        int voucherId = rs.getInt("voucher_id");
        order.setVoucherId(rs.wasNull() ? null : voucherId);
        
        order.setPaymentStatus(rs.getString("payment_status"));
        
        return order;
    }
    // Thêm các phương thức sau vào OrderDAO.java

/**
 * Lấy danh sách đơn hàng gần đây
 * @param limit Số lượng đơn hàng cần lấy
 * @return List<Order>
 */
public List<Order> getRecentOrders(int limit) {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT o.*, u.username as user_name FROM orders o " +
                 "LEFT JOIN users u ON o.user_id = u.id " +
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
 * Lấy top sản phẩm bán chạy nhất
 * @param limit Số lượng sản phẩm cần lấy
 * @return List<Object[]> [product_id, product_name, total_quantity, total_revenue]
 */
public List<Object[]> getTopSellingProducts(int limit) {
    List<Object[]> topProducts = new ArrayList<>();
    String sql = "SELECT p.id, p.name, SUM(od.quantity) as total_quantity, SUM(od.quantity * od.price) as total_revenue " +
                 "FROM order_details od " +
                 "JOIN products p ON od.product_id = p.id " +
                 "JOIN orders o ON od.order_id = o.id " +
                 "WHERE o.status = 'delivered' " +
                 "GROUP BY p.id, p.name " +
                 "ORDER BY total_quantity DESC LIMIT ?";
    
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, limit);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Object[] product = new Object[4];
            product[0] = rs.getInt("id");
            product[1] = rs.getString("name");
            product[2] = rs.getInt("total_quantity");
            product[3] = rs.getDouble("total_revenue");
            topProducts.add(product);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return topProducts;
}

/**
 * Lấy doanh thu theo tháng
 * @param months Số tháng gần nhất
 * @return List<Object[]> [month, year, revenue]
 */
public List<Object[]> getMonthlyRevenue(int months) {
    List<Object[]> monthlyRevenue = new ArrayList<>();
    String sql = "SELECT YEAR(created_at) as year, MONTH(created_at) as month, SUM(total_amount) as revenue " +
                 "FROM orders " +
                 "WHERE status = 'delivered' AND payment_status = 'paid' " +
                 "AND created_at >= DATE_SUB(NOW(), INTERVAL ? MONTH) " +
                 "GROUP BY YEAR(created_at), MONTH(created_at) " +
                 "ORDER BY year DESC, month DESC";
    
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, months);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Object[] monthData = new Object[3];
            monthData[0] = rs.getInt("year");
            monthData[1] = rs.getInt("month");
            monthData[2] = rs.getDouble("revenue");
            monthlyRevenue.add(monthData);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return monthlyRevenue;
}
// Khi đơn hàng được xác nhận là 'delivered'
public boolean confirmOrderDelivery(int orderId) {
    // Cập nhật trạng thái đơn hàng
    boolean updated = updateOrderStatus(orderId, "delivered");
    
    if (updated) {
        // Lấy danh sách sản phẩm trong đơn hàng
        List<OrderDetail> details = getOrderDetailsByOrderId(orderId);
        
        // Cập nhật sold_quantity cho từng sản phẩm
        ProductDAO productDAO = new ProductDAO();
        for (OrderDetail detail : details) {
            productDAO.updateProductSoldQuantity(detail.getProductId(), detail.getQuantity());
        }
    }
    return updated;
}

}