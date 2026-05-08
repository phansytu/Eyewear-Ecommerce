package servlet;

import DAO.OrderDAO;
import DAO.UserDAO;
import model.Order;
import model.User;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import com.google.gson.Gson;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Lấy user mới nhất từ DB
        User freshUser = userDAO.getUserById(user.getId());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
        }
        
        String activeTab = request.getParameter("tab");
        if (activeTab == null) activeTab = "profile";
        
        // Lấy danh sách đơn hàng của user
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        request.setAttribute("orders", orders);
        
        request.setAttribute("activeTab", activeTab);
       request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        String activeTab = request.getParameter("tab") != null ? request.getParameter("tab") : "profile";
        
        // Kiểm tra nếu là AJAX upload avatar
        String contentType = request.getContentType();
        boolean isMultipart = contentType != null && contentType.startsWith("multipart/form-data");
        
        if (isMultipart && action != null && action.equals("updateAvatar")) {
            handleAvatarUpload(request, response, user);
            return;
        }
        
        if ("updateProfile".equals(action)) {
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String fullName = request.getParameter("fullName");
            String gender = request.getParameter("gender");
            String dob = request.getParameter("dob");
            
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setFull_name(fullName);
            user.setGender(gender);
            user.setDob(dob);
            
            boolean updated = userDAO.updateUserProfile(user);
            
            if (updated) {
                session.setAttribute("user", user);
                session.setAttribute("success", "Cập nhật hồ sơ thành công!");
            } else {
                session.setAttribute("error", "Cập nhật hồ sơ thất bại!");
            }
            activeTab = "profile";
            
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "Mật khẩu mới không khớp!");
            } else if (!userDAO.checkCurrentPassword(user.getId(), currentPassword)) {
                session.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            } else if (newPassword.length() < 6) {
                session.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            } else {
                boolean changed = userDAO.changePassword(user.getId(), newPassword);
                if (changed) {
                    session.setAttribute("success", "Đổi mật khẩu thành công!");
                } else {
                    session.setAttribute("error", "Đổi mật khẩu thất bại!");
                }
            }
            activeTab = "security";
            
        } else if ("cancelOrder".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            boolean cancelled = orderDAO.cancelOrder(orderId);
            
            response.setContentType("application/json; charset=UTF-8");
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", cancelled);
            jsonResponse.put("message", cancelled ? "Hủy đơn hàng thành công!" : "Hủy đơn hàng thất bại!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/profile?tab=" + activeTab);
    }
    
    private void handleAvatarUpload(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        Map<String, Object> jsonResponse = new HashMap<>();
        
        try {
            Part filePart = request.getPart("avatar");
            if (filePart == null || filePart.getSize() == 0) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng chọn ảnh!");
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "avatars";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            String fileName = UUID.randomUUID().toString() + "_" + System.currentTimeMillis() + ".jpg";
            String filePath = uploadPath + File.separator + fileName;
            
            filePart.write(filePath);
            
            String avatarUrl = request.getContextPath() + "/uploads/avatars/" + fileName;
            
            boolean updated = userDAO.updateAvatar(user.getId(), avatarUrl);
            
            if (updated) {
                user.setAvatar(avatarUrl);
                request.getSession().setAttribute("user", user);
                jsonResponse.put("success", true);
                jsonResponse.put("avatarUrl", avatarUrl);
                jsonResponse.put("message", "Cập nhật ảnh đại diện thành công!");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Cập nhật ảnh thất bại!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi khi upload ảnh: " + e.getMessage());
        }
        
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}