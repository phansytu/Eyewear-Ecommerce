package servlet;

import DAO.ProductDAO;
import DAO.CategoryDAO;
import model.Product;
import model.Category;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products", "/admin/products/*"})
public class AdminProductServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login?error=admin_required");
            return;
        }
        
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        List<Product> products = productDAO.getAllProducts(); // All including inactive for admin
        List<Category> categories = categoryDAO.getAllCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        
        if ("edit".equals(action) && idParam != null) {
            int id = Integer.parseInt(idParam);
            Product editProduct = productDAO.getProductById(id);
            request.setAttribute("editProduct", editProduct);
        }
        
        request.getRequestDispatcher("/jsp/admin/products.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login?error=admin_required");
            return;
        }
        
        ProductDAO dao = new ProductDAO();
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action) || "update".equals(action)) {
                Product product = new Product();
                
                product.setName(request.getParameter("name"));
                product.setDescription(request.getParameter("description"));
                product.setPrice(new BigDecimal(request.getParameter("price")));
                if (!request.getParameter("salePrice").isEmpty()) {
                    product.setSalePrice(new BigDecimal(request.getParameter("salePrice")));
                }
                product.setStock(Integer.parseInt(request.getParameter("stock")));
                product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                product.setBrand(request.getParameter("brand"));
                product.setGender(request.getParameter("gender"));
                product.setFrameMaterial(request.getParameter("frameMaterial"));
                product.setLensType(request.getParameter("lensType"));
                product.setUvProtection("on".equals(request.getParameter("uvProtection")));
                product.setIsFeatured("on".equals(request.getParameter("isFeatured")));
                product.setImage(request.getParameter("image"));
                
                if ("add".equals(action)) {
                    dao.addProduct(product);
                } else {
                    product.setId(Integer.parseInt(request.getParameter("id")));
                    dao.updateProduct(product);
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteProduct(id);
            }
            
            response.sendRedirect("products");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin/products.jsp").forward(request, response);
        }
    }
}