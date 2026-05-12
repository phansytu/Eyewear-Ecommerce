package DAO;

import util.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ContactDAO {
    
    public boolean saveContact(String name, String email, String phone, 
                               String subject, String message, String orderId) {
        String sql = "INSERT INTO contacts (name, email, phone, subject, message, order_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, subject);
            ps.setString(5, message);
            if (orderId != null && !orderId.isEmpty()) {
                ps.setString(6, orderId);
            } else {
                ps.setNull(6, java.sql.Types.VARCHAR);
            }
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}