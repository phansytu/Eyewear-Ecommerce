package servlet;

import DAO.OrderDAO;
import DAO.ReviewDAO;
import model.ProductReview;
import model.User;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    
    private ReviewDAO reviewDAO = new ReviewDAO();
    private OrderDAO orderDAO = new OrderDAO();  // Thêm OrderDAO
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if ("list".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String pageParam = request.getParameter("page");
            int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
            int limit = 5;
            int offset = (page - 1) * limit;
            
            List<ProductReview> reviews = reviewDAO.getReviewsByProductId(productId, limit, offset);
            int total = reviewDAO.getTotalReviewsCount(productId);
            double average = reviewDAO.getAverageRating(productId);
            int[] ratingStats = reviewDAO.getRatingStatistics(productId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("reviews", reviews);
            result.put("total", total);
            result.put("average", average);
            result.put("ratingStats", ratingStats);
            result.put("currentPage", page);
            result.put("totalPages", (int) Math.ceil((double) total / limit));
            result.put("hasMore", (page * limit) < total);
            
            response.getWriter().write(gson.toJson(result));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Vui lòng đăng nhập để đánh giá!");
            response.getWriter().write(gson.toJson(result));
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            // ===== KIỂM TRA ĐÃ MUA HÀNG CHƯA =====
            boolean hasPurchased = orderDAO.hasUserPurchasedProduct(user.getId(), productId);
            if (!hasPurchased) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "Bạn cần mua sản phẩm này trước khi đánh giá!");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            // ===== KẾT THÚC KIỂM TRA =====
            
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            String images = request.getParameter("images");
            
            // Kiểm tra đã đánh giá chưa
            if (reviewDAO.hasUserReviewed(user.getId(), productId)) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "Bạn đã đánh giá sản phẩm này rồi!");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            ProductReview review = new ProductReview();
            review.setProductId(productId);
            review.setUserId(user.getId());
            review.setRating(rating);
            review.setComment(comment);
            review.setImages(images);
            
            boolean success = reviewDAO.addReview(review);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Cảm ơn bạn đã đánh giá!" : "Đánh giá thất bại!");
            response.getWriter().write(gson.toJson(result));
        }
    }
}