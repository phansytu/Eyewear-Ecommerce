package servlet;

import DAO.ReviewDAO;
import DAO.ProductDAO;
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
    private ProductDAO productDAO = new ProductDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("list".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String pageParam = request.getParameter("page");
int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
            int limit = 10;
            int offset = (page - 1) * limit;
            
            List<ProductReview> reviews = reviewDAO.getReviewsByProductId(productId, limit, offset);
            int total = reviewDAO.getTotalReviewsCount(productId);
            int[] ratingStats = reviewDAO.getRatingStatistics(productId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("reviews", reviews);
            result.put("total", total);
            result.put("ratingStats", ratingStats);
            result.put("currentPage", page);
            result.put("totalPages", (int) Math.ceil((double) total / limit));
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));
            return;
        }
        
        // Forward to product detail page
        String productId = request.getParameter("id");
        if (productId != null) {
            request.setAttribute("product", productDAO.getProductById(Integer.parseInt(productId)));
            request.getRequestDispatcher("/jsp/public/product-detail.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để đánh giá\"}");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            String images = request.getParameter("images"); // JSON array
            
            // Kiểm tra đã đánh giá chưa
            if (reviewDAO.hasUserReviewed(user.getId(), productId)) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã đánh giá sản phẩm này rồi!\"}");
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
            result.put("message", success ? "Đánh giá thành công!" : "Đánh giá thất bại!");
            response.getWriter().write(gson.toJson(result));
        }
    }
}