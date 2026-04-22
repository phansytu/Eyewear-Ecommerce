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

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tham số bộ lọc
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            String gender = request.getParameter("gender");
            String frameMaterial = request.getParameter("frameMaterial");
            String sort = request.getParameter("sort");
            String pageStr = request.getParameter("page");
            
            // Xử lý giá trị null
            if (minPrice == null || minPrice.isEmpty()) minPrice = null;
            if (maxPrice == null || maxPrice.isEmpty()) maxPrice = null;
            if (gender == null || gender.isEmpty()) gender = null;
            if (frameMaterial == null || frameMaterial.isEmpty()) frameMaterial = null;
            if (sort == null || sort.isEmpty()) sort = "newest";
            
            int page = 1;
            int pageSize = 12;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Lấy danh sách sản phẩm theo bộ lọc (KHÔNG phân trang ở đây)
            List<Product> allProducts = productDAO.searchProductsAdvanced(
                null, null, minPrice, maxPrice, gender, frameMaterial, sort
            );
            
            // Tính toán phân trang
            int totalProducts = allProducts.size();
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
            // Đảm bảo page không vượt quá totalPages
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            if (page < 1) page = 1;
            
            // Lấy sản phẩm cho trang hiện tại
            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalProducts);
            List<Product> pagedProducts = allProducts;
            
            if (fromIndex < toIndex && fromIndex < totalProducts) {
                pagedProducts = allProducts.subList(fromIndex, toIndex);
            } else if (totalProducts == 0) {
                pagedProducts = allProducts;
            }
            
            // Sản phẩm nổi bật (8 sản phẩm)
            List<Product> featured = productDAO.getFeaturedProducts(8);
            
            // Danh mục cho sidebar
            List<Category> categories = categoryDAO.getAllCategories();
            
            // Set attributes
            request.setAttribute("products", pagedProducts);
            request.setAttribute("featured", featured);
            request.setAttribute("categories", categories);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            
            // Giữ lại bộ lọc để hiển thị trên form
            request.setAttribute("selectedMinPrice", minPrice);
            request.setAttribute("selectedMaxPrice", maxPrice);
            request.setAttribute("selectedGender", gender);
            request.setAttribute("selectedFrameMaterial", frameMaterial);
            request.setAttribute("selectedSort", sort);
            
            // Forward to JSP
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<h1>Lỗi: " + e.getMessage() + "</h1>");
        }
    }
}