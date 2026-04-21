package servlet;

import DAO.OrderDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String date = request.getParameter("date");
        
        List<Order> listOrders;
        
        if (search != null && !search.trim().isEmpty()) {
            listOrders = orderDAO.searchOrders(search);
            request.setAttribute("searchValue", search);
        } else if (status != null && !status.isEmpty()) {
            listOrders = orderDAO.getOrdersByStatus(status);
            request.setAttribute("currentStatus", status);
        } else if (date != null && !date.isEmpty()) {
            listOrders = orderDAO.getOrdersByDate(date);
            request.setAttribute("currentDate", date);
        } else {
            listOrders = orderDAO.getAllOrders();
        }
        
        // Lấy chi tiết đơn hàng cho từng order
        for (Order order : listOrders) {
            order.setOrderDetails(orderDAO.getOrderDetailsByOrderId(order.getId()));
        }
        
        int[] stats = orderDAO.getOrderStatistics();
        
        request.setAttribute("listOrders", listOrders);
        request.setAttribute("pendingCount", stats[0]);
        request.setAttribute("confirmedCount", stats[1]);
        request.setAttribute("shippingCount", stats[2]);
        request.setAttribute("deliveredCount", stats[3]);
        request.setAttribute("cancelledCount", stats[4]);
        
        request.getRequestDispatcher("/jsp/admin/order.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        
        if ("confirm".equals(action)) {
            orderDAO.updateOrderStatus(orderId, "confirmed");
        } else if ("shipping".equals(action)) {
            orderDAO.updateOrderStatus(orderId, "shipping");
        } else if ("delivered".equals(action)) {
            orderDAO.updateOrderStatus(orderId, "delivered");
            orderDAO.updatePaymentStatus(orderId, "paid");
        } else if ("cancel".equals(action)) {
            orderDAO.cancelOrder(orderId);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}