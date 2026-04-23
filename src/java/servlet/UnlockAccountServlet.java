package servlet;

import DAO.OTPDao;
import DAO.UserDAO;
import model.User;
import util.EmailUtil;
import util.OTPUtil;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/unlock-account")
public class UnlockAccountServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private OTPDao otpDao = new OTPDao();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        if ("send-otp".equals(action)) {
            String email = request.getParameter("email");
            User user = userDAO.getUserByEmail(email);
            
            if (user == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email không tồn tại trong hệ thống!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            if (!user.isLocked()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Tài khoản không bị khóa, bạn có thể đăng nhập bình thường!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // Xóa OTP cũ
            otpDao.deleteOldOTP(user.getId(), "unlock");
            
            // Tạo OTP mới
            String otp = OTPUtil.generateOTP(6);
            if (otpDao.saveOTP(user.getId(), otp, "unlock", 10)) {
                String emailBody = EmailUtil.getOtpEmailBody(user.getUsername(), otp, 10);
                if (EmailUtil.sendEmail(email, "Mã OTP mở khóa tài khoản", emailBody)) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("userId", user.getId());
                    jsonResponse.put("message", "Mã OTP đã được gửi đến email của bạn! Có hiệu lực trong 10 phút.");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Gửi email thất bại, vui lòng thử lại!");
                }
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Có lỗi xảy ra, vui lòng thử lại!");
            }
            
        } else if ("verify-otp".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String otp = request.getParameter("otp");
            
            if (otpDao.validateOTP(userId, otp, "unlock")) {
                if (userDAO.unlockAccount(userId)) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Mở khóa tài khoản thành công! Vui lòng đăng nhập.");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Mở khóa thất bại, vui lòng thử lại!");
                }
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Mã OTP không hợp lệ hoặc đã hết hạn!");
            }
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}