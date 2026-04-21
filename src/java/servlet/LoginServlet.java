package servlet;

import DAO.UserDAO;
import model.User;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                // Đã đồng nhất path admin
                response.sendRedirect(request.getContextPath() + "/jsp/admin/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // SỬA: Thêm UTF-8 để nhận và trả JSON tiếng Việt không bị lỗi font (???)
        request.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String ipAddress = request.getRemoteAddr();
        
        // Kiểm tra xem có phải AJAX request không
        String ajaxHeader = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(ajaxHeader);
        
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            if (isAjax) {
                // SỬA: Đảm bảo Response JSON có mã hóa UTF-8
                response.setContentType("application/json; charset=UTF-8"); 
                Map<String, Object> jsonResponse = new HashMap<>();
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
            } else {
                request.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            return;
        }
        
        User user = userDAO.authenticate(username, password, ipAddress);
        
        if (user != null) {
            // Đăng nhập thành công
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60);
            
            if (isAjax) {
                response.setContentType("application/json; charset=UTF-8");
                Map<String, Object> jsonResponse = new HashMap<>();
                jsonResponse.put("success", true);
                jsonResponse.put("role", user.getRole());
                
                // SỬA: Đồng nhất đường dẫn chuyển hướng Admin
                // Ép tất cả đều về trang chủ
jsonResponse.put("redirect", request.getContextPath() + "/home");
                
                response.getWriter().write(new Gson().toJson(jsonResponse));
            } else {
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/jsp/admin/dashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            }
        } else {
            User lockedUser = userDAO.getUserByUsername(username);
            
            if (isAjax) {
                response.setContentType("application/json; charset=UTF-8");
                Map<String, Object> jsonResponse = new HashMap<>();
                jsonResponse.put("success", false);
                
                if (lockedUser != null && lockedUser.isLocked()) {
                    jsonResponse.put("locked", true);
                    jsonResponse.put("message", "Tài khoản đã bị khóa do đăng nhập sai quá 5 lần. Vui lòng nhập email để nhận OTP mở khóa.");
                } else {
                    jsonResponse.put("message", "Tên đăng nhập hoặc mật khẩu không đúng!");
                }
                response.getWriter().write(new Gson().toJson(jsonResponse));
            } else {
                if (lockedUser != null && lockedUser.isLocked()) {
                    request.setAttribute("error", "Tài khoản đã bị khóa do đăng nhập sai quá 5 lần!");
                    request.setAttribute("showUnlockModal", true);
                } else {
                    request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                }
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }
    }
}