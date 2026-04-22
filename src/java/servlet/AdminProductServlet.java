package servlet;

import DAO.ProductDAO;
import DAO.CategoryDAO;
import model.Product;
import model.Category;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products", "/admin/products/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AdminProductServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra admin
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=admin_required");
            return;
        }
        
        String action = request.getParameter("action");
        
        // ==========================================
        // Xử lý AJAX: Lấy thông tin sản phẩm theo ID
        // ==========================================
        if ("get".equals(action)) {
            handleGetProductJson(request, response);
            return;
        }
        
        // ==========================================
        // Xử lý các action đơn giản: hide, show, delete
        // ==========================================
        if ("hide".equals(action)) {
            handleHideProduct(request, response);
            return;
        }
        if ("show".equals(action)) {
            handleShowProduct(request, response);
            return;
        }
        if ("delete".equals(action)) {
            handleDeleteProduct(request, response);
            return;
        }
        
        // ==========================================
        // Xử lý edit (load dữ liệu vào form)
        // ==========================================
        String idParam = request.getParameter("id");
        if ("edit".equals(action) && idParam != null) {
            int id = Integer.parseInt(idParam);
            Product editProduct = productDAO.getProductById(id);
            request.setAttribute("editProduct", editProduct);
        }
        
        // ==========================================
        // Lọc danh sách sản phẩm
        // ==========================================
        String search = request.getParameter("search");
        String categoryIdParam = request.getParameter("categoryId");
        String statusFilter = request.getParameter("status");
        
        List<Product> products;
        
        if (search != null && !search.trim().isEmpty()) {
            products = productDAO.searchProducts(search);
            request.setAttribute("searchValue", search);
        } else if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdParam);
            products = productDAO.getProductsByCategory(categoryId);
            request.setAttribute("currentCategoryId", categoryId);
        } else if (statusFilter != null && !statusFilter.isEmpty()) {
            products = productDAO.getProductsByStatus(statusFilter);
            request.setAttribute("currentStatus", statusFilter);
        } else {
            products = productDAO.getAllProducts();
        }
        
        // ==========================================
        // Thống kê sản phẩm
        // ==========================================
        int totalProducts = productDAO.getTotalProducts();
        int activeProducts = productDAO.getActiveProductsCount();
        int lowStockProducts = productDAO.getLowStockProductsCount();
        int outOfStockProducts = productDAO.getOutOfStockProductsCount();
        
        // Lấy danh sách danh mục
        List<Category> categories = categoryDAO.getAllCategories();
        
        // Set attributes cho JSP
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("activeProducts", activeProducts);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("outOfStockProducts", outOfStockProducts);
        
        // Forward sang JSP
        request.getRequestDispatcher("/jsp/admin/product.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Chống lỗi font Tiếng Việt
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra admin
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=admin_required");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                handleAddProduct(request, response);
            } else if ("update".equals(action)) {
                handleUpdateProduct(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    // ==========================================
    // Các phương thức xử lý
    // ==========================================
    
    /**
     * Xử lý AJAX: Lấy thông tin sản phẩm dạng JSON
     */
    private void handleGetProductJson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        int id = Integer.parseInt(idParam);
        Product product = productDAO.getProductById(id);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> jsonResponse = new HashMap<>();
        if (product != null) {
            jsonResponse.put("success", true);
            jsonResponse.put("product", product);
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Không tìm thấy sản phẩm");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
    
    /**
     * Xử lý ẩn sản phẩm
     */
    private void handleHideProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            productDAO.updateProductStatus(id, "inactive");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
    
    /**
     * Xử lý hiện sản phẩm
     */
    private void handleShowProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            productDAO.updateProductStatus(id, "active");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
    
    /**
     * Xử lý xóa sản phẩm
     */
    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            productDAO.deleteProduct(id);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
    
    /**
     * Xử lý thêm sản phẩm mới
     */
    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Product product = extractProductFromRequest(request);
        
        // Xử lý upload ảnh
        String imagePath = handleImageUpload(request, null);
        product.setImage(imagePath);
        product.setStatus("active");
        
        boolean success = productDAO.addProduct(product);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/products?success=add");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=add_failed");
        }
    }
    
    /**
     * Xử lý cập nhật sản phẩm
     */
    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=missing_id");
            return;
        }
        
        Product product = extractProductFromRequest(request);
        product.setId(Integer.parseInt(idParam));
        
        // Lấy ảnh cũ
        String existingImage = request.getParameter("existingImage");
        
        // Xử lý upload ảnh mới (nếu có)
        String imagePath = handleImageUpload(request, existingImage);
        product.setImage(imagePath);
        
        boolean success = productDAO.updateProduct(product);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/products?success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=update_failed");
        }
    }
    
    /**
     * Trích xuất dữ liệu sản phẩm từ request
     */
    private Product extractProductFromRequest(HttpServletRequest request) throws ServletException, IOException {
        Product product = new Product();
        
        // Thông tin cơ bản
        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setBrand(request.getParameter("brand"));
        product.setGender(request.getParameter("gender"));
        product.setFrameMaterial(request.getParameter("frameMaterial"));
        product.setLensType(request.getParameter("lensType"));
        
        // Giá tiền
        String priceStr = request.getParameter("price");
        product.setPrice((priceStr != null && !priceStr.isEmpty()) ? new BigDecimal(priceStr) : BigDecimal.ZERO);
        
        String salePriceStr = request.getParameter("salePrice");
        if (salePriceStr != null && !salePriceStr.trim().isEmpty()) {
            product.setSalePrice(new BigDecimal(salePriceStr));
        } else {
            product.setSalePrice(null);
        }
        
        // Số lượng và danh mục
        String stockStr = request.getParameter("stock");
        product.setStock(stockStr != null ? Integer.parseInt(stockStr) : 0);
        
        String categoryIdStr = request.getParameter("categoryId");
        product.setCategoryId(categoryIdStr != null ? Integer.parseInt(categoryIdStr) : 0);
        
        // Checkbox
        product.setUvProtection("on".equals(request.getParameter("uvProtection")));
        product.setFeatured("on".equals(request.getParameter("isFeatured")));
        
        return product;
    }
    
    /**
     * Xử lý upload ảnh sản phẩm
     * @return Đường dẫn ảnh đã lưu, hoặc đường dẫn ảnh cũ nếu không upload mới
     */
    private String handleImageUpload(HttpServletRequest request, String existingImage) 
            throws ServletException, IOException {
        
        Part filePart = request.getPart("mainImage");
        
        // Nếu không có file mới, trả về ảnh cũ
        if (filePart == null || filePart.getSize() == 0) {
            return existingImage;
        }
        
        // Lấy tên file gốc
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = "";
        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex > 0) {
            fileExtension = fileName.substring(dotIndex);
        }
        
        // Tạo tên file unique để tránh trùng
        String newFileName = UUID.randomUUID().toString() + fileExtension;
        
        // Đường dẫn thư mục upload
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "products";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Lưu file
        String filePath = uploadPath + File.separator + newFileName;
        filePart.write(filePath);
        
        // Trả về đường dẫn tương đối để lưu vào database
        return "/uploads/products/" + newFileName;
    }
}