package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    private static String getUrl() {
        String rawUrl = System.getenv("MYSQL_URL");
        // Railway cung cấp mysql://, JDBC cần jdbc:mysql://
        if (rawUrl != null && rawUrl.startsWith("mysql://")) {
            return rawUrl.replace("mysql://", "jdbc:mysql://");
        }
        // Fallback cho local (nếu bạn không set biến môi trường ở máy)
        return "jdbc:mysql://localhost:3306/ten_db_cua_ban";
    }

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Khi dùng URL đầy đủ từ Railway, không cần truyền User/Pass riêng
            return DriverManager.getConnection(getUrl());
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Lỗi kết nối DB: " + e.getMessage());
        }
    }
}