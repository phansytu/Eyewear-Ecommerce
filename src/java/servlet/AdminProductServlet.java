package servlet;

import DAO.ProductDAO;
import DAO.CategoryDAO;
import model.Product;
import model.Category;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products", "/admin/products/*"})
@MultipartConfig( // BẮT BUỘC PHẢI CÓ ĐỂ NHẬN FORM CÓ ẢNH
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
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
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        List<Product> products = productDAO.getAllProducts(); 
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
        
        // 1. Chống lỗi font Tiếng Việt khi nhận dữ liệu từ Form
        request.setCharacterEncoding("UTF-8");
        
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
                
                // 2. Lấy các dữ liệu text cơ bản
                product.setName(request.getParameter("name"));
                product.setDescription(request.getParameter("description"));
                
                // Xử lý an toàn cho Price
                String priceStr = request.getParameter("price");
                product.setPrice((priceStr != null && !priceStr.isEmpty()) ? new BigDecimal(priceStr) : BigDecimal.ZERO);
                
                // Xử lý an toàn cho Sale Price (Tránh NullPointerException)
                String salePriceStr = request.getParameter("salePrice");
                if (salePriceStr != null && !salePriceStr.trim().isEmpty()) {
                    product.setSalePrice(new BigDecimal(salePriceStr));
                } else {
                    product.setSalePrice(null); // Không có giá KM
                }
                
                product.setStock(Integer.parseInt(request.getParameter("stock")));
                product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                product.setBrand(request.getParameter("brand"));
                product.setGender(request.getParameter("gender"));
                product.setFrameMaterial(request.getParameter("frameMaterial"));
                product.setLensType(request.getParameter("lensType"));
                
                // Lấy checkbox (HTML checkbox thường gửi "on" nếu được tích)
                product.setUvProtection("on".equals(request.getParameter("uvProtection")));
                product.setFeatured("on".equals(request.getParameter("isFeatured")));
                
                // 3. Xử lý tải ảnh (Quan trọng)
                Part filePart = request.getPart("image"); // Lưu ý: name trong thẻ input type="file" phải là "image"
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    
                    // Tạo thư mục uploads nếu chưa có
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    // Lưu file ảnh vào server
                    filePart.write(uploadPath + File.separator + fileName);
                    
                    // Lưu đường dẫn ảnh vào database
                    product.setImage("uploads/" + fileName);
                } else if ("update".equals(action)) {
                    // Nếu đang update mà không chọn ảnh mới, lấy lại đường dẫn ảnh cũ (cần có input hidden trong form)
                    product.setImage(request.getParameter("existingImage"));
                }
                
                // 4. Lưu vào DB
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
            
            response.sendRedirect("products"); // Reset trang sau khi thao tác
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            // Trả về lại trang để hiển thị thông báo lỗi
            doGet(request, response);
        }
    }
}