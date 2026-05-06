package servlet;

import DAO.OrderDAO;
import model.Order;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    
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
        
        String type = request.getParameter("type");
        if (type == null) type = "all";
        
        List<Order> orders;
        
        switch (type) {
            case "wait_pay":
                orders = orderDAO.getOrdersByUserIdAndStatus(user.getId(), "pending");
                break;
            case "confirmed":
                orders = orderDAO.getOrdersByUserIdAndStatus(user.getId(), "confirmed");
                break;
            case "shipping":
                orders = orderDAO.getOrdersByUserIdAndStatus(user.getId(), "shipping");
                break;
            case "delivering":
                orders = orderDAO.getOrdersByUserIdAndStatus(user.getId(), "delivering");
                break;
            case "completed":
                orders = orderDAO.getOrdersByUserIdAndStatus(user.getId(), "delivered");
                break;
            case "cancelled":
                orders = orderDAO.getOrdersByUserIdAndStatus(user.getId(), "cancelled");
                break;
            default:
                orders = orderDAO.getOrdersByUserId(user.getId());
                break;
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("activeTab", type);
        
        request.getRequestDispatcher("/jsp/orders.jsp").forward(request, response);
    }
}