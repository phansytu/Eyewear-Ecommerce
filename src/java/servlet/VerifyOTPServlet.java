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

@WebServlet(name = "VerifyOTPServlet", urlPatterns = {"/verify-otp"})
public class VerifyOTPServlet extends HttpServlet {
    private OTPDao otpDAO = new OTPDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        
        if (userId == null) {
            response.sendRedirect("forgot-password");
            return;
        }
        
        String email = (String) session.getAttribute("resetEmail");
        request.setAttribute("maskedEmail", maskEmail(email));
        request.getRequestDispatcher("/jsp/verifyotp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        if (userId == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Phiên làm việc đã hết hạn!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        String otp = request.getParameter("otp");
        
        if (otp == null || otp.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Vui lòng nhập mã OTP!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (otpDAO.validateOTP(userId, otp.trim(), "reset")) {
            session.setAttribute("otpVerified", true);
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Xác thực thành công!");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã OTP không đúng hoặc đã hết hạn!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
    
    private String maskEmail(String email) {
        if (email == null) return "";
        int atIndex = email.indexOf('@');
        if (atIndex <= 2) return email;
        String name = email.substring(0, atIndex);
        String domain = email.substring(atIndex);
        return name.charAt(0) + "***" + name.charAt(name.length() - 1) + domain;
    }
}