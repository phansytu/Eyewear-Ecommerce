package servlet;

import DAO.OrderDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId != null) {
            request.setAttribute("orderId", orderId);
            request.getRequestDispatcher("/jsp/payment.jsp").forward(request, response);
        } else {
            response.sendRedirect("orders");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        Map<String, Object> result = new HashMap<>();
        
        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        
        if ("pay".equals(action)) {
            boolean success = orderDAO.updatePaymentStatus(orderId, "paid");
            result.put("success", success);
            result.put("message", success ? "Thanh toán thành công!" : "Thanh toán thất bại!");
        }
        
        response.getWriter().write(new Gson().toJson(result));
    }
}