package servlet;

import DAO.UserDAO;
import model.User;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=admin_required");
            return;
        }
        
        String action = request.getParameter("action");
        
        // Xử lý AJAX lấy chi tiết user
        if ("get".equals(action)) {
            handleGetUserJson(request, response);
            return;
        }
        
        // Lấy tham số lọc
        String search = request.getParameter("search");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        
        List<User> users;
        
        if (search != null && !search.trim().isEmpty()) {
            users = userDAO.searchUsers(search);
            request.setAttribute("searchValue", search);
        } else if (role != null && !role.isEmpty()) {
            users = userDAO.getUsersByRole(role);
            request.setAttribute("currentRole", role);
        } else if (status != null && !status.isEmpty()) {
            users = userDAO.getUsersByStatus(status);
            request.setAttribute("currentStatus", status);
        } else {
            users = userDAO.getAllUsersWithStats();
        }
        
        // Thống kê
        int totalUsers = userDAO.getTotalUsers();
        int activeUsers = userDAO.getActiveUsersCount();
        int lockedUsers = userDAO.getLockedUsersCount();
        int adminUsers = userDAO.getAdminUsersCount();
        int vipUsers = userDAO.getVipUsersCount();
        
        request.setAttribute("users", users);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("lockedUsers", lockedUsers);
        request.setAttribute("adminUsers", adminUsers);
        request.setAttribute("vipUsers", vipUsers);
        
        request.getRequestDispatcher("/jsp/admin/user.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=admin_required");
            return;
        }
        
        String action = request.getParameter("action");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            if ("lock".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean success = userDAO.lockUser(userId);
                response.getWriter().write("{\"success\": " + success + "}");
                
            } else if ("unlock".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean success = userDAO.unlockUser(userId);
                response.getWriter().write("{\"success\": " + success + "}");
                
            } else if ("changeRole".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String newRole = request.getParameter("newRole");
                boolean success = userDAO.changeUserRole(userId, newRole);
                response.getWriter().write("{\"success\": " + success + "}");
                
            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean success = userDAO.deleteUser(userId);
                response.getWriter().write("{\"success\": " + success + "}");
                
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không xác định được hành động\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void handleGetUserJson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu ID người dùng\"}");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            User user = userDAO.getUserWithStats(id);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            Map<String, Object> jsonResponse = new HashMap<>();
            if (user != null) {
                jsonResponse.put("success", true);
                jsonResponse.put("user", user);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không tìm thấy người dùng");
            }
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID không hợp lệ\"}");
        }
    }
}