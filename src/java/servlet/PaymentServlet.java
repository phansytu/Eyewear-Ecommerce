package servlet;

import DAO.OrderDAO;
import com.google.gson.Gson;
import vn.payos.PayOS;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkRequest;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkResponse;
import vn.payos.model.v2.paymentRequests.PaymentLinkItem;
import config.PayOSConfig;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetail;
import model.User;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderId = request.getParameter("orderId");
        String method = request.getParameter("method");
        
        if (orderId != null) {
            request.setAttribute("orderId", orderId);
            
            // Nếu chọn thanh toán qua PayOS, xử lý ngay
            if ("payos".equals(method)) {
                handlePayOSPayment(request, response, Integer.parseInt(orderId));
                return;
            }
            
            request.getRequestDispatcher("/jsp/payment.jsp").forward(request, response);
        } else {
            response.sendRedirect("orders");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        String action = request.getParameter("action");
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            
            // Thanh toán COD (giữ nguyên chức năng cũ)
            if ("pay".equals(action)) {
                boolean success = orderDAO.updatePaymentStatus(orderId, "paid", null);
                if (success) {
                    orderDAO.updateOrderStatus(orderId, "confirmed");
                }
                result.put("success", success);
                result.put("message", success ? "Thanh toán thành công!" : "Thanh toán thất bại!");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            // Tạo link thanh toán PayOS (API gọi từ AJAX)
            if ("createPayOSLink".equals(action)) {
                handleCreatePayOSLink(request, response, orderId);
                return;
            }
            
            result.put("success", false);
            result.put("message", "Hành động không hợp lệ!");
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Order ID không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    /**
     * Xử lý thanh toán qua PayOS - Chuyển hướng đến PayOS
     */
    private void handlePayOSPayment(HttpServletRequest request, HttpServletResponse response, int orderId)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Order order = orderDAO.getOrderById(orderId);
        
        if (order == null || order.getUserId() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        try {
            PayOS payOS = PayOSConfig.getPayOS();
            
            // Tạo danh sách sản phẩm
            List<PaymentLinkItem> items = new ArrayList<>();
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
            
                for (OrderDetail detail : details) {
                    PaymentLinkItem item = new PaymentLinkItem();
                    item.setName(detail.getProductName());
                    item.setQuantity(detail.getQuantity());
                    item.setPrice((long)detail.getPrice());
                    items.add(item);
                }
            
            // Tạo mã đơn hàng duy nhất
            long orderCode = System.currentTimeMillis() % 1000000;
            
            // Tạo dữ liệu thanh toán
            CreatePaymentLinkRequest paymentRequest = CreatePaymentLinkRequest.builder()
                .orderCode(orderCode)
                .amount((long) order.getTotalAmount())
                .description("Thanh toan don hang #" + orderId)
                .items(items)
                .returnUrl(request.getContextPath() + "/payment-success?orderId=" + orderId)
                .cancelUrl(request.getContextPath() + "/payment-cancel?orderId=" + orderId)
                .build();
            
            // Tạo link thanh toán
          CreatePaymentLinkResponse checkout = payOS.paymentRequests().create(paymentRequest);
            // Lưu paymentLinkId vào database
            orderDAO.updatePaymentLinkId(orderId, checkout.getPaymentLinkId());
            
            // Chuyển hướng đến trang thanh toán PayOS
            response.sendRedirect(checkout.getCheckoutUrl());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/payment-error?orderId=" + orderId);
        }
    }
    
    /**
     * Tạo link thanh toán PayOS và trả về JSON (cho AJAX)
     */
    private void handleCreatePayOSLink(HttpServletRequest request, HttpServletResponse response, int orderId)
            throws ServletException, IOException {
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (user == null) {
                result.put("success", false);
                result.put("message", "Vui lòng đăng nhập!");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null || order.getUserId() != user.getId()) {
                result.put("success", false);
                result.put("message", "Đơn hàng không tồn tại!");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            PayOS payOS = PayOSConfig.getPayOS();
            
            // Tạo danh sách sản phẩm
            List<PaymentLinkItem> items = new ArrayList<>();
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
            
            for (OrderDetail detail : details) {
                PaymentLinkItem item = new PaymentLinkItem();
                item.setName(detail.getProductName());
                item.setQuantity(detail.getQuantity());
                item.setPrice((long)detail.getPrice());
                items.add(item);
            }
            
            // Tạo mã đơn hàng duy nhất
            long orderCode = System.currentTimeMillis() % 1000000;
            
            // Tạo dữ liệu thanh toán
            CreatePaymentLinkRequest paymentRequest = CreatePaymentLinkRequest.builder()
                .orderCode(orderCode)
                .amount((long) order.getTotalAmount())
                .description("Thanh toan don hang #" + orderId)
                .items(items)
                .returnUrl(request.getContextPath() + "/payment-success?orderId=" + orderId)
                .cancelUrl(request.getContextPath() + "/payment-cancel?orderId=" + orderId)
                .build();
            
            // Tạo link thanh toán
       CreatePaymentLinkResponse checkout = payOS.paymentRequests().create(paymentRequest);
            
            // Lưu paymentLinkId vào database
            orderDAO.updatePaymentLinkId(orderId, checkout.getPaymentLinkId());
            
            result.put("success", true);
            result.put("checkoutUrl", checkout.getCheckoutUrl());
            result.put("paymentLinkId", checkout.getPaymentLinkId());
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi tạo link thanh toán: " + e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(result));
    }
}