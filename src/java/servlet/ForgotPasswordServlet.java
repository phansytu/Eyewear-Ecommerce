package servlet;

import DAO.OTPDao;
import DAO.UserDAO;
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
import model.User;
import util.EmailUtil;
import util.OTPUtil;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private OTPDao otpDAO = new OTPDao();
    private static final int OTP_EXPIRY_MINUTES = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        // 1. Validate input
        if (username == null || username.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Vui lòng nhập tên đăng nhập!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Vui lòng nhập email!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // 2. Kiểm tra username
        User user = userDAO.getUserByUsername(username.trim());
        if (user == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Tên đăng nhập không tồn tại!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // 3. Kiểm tra email khớp
        if (!user.getEmail().equalsIgnoreCase(email.trim())) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Email không khớp với tài khoản!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // 4. Kiểm tra tài khoản khóa
        if (user.isLocked()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Tài khoản đang bị khóa, vui lòng thử lại sau!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // 5. Xóa OTP cũ
        otpDAO.deleteOldOTP(user.getId(), "reset");
        
        // 6. Tạo OTP mới
        String otp = OTPUtil.generateOTP(6);
        
        // 7. Lưu OTP vào DB
        if (!otpDAO.saveOTP(user.getId(), otp, "reset", OTP_EXPIRY_MINUTES)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi hệ thống, vui lòng thử lại!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // 8. Gửi email
        String displayName = user.getFull_name() != null && !user.getFull_name().isEmpty() 
                ? user.getFull_name() : username;
        String emailBody = EmailUtil.getOtpEmailBody(displayName, otp, OTP_EXPIRY_MINUTES);
        
        if (EmailUtil.sendEmail(email, "Mã OTP đặt lại mật khẩu", emailBody)) {
            HttpSession session = request.getSession();
            session.setAttribute("resetUserId", user.getId());
            session.setAttribute("resetEmail", email);
            session.setMaxInactiveInterval(10 * 60); // 10 phút
            
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Mã OTP đã được gửi đến email " + maskEmail(email));
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Gửi email thất bại, vui lòng thử lại sau!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
    
    private String maskEmail(String email) {
        int atIndex = email.indexOf('@');
        if (atIndex <= 2) return email;
        String name = email.substring(0, atIndex);
        String domain = email.substring(atIndex);
        return name.charAt(0) + "***" + name.charAt(name.length() - 1) + domain;
    }
}