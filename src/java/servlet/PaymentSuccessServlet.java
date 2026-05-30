// servlet/PaymentSuccessServlet.java
package servlet;

import DAO.OrderDAO;
import model.Order;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/payment-success")
public class PaymentSuccessServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam != null) {
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderDAO.getOrderById(orderId);
            request.setAttribute("order", order);
        }
        
        request.getRequestDispatcher("/jsp/payment-success.jsp").forward(request, response);
    }
}