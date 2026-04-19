package servlet;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            // Tất cả sản phẩm active
            List<Product> products = productDAO.getAllProducts();
            
            // Sản phẩm nổi bật (top 8)
            List<Product> featured = productDAO.getFeaturedProducts(8);
            
            // Danh mục cho sidebar/filter
            List<Category> categories = categoryDAO.getAllCategories();
            
            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("featured", featured);
            request.setAttribute("categories", categories);
            
            // Forward to JSP
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            
        }  catch (Exception e) {
    e.printStackTrace();
    // Bỏ gọi file error.jsp đi, in thẳng lỗi ra màn hình để biết tại sao
    response.setContentType("text/html; charset=UTF-8");
    response.getWriter().write("<h1>Có lỗi khi lấy dữ liệu từ Database: " + e.getMessage() + "</h1>");
}
    }
}