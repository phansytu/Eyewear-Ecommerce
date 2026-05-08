package servlet;

import DAO.CartDAO;
import DAO.OrderDAO;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderDetail;
import model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        Cart cart = cartDAO.getCartByUserId(user.getId());
        
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        request.setAttribute("cart", cart);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        if (user == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Vui lòng đăng nhập!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        Cart cart = cartDAO.getCartByUserId(user.getId());
        if (cart == null || cart.getItems().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Giỏ hàng trống!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        try {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String note = request.getParameter("note");
            String paymentMethod = request.getParameter("paymentMethod");
            
            if (fullName == null || fullName.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng nhập họ tên!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng nhập số điện thoại!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            if (address == null || address.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng nhập địa chỉ!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            Order newOrder = new Order();
            newOrder.setUserId(user.getId());
            newOrder.setTotalAmount(cart.getTotalPrice());
            newOrder.setAddress(address);
            newOrder.setPhone(phone);
            newOrder.setPaymentStatus("unpaid");
            
            List<OrderDetail> details = new ArrayList<>();
            for (CartItem item : cart.getItems()) {
                OrderDetail detail = new OrderDetail();
                detail.setProductId(item.getProductId());
                detail.setVariantId(item.getVariantId());
                detail.setQuantity(item.getQuantity());
                detail.setPrice(item.getPrice());
                details.add(detail);
            }
            
            int orderId = orderDAO.placeOrder(newOrder, details);
            
            if (orderId > 0) {
                cartDAO.clearCart(user.getId());
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đặt hàng thành công!");
                jsonResponse.put("orderId", orderId);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Lỗi lưu đơn hàng!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi: " + e.getMessage());
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}