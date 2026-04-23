package servlet;

import DAO.OTPDao;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import util.EmailUtil;
import util.OTPUtil;

@WebServlet("/resend-otp")
public class ResendOTPServlet extends HttpServlet {
    private OTPDao otpDAO = new OTPDao();
    private static final int OTP_EXPIRY_MINUTES = 5;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        String email = (String) session.getAttribute("resetEmail");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        if (userId == null || email == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Phiên làm việc đã hết hạn!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // Xóa OTP cũ
        otpDAO.deleteOldOTP(userId, "reset");
        
        // Tạo OTP mới
        String otp = OTPUtil.generateOTP(6);
        
        // Lưu OTP
        if (!otpDAO.saveOTP(userId, otp, "reset", OTP_EXPIRY_MINUTES)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi hệ thống, vui lòng thử lại!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // Gửi email
        String emailBody = EmailUtil.getOtpEmailBody("Người dùng", otp, OTP_EXPIRY_MINUTES);
        
        if (EmailUtil.sendEmail(email, "Mã OTP đặt lại mật khẩu", emailBody)) {
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Mã OTP mới đã được gửi!");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Gửi email thất bại!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}