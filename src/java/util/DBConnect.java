package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    // ✅ THAY ĐỔI THEO MYSQL CỦA BẠN
    private static final String URL = "jdbc:mysql://localhost:3306/eyewear_shop?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";        // Username MySQL
    private static final String PASSWORD = "";  // Password MySQL
    
    public static Connection getConnection() {
        try {
            // Load driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ DB Connection OK!");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver NOT FOUND!");
            throw new RuntimeException(e);
        } catch (SQLException e) {
            System.err.println("❌ DB Connection FAILED: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
}