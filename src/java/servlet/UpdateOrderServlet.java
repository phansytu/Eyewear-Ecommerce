package servlet;

import DAO.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/update-order")
public class UpdateOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String action = request.getParameter("action");
        String nextStatus = "";

        // Quyết định trạng thái tiếp theo dựa trên nút bấm
        switch (action) {
            case "confirm": nextStatus = "confirmed"; break;
            case "ship": nextStatus = "shipping"; break;
            case "complete": nextStatus = "delivered"; break;
            case "cancel": nextStatus = "cancelled"; break;
        }

        OrderDAO dao = new OrderDAO();
        if (dao.updateOrderStatus(orderId, nextStatus)) {
            response.sendRedirect("orders?status=updated");
        } else {
            response.sendRedirect("orders?error=failed");
        }
    }
}