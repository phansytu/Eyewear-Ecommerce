package servlet;

import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.UserDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy thống kê số lượng đơn hàng theo trạng thái
        int[] orderStats = orderDAO.getOrderStatistics();
        int pendingOrders = orderStats[0];
        int confirmedOrders = orderStats[1];
        int shippingOrders = orderStats[2];
        int deliveredOrders = orderStats[3];
        int cancelledOrders = orderStats[4];
        
        // Tổng số đơn hàng
        int totalOrders = pendingOrders + confirmedOrders + shippingOrders + deliveredOrders + cancelledOrders;
        
        // Tổng doanh thu (từ đơn hàng đã giao và đã thanh toán)
        double totalRevenue = orderDAO.getTotalRevenue();
        
        // Tổng số sản phẩm
        int totalProducts = productDAO.getTotalProducts();
        
        // Tổng số người dùng
        int totalUsers = userDAO.getTotalUsers();
        
        // Lấy danh sách đơn hàng gần đây (10 đơn gần nhất)
        List<Order> recentOrders = orderDAO.getRecentOrders(10);
        
        // Lấy top sản phẩm bán chạy
        List<Object[]> topProducts = orderDAO.getTopSellingProducts(5);
        
        // Lấy doanh thu theo tháng (6 tháng gần nhất)
        List<Object[]> monthlyRevenue = orderDAO.getMonthlyRevenue(6);
        
        // Set attributes
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("confirmedOrders", confirmedOrders);
        request.setAttribute("shippingOrders", shippingOrders);
        request.setAttribute("deliveredOrders", deliveredOrders);
        request.setAttribute("cancelledOrders", cancelledOrders);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        
        // Forward to JSP
        request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
    }
}