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

@WebServlet(name = "CartServlet", urlPatterns = {"/cart/*"})
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if ("/count".equals(pathInfo)) {
            // API lấy số lượng item
            int count = cartDAO.getCartItemCount(user.getId());
            response.setContentType("application/json");
            response.getWriter().write("{\"count\":" + count + "}");
            return;
        }
        
        // Hiển thị trang giỏ hàng
        Cart cart = cartDAO.getCartByUserId(user.getId());
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
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
            jsonResponse.put("redirect", "login");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                handleAddToCart(request, response, user.getId(), jsonResponse);
                break;
            case "update":
                handleUpdateCart(request, response, jsonResponse);
                break;
            case "remove":
                handleRemoveItem(request, response, jsonResponse);
                break;
            case "clear":
                handleClearCart(request, response, user.getId(), jsonResponse);
                break;
            default:
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Hành động không hợp lệ!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
        }
    }
    
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, 
                                 int userId, Map<String, Object> jsonResponse) throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String variantIdParam = request.getParameter("variantId");
            Integer variantId = (variantIdParam != null && !variantIdParam.isEmpty()) 
                    ? Integer.parseInt(variantIdParam) : null;
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (cartDAO.addToCart(userId, productId, variantId, quantity)) {
                int count = cartDAO.getCartItemCount(userId);
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã thêm vào giỏ hàng!");
                jsonResponse.put("cartCount", count);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Thêm vào giỏ hàng thất bại!");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
    
    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response,
                                   Map<String, Object> jsonResponse) throws IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (cartDAO.updateQuantity(itemId, quantity)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã cập nhật giỏ hàng!");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Cập nhật thất bại!");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
    
    private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response,
                                   Map<String, Object> jsonResponse) throws IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            
            if (cartDAO.removeItem(itemId)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã xóa sản phẩm!");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Xóa thất bại!");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
    
    private void handleClearCart(HttpServletRequest request, HttpServletResponse response,
                                  int userId, Map<String, Object> jsonResponse) throws IOException {
        if (cartDAO.clearCart(userId)) {
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đã xóa toàn bộ giỏ hàng!");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Xóa thất bại!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}