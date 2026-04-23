package servlet;

import DAO.ProductDAO;
import DAO.ReviewDAO;
import model.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                request.setAttribute("error", "Sản phẩm không tồn tại!");
                request.getRequestDispatcher("/jsp/public/product-detail.jsp").forward(request, response);
                return;
            }
            
            // Lấy thống kê đánh giá từ ReviewDAO
            int totalReviews = reviewDAO.getTotalReviewsCount(productId);
            double averageRating = reviewDAO.getAverageRating(productId);
            int[] ratingStats = reviewDAO.getRatingStatistics(productId);
            int[] ratingPercentages = reviewDAO.getRatingPercentages(productId);
            
            // Gán vào product (hoặc set attribute riêng)
            product.setTotalReviews(totalReviews);
            product.setAverageRating(averageRating);
            
            request.setAttribute("product", product);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("ratingStats", ratingStats);
            request.setAttribute("ratingPercentages", ratingPercentages);
            
            request.getRequestDispatcher("/jsp/public/product-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}