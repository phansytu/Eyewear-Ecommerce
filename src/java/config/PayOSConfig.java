// config/PayOSConfig.java
package config;

import vn.payos.PayOS;

public class PayOSConfig {
    private static PayOS payOS;
    
    static {
        try {
            // Ưu tiên đọc từ biến môi trường (Railway)
            String clientId = System.getenv("PAYOS_CLIENT_ID");
            String apiKey = System.getenv("PAYOS_API_KEY");
            String checksumKey = System.getenv("PAYOS_CHECKSUM_KEY");
            
            // Fallback: đọc từ file properties (chỉ dùng cho local development)
            if (clientId == null || apiKey == null || checksumKey == null) {
                java.util.Properties prop = new java.util.Properties();
                try (java.io.InputStream input = PayOSConfig.class.getClassLoader()
                        .getResourceAsStream("payos.properties")) {
                    if (input != null) {
                        prop.load(input);
                        clientId = prop.getProperty("PAYOS_CLIENT_ID");
                        apiKey = prop.getProperty("PAYOS_API_KEY");
                        checksumKey = prop.getProperty("PAYOS_CHECKSUM_KEY");
                    }
                }
            }
            
            if (clientId != null && apiKey != null && checksumKey != null) {
                payOS = new PayOS(clientId, apiKey, checksumKey);
                System.out.println("✅ PayOS initialized successfully");
            } else {
                System.err.println("❌ PayOS credentials not found!");
            }
            
        } catch (Exception e) {
            System.err.println("❌ PayOS init failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public static PayOS getPayOS() {
        return payOS;
    }
}