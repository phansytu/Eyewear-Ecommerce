package servlet;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import model.Category;
import model.Product;
// Nếu bạn tạo class SubCategory riêng thì import vào, 
// nếu dùng chung class Category cho cả cha và con thì bỏ qua.
// import model.SubCategory; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Khởi tạo các DAO
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // 1. Lấy tất cả danh mục cha truyền sang JSP (phục vụ cho header hoặc menu tĩnh nếu cần)
        List<Category> allCategories = categoryDAO.getAllCategories();
        request.setAttribute("categories", allCategories);

        // 2. Lấy ID danh mục cha và ID danh mục con từ URL
        String idStr = request.getParameter("id");
        String subIdStr = request.getParameter("sub_id");
        
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(idStr);
                
                // Lấy thông tin danh mục cha hiện tại (để hiển thị Tên lên Breadcrumb/Tiêu đề)
                Category currentCategory = categoryDAO.getCategoryById(categoryId);
                if (currentCategory != null) {
                    request.setAttribute("categoryName", currentCategory.getName());
                }

                // 3. Lấy danh sách danh mục con để hiển thị ở Sidebar
                // Lưu ý: Đổi kiểu List<Category> thành List<SubCategory> nếu bạn tạo Model riêng
                List<Category> subCategories = categoryDAO.getSubCategoriesByParentId(categoryId);
                request.setAttribute("subCategories", subCategories);

                // 4. Xử lý logic lấy Sản phẩm: Cha hoặc Con
                List<Product> productList;
                
                if (subIdStr != null && !subIdStr.isEmpty()) {
                    // Trạng thái 1: User click vào một Danh mục Con cụ thể
                    int subCategoryId = Integer.parseInt(subIdStr);
                    productList = productDAO.getProductsByCategory (subCategoryId);
                } else {
                    // Trạng thái 2: User chỉ click vào Danh mục Cha (mặc định xem tất cả)
                    productList = productDAO.getProductsByCategory(categoryId);
                }
                
                // Truyền danh sách sản phẩm qua JSP
                request.setAttribute("products", productList);

            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse ID trên URL: " + e.getMessage());
                // Có thể redirect về trang lỗi 404 hoặc trang chủ nếu ID nhập bậy bạ
                // response.sendRedirect(request.getContextPath() + "/home");
                // return;
            }
        }

        // 5. Chuyển hướng sang trang giao diện JSP
        request.getRequestDispatcher("/jsp/public/category.jsp").forward(request, response);
    }
}