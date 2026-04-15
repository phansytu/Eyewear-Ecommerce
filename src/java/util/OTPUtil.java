package util;

import java.security.SecureRandom;

public class OTPUtil {
    private static final SecureRandom secureRandom = new SecureRandom();
    
    // Tạo OTP 6 số
    public static String generateOTP() {
        int otp = 100000 + secureRandom.nextInt(900000);
        return String.valueOf(otp);
    }
    
    // Tạo token ngẫu nhiên
    public static String generateToken() {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}