package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    public static Connection getConnection() {
        // 1. Lấy tất cả biến môi trường từ Railway
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String dbName = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String pass = System.getenv("MYSQLPASSWORD");

        // 2. Dòng in ra Log để kiểm tra trạng thái biến (Cực kỳ quan trọng)
        System.out.println("======= DEBUG DATABASE CONNECTION =======");
        System.out.println("Target Host: " + (host != null ? host : "NULL (Đang chạy Local)"));
        System.out.println("Target Port: " + (port != null ? port : "NULL"));
        System.out.println("DB Name: " + (dbName != null ? dbName : "NULL"));
        System.out.println("User: " + (user != null ? user : "NULL"));
        System.out.println("=========================================");

        String url;
        if (host != null && !host.isEmpty()) {
            // CẤU HÌNH CHO RAILWAY: Sử dụng các biến từ môi trường
            // Thêm tham số timezone và SSL để tránh lỗi link failure
            url = String.format("jdbc:mysql://%s:%s/%s?useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", 
                                host, port, dbName);
        } else {
            // CẤU HÌNH CHO LOCAL: Khi host null
            url = "jdbc:mysql://localhost:3306/ten_db_local?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
            user = "root";
            pass = "mat_khau_cua_ban"; 
        }

        try {
            // Nạp Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Thực hiện kết nối
            Connection conn = DriverManager.getConnection(url, user, pass);
            System.out.println("✅ KẾT NỐI DATABASE THÀNH CÔNG!");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("❌ LỖI: Không tìm thấy Driver MySQL (Kiểm tra file .jar trong WEB-INF/lib)");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ LỖI KẾT NỐI: Kiểm tra lại Variables trên Railway hoặc trạng thái Database");
            System.err.println("Chi tiết lỗi: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}