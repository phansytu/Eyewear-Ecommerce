package servlet;

import DAO.ContactDAO;
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

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private ContactDAO contactDAO = new ContactDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        request.setAttribute("orderId", orderId);
        request.getRequestDispatcher("/jsp/contact.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        
        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            String orderId = request.getParameter("orderId");
            
            if (message == null || message.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập nội dung!");
                response.getWriter().write(new Gson().toJson(result));
                return;
            }
            
            boolean saved = contactDAO.saveContact(name, email, phone, subject, message, orderId);
            result.put("success", saved);
            result.put("message", saved ? "Gửi yêu cầu thành công! Chúng tôi sẽ liên hệ lại sớm." : "Gửi thất bại!");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }
        
        response.getWriter().write(new Gson().toJson(result));
    }
}