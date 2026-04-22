package servlet;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import model.Category;
import model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy params từ query string
            String keyword = request.getParameter("keyword");
            String categoryId = request.getParameter("categoryId");
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            String gender = request.getParameter("gender");
            String frameMaterial = request.getParameter("frameMaterial");
            String sort = request.getParameter("sort");
            
            // Xử lý giá trị null
            if (keyword == null) keyword = "";
            if (minPrice == null || minPrice.isEmpty()) minPrice = null;
            if (maxPrice == null || maxPrice.isEmpty()) maxPrice = null;
            if (gender == null || gender.isEmpty() || gender.equals("all")) gender = null;
            if (frameMaterial == null || frameMaterial.isEmpty() || frameMaterial.equals("all")) frameMaterial = null;
            if (sort == null || sort.isEmpty()) sort = "newest";
            
            // Lấy danh sách sản phẩm theo bộ lọc
            List<Product> products = productDAO.searchProductsAdvanced(
                keyword, categoryId, minPrice, maxPrice, gender, frameMaterial, sort
            );
            
            // Lấy danh sách danh mục cho filter
            List<Category> categories = categoryDAO.getAllCategories();
            
            // Lấy thống kê số lượng sản phẩm theo các tiêu chí
            int totalProducts = products.size();
            
            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("selectedCategoryId", categoryId);
            request.setAttribute("selectedMinPrice", minPrice);
            request.setAttribute("selectedMaxPrice", maxPrice);
            request.setAttribute("selectedGender", gender);
            request.setAttribute("selectedFrameMaterial", frameMaterial);
            request.setAttribute("selectedSort", sort);
            
            // Forward to search results page
            request.getRequestDispatcher("/jsp/public/search.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Search error: " + e.getMessage());
        }
    }
}