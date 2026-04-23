package DAO;

import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import model.User;
import util.DBConnect;

public class UserDAO {
    
    // Mã hóa mật khẩu
    public String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }
    
    // Kiểm tra mật khẩu
    public boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
    
    // Đăng ký user mới (có mã hóa mật khẩu)
    public boolean register(User user) {
        String sql = "INSERT INTO users (username, password, email, full_name, role, status, login_attempts) VALUES (?, ?, ?, ?, ?, 1, 0)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, hashPassword(user.getPassword())); // Mã hóa mật khẩu
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getFull_name());
            ps.setString(5, user.getRole() != null ? user.getRole() : "user");
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xác thực đăng nhập (có đếm số lần sai + khóa tài khoản)
    public User authenticate(String username, String password, String ipAddress) {
        User user = getUserByUsername(username);
        
        if (user == null) {
            return null;
        }
        
        // Kiểm tra tài khoản bị khóa
        if (user.isLocked()) {
            return null;
        }
        
        // Kiểm tra mật khẩu
        if (checkPassword(password, user.getPassword())) {
            // Đăng nhập thành công - reset số lần thử sai
            resetLoginAttempts(user.getId());
            updateLastLogin(user.getId());
            saveLoginHistory(user.getId(), ipAddress, "success");
            return user;
        } else {
            // Đăng nhập thất bại - tăng số lần thử
            incrementLoginAttempts(user.getId());
            saveLoginHistory(user.getId(), ipAddress, "failed");
            
            // Kiểm tra sau khi tăng, nếu đạt 5 lần thì khóa tài khoản
            User updatedUser = getUserByUsername(username);
            if (updatedUser.getLoginAttempts() >= 5) {
                lockAccount(user.getId(), 30); // Khóa 30 phút
            }
            return null;
        }
    }
    
    // Lấy user theo username
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy user theo email
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy user theo ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Tăng số lần đăng nhập sai
    private void incrementLoginAttempts(int userId) {
        String sql = "UPDATE users SET login_attempts = login_attempts + 1 WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Reset số lần đăng nhập sai
    private void resetLoginAttempts(int userId) {
        String sql = "UPDATE users SET login_attempts = 0, locked_until = NULL WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Khóa tài khoản
    private void lockAccount(int userId, int minutes) {
        String sql = "UPDATE users SET locked_until = DATE_ADD(NOW(), INTERVAL ? MINUTE) WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, minutes);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Mở khóa tài khoản
    public boolean unlockAccount(int userId) {
        String sql = "UPDATE users SET locked_until = NULL, login_attempts = 0 WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật last_login
    private void updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Lưu lịch sử đăng nhập
    private void saveLoginHistory(int userId, String ipAddress, String status) {
        String sql = "INSERT INTO login_history (user_id, ip_address, status) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, ipAddress);
            ps.setString(3, status);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Lưu reset token
    public boolean saveResetToken(int userId, String token, int expiryMinutes) {
        String sql = "UPDATE users SET reset_token = ?, reset_token_expiry = DATE_ADD(NOW(), INTERVAL ? MINUTE) WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, expiryMinutes);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xác thực reset token
    public User validateResetToken(String token) {
        String sql = "SELECT * FROM users WHERE reset_token = ? AND reset_token_expiry > NOW()";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Cập nhật mật khẩu mới
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashPassword(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    //cap nhat anh dai dien
    public boolean updateAvatar(int userId, String avatarUrl) {
        String sql = "UPDATE users SET avatar = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * Lấy danh sách tất cả users (cho admin)
     * @return List<User>
     */
    public java.util.List<User> getAllUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Cập nhật trạng thái user (active/inactive/banned)
     * @param userId ID user
     * @param status Trạng thái mới
     * @return true nếu cập nhật thành công
     */
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Kiểm tra username tồn tại
    public boolean isUsernameExists(String username) {
    String sql = "SELECT * FROM users WHERE username = ?";
    // Lấy connection mới từ DBConnect
    Connection conn = DBConnect.getConnection(); 
    
    // KIỂM TRA: Nếu conn vẫn null thì dừng lại ngay để tránh lỗi sập web
    if (conn == null) {
        System.out.println("LỖI: Không thể lấy kết nối từ DBConnect!");
        return false; 
    }

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try { if(conn != null) conn.close(); } catch(SQLException e) { e.printStackTrace(); }
    }
    return false;
}
    
    // Kiểm tra email tồn tại
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashPassword(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean checkCurrentPassword(int userId, String plainPassword) {
        String sql = "SELECT password FROM users WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                return checkPassword(plainPassword, hashedPassword);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    // ==========================================
    // PHẦN BỔ SUNG CHO TÍNH NĂNG PROFILE 
    // ==========================================
    
    // Cập nhật thông tin hồ sơ (Không đổi pass/username)
//    public boolean updateProfile(User user) {
//        String sql = "UPDATE users SET full_name=?, email=?, phone=?, gender=?, dob=?,  WHERE id=?";
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//             
//            ps.setString(1, user.getFull_name());
//            ps.setString(2, user.getEmail());
//            ps.setString(3, user.getPhone());
//            ps.setString(4, user.getGender());
//            ps.setString(5, user.getDob());
//            ps.setInt(6, user.getId());
//            
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFull_name(rs.getString("full_name"));
        user.setRole(rs.getString("role"));
        user.setCreateAt(rs.getTimestamp("created_at"));
        user.setLoginAttempts(rs.getInt("login_attempts"));
        user.setLockedUntil(rs.getTimestamp("locked_until"));
        user.setStatus(rs.getString("status"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        user.setResetToken(rs.getString("reset_token"));
        user.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
        
        // BỔ SUNG 3 DÒNG NÀY (Thêm try-catch nhỏ để tránh lỗi nếu DB chưa có cột này)
        try {
            user.setPhone(rs.getString("phone"));
            user.setGender(rs.getString("gender"));
            user.setDob(rs.getString("dob"));
            user.setAvatar(rs.getString("avatar"));
        } catch (SQLException e) {
            // Bỏ qua nếu các cột này chưa được tạo trong Database
        }
        
        return user;
    }
    // PHẦN BỔ SUNG CHO TÍNH NĂNG PROFILE 
    // ==========================================
    
    /**
     * Cập nhật thông tin hồ sơ đầy đủ (bao gồm address)
     * @param user User object chứa thông tin cần cập nhật
     * @return true nếu cập nhật thành công
     */
    public boolean updateUserProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, gender = ?, dob = ?, address = ?, avatar = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, user.getFull_name());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getGender());
            ps.setString(5, user.getDob());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getAvatar());
            ps.setInt(8, user.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật thông tin cơ bản (không bao gồm avatar)
     * @param user User object
     * @return true nếu cập nhật thành công
     */
    public boolean updateProfileBasic(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, gender = ?, dob = ?, address = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, user.getFull_name());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getGender());
            ps.setString(5, user.getDob());
            ps.setString(6, user.getAddress());
            ps.setInt(7, user.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // Thêm vào UserDAO.java

/**
 * Lấy tổng số người dùng
 * @return tổng số người dùng
 */
/**
 * Lấy tổng số user (không bao gồm user đã xóa mềm)
 */
public int getTotalUsers() {
    String sql = "SELECT COUNT(*) FROM users WHERE status != 'deleted'";
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

/**
 * Lấy tổng số user có role = 'user' (khách hàng, không bao gồm admin)
 */
public int getTotalCustomerUsers() {
    String sql = "SELECT COUNT(*) FROM users WHERE role = 'user' AND status != 'deleted'";
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

/**
 * Lấy số lượng người dùng mới trong tháng
 * @return số lượng người dùng mới
 */
public int getNewUsersThisMonth() {
    String sql = "SELECT COUNT(*) as total FROM users WHERE role = 'user' AND MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())";
    
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt("total");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
    
    // ==========================================
    // PHẦN HIỆN CÓ (giữ nguyên)
    // ==========================================
    
    // Các phương thức cũ của bạn vẫn giữ nguyên...
    // (authenticate, register, getUserByUsername, v.v...)
    
    // ==========================================
    // PHẦN THÊM MỚI CHO QUẢN LÝ ADMIN
    // ==========================================
    
    /**
     * Lấy danh sách tất cả users kèm thống kê đơn hàng (tổng số đơn, tổng tiền)
     * KHÔNG cần thêm cột vào database
     */
    public List<User> getAllUsersWithStats() {
        List<User> users = new ArrayList<>();
        String sql = """
            SELECT u.*, 
                   COUNT(o.id) as total_orders,
                   COALESCE(SUM(o.total_amount), 0) as total_spent
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id AND o.status = 'delivered'
            GROUP BY u.id
            ORDER BY total_spent DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setTotalOrders(rs.getInt("total_orders"));
                user.setTotalSpent(rs.getDouble("total_spent"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Lấy user theo ID kèm thống kê đơn hàng
     */
    public User getUserWithStats(int userId) {
        String sql = """
            SELECT u.*, 
                   COUNT(o.id) as total_orders,
                   COALESCE(SUM(o.total_amount), 0) as total_spent
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id AND o.status = 'delivered'
            WHERE u.id = ?
            GROUP BY u.id
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setTotalOrders(rs.getInt("total_orders"));
                user.setTotalSpent(rs.getDouble("total_spent"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Tìm kiếm users theo từ khóa
     */
    public List<User> searchUsers(String keyword) {
        List<User> users = new ArrayList<>();
        String sql = """
            SELECT u.*, 
                   COUNT(o.id) as total_orders,
                   COALESCE(SUM(o.total_amount), 0) as total_spent
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id AND o.status = 'delivered'
            WHERE u.username LIKE ? OR u.email LIKE ? OR u.full_name LIKE ? OR u.phone LIKE ?
            GROUP BY u.id
            ORDER BY u.id DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setTotalOrders(rs.getInt("total_orders"));
                user.setTotalSpent(rs.getDouble("total_spent"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Lấy users theo role
     */
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = """
            SELECT u.*, 
                   COUNT(o.id) as total_orders,
                   COALESCE(SUM(o.total_amount), 0) as total_spent
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id AND o.status = 'delivered'
            WHERE u.role = ?
            GROUP BY u.id
            ORDER BY u.id DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setTotalOrders(rs.getInt("total_orders"));
                user.setTotalSpent(rs.getDouble("total_spent"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Lấy users theo status
     */
    public List<User> getUsersByStatus(String status) {
        List<User> users = new ArrayList<>();
        String sql = """
            SELECT u.*, 
                   COUNT(o.id) as total_orders,
                   COALESCE(SUM(o.total_amount), 0) as total_spent
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id AND o.status = 'delivered'
            WHERE u.status = ?
            GROUP BY u.id
            ORDER BY u.id DESC
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setTotalOrders(rs.getInt("total_orders"));
                user.setTotalSpent(rs.getDouble("total_spent"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Khóa tài khoản user
     */
    public boolean lockUser(int userId) {
        String sql = "UPDATE users SET status = 'locked' WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Mở khóa tài khoản user
     */
    public boolean unlockUser(int userId) {
        String sql = "UPDATE users SET status = 'active' WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Đổi role user (user -> admin hoặc ngược lại)
     */
    public boolean changeUserRole(int userId, String newRole) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newRole);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kích hoạt user
     */
    public boolean activateUser(int userId) {
        return unlockUser(userId);
    }
    
    /**
     * Xóa user (soft delete - chuyển status thành 'deleted')
     */
    public boolean deleteUser(int userId) {
        String sql = "UPDATE users SET status = 'deleted' WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy tổng số users
     */

    
    /**
     * Lấy số user đang hoạt động
     */
    public int getActiveUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'active'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Lấy số user bị khóa
     */
    public int getLockedUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'locked'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Lấy số user là admin
     */
    public int getAdminUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'admin'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Lấy số user VIP (tổng chi tiêu > 5,000,000)
     */
    public int getVipUsersCount() {
        String sql = """
            SELECT COUNT(*) FROM (
                SELECT u.id, COALESCE(SUM(o.total_amount), 0) as total_spent
                FROM users u
                LEFT JOIN orders o ON u.id = o.user_id AND o.status = 'delivered'
                GROUP BY u.id
                HAVING total_spent > 5000000
            ) as vip_users
            """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
   
    
}
