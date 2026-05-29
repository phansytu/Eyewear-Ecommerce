package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    // Lấy thông tin từ Railway Environment Variables
    private static final String HOST = System.getenv("MYSQLHOST");
    private static final String PORT = System.getenv("MYSQLPORT");
    private static final String DATABASE = System.getenv("MYSQLDATABASE");
    private static final String USER = System.getenv("MYSQLUSER");
    private static final String PASSWORD = System.getenv("MYSQLPASSWORD");

    // JDBC URL
    private static final String URL =
            "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE
            + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    public static Connection getConnection() {
        try {
            // Load MySQL Driver
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