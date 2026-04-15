package servlet;

import DAO.UserDAO;
import model.User;
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

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$");
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        response.setContentType("application/json");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        // Validate token
        User user = userDAO.validateResetToken(token);
        if (user == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // Validate password
        if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
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
        
        if (userDAO.updatePassword(user.getId(), newPassword)) {
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đặt lại mật khẩu thất bại, vui lòng thử lại!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}