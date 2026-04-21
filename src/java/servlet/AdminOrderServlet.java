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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        OrderDAO orderDAO = new OrderDAO();
        
        // Lấy toàn bộ đơn hàng từ DB
        List<Order> listOrders = orderDAO.getAllOrders();
        
        // Đẩy sang file JSP
        request.setAttribute("listOrders", listOrders);
        
        // Chuyển hướng tới file JSP (nhớ thay đổi đường dẫn phù hợp với project của bạn)
        request.getRequestDispatcher("/jsp/admin/order.jsp").forward(request, response);
    }
}