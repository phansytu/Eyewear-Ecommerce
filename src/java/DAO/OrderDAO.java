package DAO;

import dto.OrderDetailDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;
// Lưu ý: Import class DBConnect (class kết nối CSDL của bạn) vào đây
import util.DBConnect; 

public class OrderDAO {

    // =========================================================================
    // 1. CHỨC NĂNG DÀNH CHO KHÁCH HÀNG: ĐẶT HÀNG (CHECKOUT)
    // =========================================================================
    public boolean placeOrder(Order order, List<OrderDetail> listDetails) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;
        boolean isSuccess = false;

        try {
            conn = new DBConnect().getConnection();
            // TẮT AUTO COMMIT ĐỂ DÙNG TRANSACTION
            conn.setAutoCommit(false); 

            // 1. Lưu vào bảng orders
            String sqlOrder = "INSERT INTO orders (user_id, total_amount, status, address, phone, payment_status) VALUES (?, ?, 'pending', ?, ?, ?)";
            // Cờ Statement.RETURN_GENERATED_KEYS giúp lấy lại ID của order vừa tạo
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, order.getAddress());
            psOrder.setString(4, order.getPhone());
            psOrder.setString(5, order.getPaymentStatus());
            psOrder.executeUpdate();

            // Lấy ra Order ID vừa được tạo tự động trong DB
            rs = psOrder.getGeneratedKeys();
            int currentOrderId = 0;
            if (rs.next()) {
                currentOrderId = rs.getInt(1);
            }

            // 2. Lưu danh sách sản phẩm vào bảng order_details
            String sqlDetail = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            psDetail = conn.prepareStatement(sqlDetail);
            
            for (OrderDetail detail : listDetails) {
                psDetail.setInt(1, currentOrderId);
                psDetail.setInt(2, detail.getProductId());
                psDetail.setInt(3, detail.getQuantity());
                psDetail.setDouble(4, detail.getPrice());
                
                // Nếu bạn có dùng variant_id thì thêm setInt số 5 vào đây nhé
                psDetail.addBatch(); // Thêm vào hàng đợi
            }
            psDetail.executeBatch(); // Chạy lệnh insert hàng loạt

            // 3. NẾU MỌI THỨ ỔN THỎA -> LƯU THẬT SỰ VÀO DB
            conn.commit(); 
            isSuccess = true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                // NẾU CÓ LỖI XẢY RA -> HỦY BỎ TOÀN BỘ (ROLLBACK)
                if (conn != null) conn.rollback();
            } catch (Exception re) {
                re.printStackTrace();
            }
        } finally {
            // Đóng kết nối
            try {
                if (rs != null) rs.close();
                if (psOrder != null) psOrder.close();
                if (psDetail != null) psDetail.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return isSuccess;
    }

    // =========================================================================
    // 2. CHỨC NĂNG DÀNH CHO ADMIN: LẤY DANH SÁCH ĐƠN HÀNG
    // =========================================================================
    // 1. Lấy chi tiết sản phẩm kèm ảnh chính
    public List<OrderDetailDTO> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetailDTO> list = new ArrayList<>();
        // Query lấy thông tin SP + Ảnh chính (is_main = 1)
        String sql = "SELECT p.name, pi.image_url, od.quantity, od.price " +
                     "FROM order_details od " +
                     "JOIN products p ON od.product_id = p.id " +
                     "LEFT JOIN product_images pi ON p.id = pi.product_id AND pi.is_main = 1 " +
                     "WHERE od.order_id = ?";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String img = rs.getString("image_url");
                if (img == null) img = "default-product.jpg"; // Ảnh mặc định nếu SP không có ảnh
                
                list.add(new OrderDetailDTO(
                    rs.getString("name"),
                    img,
                    rs.getInt("quantity"),
                    rs.getDouble("price")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Lấy toàn bộ danh sách đơn hàng cho Admin
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setAddress(rs.getString("address"));
                order.setPhone(rs.getString("phone"));
                order.setPaymentStatus(rs.getString("payment_status"));
                
                // Nạp chi tiết sản phẩm vào từng đơn hàng
                order.setDetails(getOrderDetailsByOrderId(order.getId()));
                list.add(order);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. Cập nhật trạng thái (Duyệt/Hủy/Giao hàng)
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false;
        }
    }
}