package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderId = request.getParameter("orderId");
        
        if (orderId == null || orderId.isEmpty()) {
            response.sendRedirect("home");
            return;
        }
        
        request.setAttribute("orderId", orderId);
        // ✅ Forward đến đúng vị trí file
        request.getRequestDispatcher("/jsp/order-confirmation.jsp").forward(request, response);
    }
}