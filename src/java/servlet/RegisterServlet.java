/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import java.io.PrintWriter;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$");
    
 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        
        response.setContentType("application/json");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        // Validate
        if (username == null || username.trim().length() < 3) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Tên đăng nhập phải có ít nhất 3 ký tự!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (userDAO.isUsernameExists(username)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Tên đăng nhập đã tồn tại!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Xác nhận mật khẩu không khớp!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Email không hợp lệ!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        if (userDAO.isEmailExists(email)) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Email đã được đăng ký!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setEmail(email);
        newUser.setFull_name(fullname);
        newUser.setRole("user");
        
        if (userDAO.register(newUser)) {
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đăng ký thành công! Vui lòng đăng nhập.");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đăng ký thất bại, vui lòng thử lại!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
