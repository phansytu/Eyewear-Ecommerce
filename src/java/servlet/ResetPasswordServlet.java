package servlet;

import DAO.UserDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final Pattern PASSWORD_PATTERN = 
            Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        
        if (userId == null || otpVerified == null || !otpVerified) {
            response.sendRedirect("forgot-password");
            return;
        }
        
        request.getRequestDispatcher("/resetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        // Kiểm tra quyền truy cập
        if (userId == null || otpVerified == null || !otpVerified) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Phiên làm việc đã hết hạn!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate mật khẩu
        if (newPassword == null || !PASSWORD_PATTERN.matcher(newPassword).matches()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Xác nhận mật khẩu không khớp!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // Cập nhật mật khẩu
        if (userDAO.updatePassword(userId, newPassword)) {
            // Xóa session
            session.removeAttribute("resetUserId");
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpVerified");
            
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đặt lại mật khẩu thành công! Đang chuyển đến trang đăng nhập...");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}