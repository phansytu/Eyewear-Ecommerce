package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    public static Connection getConnection() {
        // 1. Lấy biến từ Railway (Nếu chạy local các biến này sẽ null)
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String dbName = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String pass = System.getenv("MYSQLPASSWORD");

        String url = "";

        if (host != null) {
            // ĐANG CHẠY TRÊN RAILWAY: Ghép chuỗi JDBC chuẩn
            url = "jdbc:mysql://" + host + ":" + port + "/" + dbName 
                + "?useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true";
        } else {
            // ĐANG CHẠY LOCAL: Thay thông số máy bạn vào đây
            url = "jdbc:mysql://localhost:3306/ten_db_cua_ban?useUnicode=true&characterEncoding=UTF-8";
            user = "root";
            pass = "mat_khau_local";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("❌ Kết nối thất bại: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}