package servlet;

import DAO.CartDAO;
import model.Cart;
import model.CartItem;
import model.User;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
    private CartDAO cartDAO = new CartDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        String action = request.getParameter("action");
        
        // API lấy số lượng sản phẩm trong giỏ (số dòng, không phải tổng quantity)
        if ("count".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            Map<String, Object> result = new HashMap<>();
            if (user != null) {
                int count = cartDAO.getCartItemCount(user.getId());
                result.put("count", count);
            } else {
                result.put("count", 0);
            }
            response.getWriter().write(gson.toJson(result));
            return;
        }
        
        // API lấy toàn bộ giỏ hàng
        if (user != null) {
            Cart cart = cartDAO.getCartByUserId(user.getId());
            request.setAttribute("cart", cart);
        }
        
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập để thêm vào giỏ hàng!");
            response.getWriter().write(gson.toJson(result));
            return;
        }
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            if ("add".equals(action)) {
                handleAddToCart(request, response, user);
            } else if ("update".equals(action)) {
                handleUpdateQuantity(request, response, user);
            } else if ("remove".equals(action)) {
                handleRemoveItem(request, response, user);
            } else if ("clear".equals(action)) {
                handleClearCart(request, response, user);
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
            response.getWriter().write(gson.toJson(result));
        }
    }
    
    // THÊM SẢN PHẨM MỚI → Cập nhật icon
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String variantIdParam = request.getParameter("variantId");
        Integer variantId = (variantIdParam != null && !variantIdParam.isEmpty()) ? Integer.parseInt(variantIdParam) : null;
        
        boolean success = cartDAO.addToCart(user.getId(), productId, variantId, quantity);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        if (success) {
            // Chỉ trả về count để cập nhật icon (số dòng)
            int itemCount = cartDAO.getCartItemCount(user.getId());
            result.put("count", itemCount);
            result.put("message", "Đã thêm vào giỏ hàng!");
        } else {
            result.put("message", "Thêm vào giỏ hàng thất bại!");
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    // CẬP NHẬT SỐ LƯỢNG → KHÔNG cập nhật icon (chỉ cập nhật tổng tiền)
    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        boolean success = cartDAO.updateQuantity(itemId, quantity);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        // KHÔNG trả về count để không cập nhật icon
        
        response.getWriter().write(gson.toJson(result));
    }
    
    // XÓA SẢN PHẨM → Cập nhật icon (giảm số dòng)
    private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        
        boolean success = cartDAO.removeItem(itemId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        if (success) {
            int itemCount = cartDAO.getCartItemCount(user.getId());
            result.put("count", itemCount);
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    // XÓA TOÀN BỘ GIỎ HÀNG → Cập nhật icon (về 0)
    private void handleClearCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        boolean success = cartDAO.clearCart(user.getId());
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        if (success) {
            result.put("count", 0);
        }
        
        response.getWriter().write(gson.toJson(result));
    }
}