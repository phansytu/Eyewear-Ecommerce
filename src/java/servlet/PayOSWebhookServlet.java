// servlet/PayOSWebhookServlet.java
package servlet;

import DAO.OrderDAO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import vn.payos.PayOS;
import vn.payos.model.webhooks.WebhookData;
import config.PayOSConfig;

import java.io.BufferedReader;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/webhook/payos")
public class PayOSWebhookServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Đọc dữ liệu webhook
            StringBuilder sb = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            String body = sb.toString();
            System.out.println("📨 Webhook received: " + body);
            
            // Parse dữ liệu webhook
            JsonObject jsonObject = JsonParser.parseString(body).getAsJsonObject();
            String code = jsonObject.get("code").getAsString();
            
            // Lấy data từ response
            JsonObject dataObject = jsonObject.getAsJsonObject("data");
            if (dataObject == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"No data field\"}");
                return;
            }
            
            String paymentLinkId = dataObject.get("paymentLinkId").getAsString();
            String orderCode = dataObject.get("orderCode").getAsString();
            
            // Xác minh chữ ký webhook (nếu có)
            PayOS payOS = PayOSConfig.getPayOS();
            
            // Kiểm tra mã thanh toán thành công
            if ("00".equals(code)) {
                // Tìm đơn hàng theo paymentLinkId
                int orderId = orderDAO.getOrderIdByPaymentLinkId(paymentLinkId);
                
                if (orderId > 0) {
                    // Cập nhật trạng thái thanh toán
                    String transactionId = dataObject.has("transactionNo") ? 
                        dataObject.get("transactionNo").getAsString() : orderCode;
                    
                    boolean updated = orderDAO.updatePaymentStatus(orderId, "paid", transactionId);
                    
                    if (updated) {
                        orderDAO.updateOrderStatus(orderId, "confirmed");
                        System.out.println("✅ Order #" + orderId + " paid successfully via PayOS");
                    } else {
                        System.err.println("❌ Failed to update order #" + orderId);
                    }
                } else {
                    System.err.println("❌ Order not found for paymentLinkId: " + paymentLinkId);
                }
            } else {
                System.out.println("⚠️ Payment failed with code: " + code);
            }
            
            // Trả về response cho PayOS
            response.getWriter().write("{\"success\": true}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}