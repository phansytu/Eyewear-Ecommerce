package DAO;

import java.sql.*;
import util.DBConnect;

public class OTPDao {

    /**
     * Validate type - CHỈ CHẤP NHẬN GIÁ TRỊ HỢP LỆ
     * ENUM trong DB: 'unlock', 'reset_password'
     */
    private String validateType(String type) {
        if (type == null) return "unlock";
        
        String normalized = type.toLowerCase().trim();
        
        // Kiểm tra giá trị hợp lệ
        if (normalized.equals("reset_password") || normalized.equals("reset") || normalized.equals("forgot_password")) {
            return "reset_password";
        }
        if (normalized.equals("unlock") || normalized.equals("lock") || normalized.equals("unlock_account")) {
            return "unlock";
        }
        
        // Giá trị mặc định
        return "unlock";
    }

    // Lưu OTP
    public boolean saveOTP(int userId, String otp, String type, int expiryMinutes) {
        String validType = validateType(type);
        
        // SỬA: Tên bảng là "otp_codes", tên cột là "otp_code" (KHÔNG phải "otp_codes_code")
        String sql = "INSERT INTO otp_codes (user_id, otp_code, type, expired_at, created_at, is_used) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE), NOW(), 0)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otp);
            ps.setString(3, validType);
            ps.setInt(4, expiryMinutes);
            
            int result = ps.executeUpdate();
            System.out.println("✅ OTP saved - userId: " + userId + ", type: " + validType);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("❌ saveOTP error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Xác thực OTP
    public boolean validateOTP(int userId, String otp, String type) {
        String validType = validateType(type);
        
        String sql = "SELECT id FROM otp_codes WHERE user_id = ? AND otp_code = ? AND type = ? AND is_used = 0 AND expired_at > NOW()";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otp);
            ps.setString(3, validType);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int otpId = rs.getInt("id");
                markOTPAsUsed(otpId);
                System.out.println("✅ OTP validated - userId: " + userId);
                return true;
            }
            System.out.println("❌ OTP invalid - userId: " + userId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đánh dấu OTP đã dùng
    private void markOTPAsUsed(int otpId) {
        String sql = "UPDATE otp_codes SET is_used = 1 WHERE id = ?";
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
        String validType = validateType(type);
        
        String sql = "DELETE FROM otp_codes WHERE user_id = ? AND type = ? AND (is_used = 1 OR expired_at < NOW())";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, validType);
            int deleted = ps.executeUpdate();
            System.out.println("✅ Deleted " + deleted + " old OTPs for userId: " + userId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Xóa tất cả OTP đã hết hạn (chạy định kỳ)
    public void cleanExpiredOTP() {
        String sql = "DELETE FROM otp_codes WHERE expired_at < NOW()";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int deleted = ps.executeUpdate();
            System.out.println("✅ Cleaned " + deleted + " expired OTPs");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Kiểm tra OTP có tồn tại và còn hiệu lực không
    public boolean isOTPExists(int userId, String type) {
        String validType = validateType(type);
        
        String sql = "SELECT id FROM otp_codes WHERE user_id = ? AND type = ? AND is_used = 0 AND expired_at > NOW()";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, validType);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy OTP code mới nhất của user
    public String getLatestOTP(int userId, String type) {
        String validType = validateType(type);
        
        String sql = "SELECT otp_code FROM otp_codes WHERE user_id = ? AND type = ? AND is_used = 0 AND expired_at > NOW() ORDER BY created_at DESC LIMIT 1";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, validType);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("otp_code");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}