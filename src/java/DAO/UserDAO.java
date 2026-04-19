package DAO;

import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
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
    // ==========================================
    // PHẦN BỔ SUNG CHO TÍNH NĂNG PROFILE 
    // ==========================================
    
    // Cập nhật thông tin hồ sơ (Không đổi pass/username)
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET full_name=?, email=?, phone=?, gender=?, dob=? WHERE id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, user.getFull_name());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getGender());
            ps.setString(5, user.getDob());
            ps.setInt(6, user.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
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
}