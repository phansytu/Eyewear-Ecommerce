package servlet;

import DAO.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search", "/search/*"})
public class SearchServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            ProductDAO dao = new ProductDAO();
            
            // Lấy params từ query string
            String keyword = request.getParameter("q");
            String category = request.getParameter("category");
            String minPrice = request.getParameter("min");
            String maxPrice = request.getParameter("max");
            String gender = request.getParameter("gender");
            
            List<Product> results = dao.searchProducts(keyword, category, minPrice, maxPrice, gender);
            
            request.setAttribute("results", results);
            request.setAttribute("keyword", keyword);
            request.setAttribute("category", category);
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);
            request.setAttribute("gender", gender);
            
            request.getRequestDispatcher("/jsp/public/search.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Search error: " + e.getMessage());
        }
    }
}