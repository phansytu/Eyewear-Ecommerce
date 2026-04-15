package servlet;

import DAO.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        ProductDAO productDAO = new ProductDAO();
        
        // Get product details + images + variants + reviews
        request.setAttribute("product", productDAO.getProductById(Integer.parseInt(id)));
        request.getRequestDispatcher("/jsp/public/product-detail.jsp").forward(request, response);
    }
}