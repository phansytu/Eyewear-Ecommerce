package DAO;

import java.sql.*;
import java.util.Timer;
import java.util.TimerTask;
import util.DBConnect;

public class OTPDao {
    
    // Lưu OTP
    public boolean saveOTP(int userId, String otp, String type, int expiryMinutes) {
        String sql = "INSERT INTO otp_codes (user_id, otp_code, type, expired_at) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otp);
            ps.setString(3, type);
            ps.setInt(4, expiryMinutes);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xác thực OTP
    public boolean validateOTP(int userId, String otp, String type) {
        String sql = "SELECT id FROM otp_codes WHERE user_id = ? AND otp_code = ? AND type = ? AND is_used = FALSE AND expired_at > NOW()";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otp);
            ps.setString(3, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                markOTPAsUsed(rs.getInt("id"));
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Đánh dấu OTP đã dùng
    private void markOTPAsUsed(int otpId) {
        String sql = "UPDATE otp_codes SET is_used = TRUE WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Xóa OTP cũ của user
    public void deleteOldOTP(int userId, String type) {
        String sql = "DELETE FROM otp_codes WHERE user_id = ? AND type = ? AND (is_used = TRUE OR expired_at < NOW())";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}