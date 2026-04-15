package servlet; // Thay đổi package cho phù hợp với cấu trúc của bạn (ví dụ: controller hoặc com.shop.controller)

import model.Category;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Thiết lập encoding để hiển thị đúng tiếng Việt
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");
        
        // Sử dụng model Category của bạn thay vì chỉ dùng String
        Category category = new Category();
        List<Product> productList = new ArrayList<>();

        // Kiểm tra tham số type và đổ dữ liệu tương ứng
        if (type == null || type.isEmpty()) {
            category.setName("Tất cả sản phẩm");
            productList.add(createProduct(1, "Kính Râm Nam Ray-Ban Aviator", "4500000", "3900000", "https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=300&q=80"));
            productList.add(createProduct(3, "Gọng Kính Nữ Mắt Mèo Cá Tính", "850000", "650000", "https://images.unsplash.com/photo-1577803645773-f96470509666?w=300&q=80"));
        } 
        else switch (type) {
            case "kinh-ram-nam":
                category.setName("Kính Râm Nam");
                productList.add(createProduct(1, "Kính Râm Nam Ray-Ban Aviator Cổ Điển", "4500000", "3900000", "https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=300&q=80"));
                productList.add(createProduct(2, "Kính Râm Thể Thao Nam Phân Cực", "500000", "350000", "https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&q=80"));
                productList.add(createProduct(3, "Kính Mát Nam Vuông Bản To Hợp Kim", "750000", "590000", "https://images.unsplash.com/photo-1589642380614-4a8c2147b857?w=300&q=80"));
                break;
                
            case "gong-kinh-nu":
                category.setName("Gọng Kính Nữ");
                productList.add(createProduct(4, "Gọng Kính Nữ Mắt Mèo Cá Tính", "850000", "650000", "https://images.unsplash.com/photo-1577803645773-f96470509666?w=300&q=80"));
                productList.add(createProduct(5, "Gọng Kính Tròn Vintage Nữ Bọc Nhựa", "450000", "390000", "https://images.unsplash.com/photo-1509695507497-903c140c43b0?w=300&q=80"));
                productList.add(createProduct(6, "Gọng Kính Nữ Trong Suốt Hàn Quốc", "350000", "250000", "https://images.unsplash.com/photo-1591076482161-42ce6da69f67?w=300&q=80"));
                break;
                
            case "kinh-chong-anh-sang-xanh":
                category.setName("Kính Chống Ánh Sáng Xanh");
                productList.add(createProduct(7, "Kính Máy Tính Chống Tia UV", "350000", "250000", "https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=300&q=80"));
                productList.add(createProduct(8, "Kính Không Độ Bảo Vệ Mắt", "450000", "320000", "https://images.unsplash.com/photo-1625591340262-f19e487103df?w=300&q=80"));
                break;
                
            case "gong-titanium":
                category.setName("Gọng Kính Titanium Siêu Nhẹ");
                productList.add(createProduct(9, "Gọng Kính Nam Titanium Siêu Nhẹ", "1200000", "990000", "https://images.unsplash.com/photo-1556306535-0f09a589f0a5?w=300&q=80"));
                productList.add(createProduct(10, "Gọng Khoan Titanium Đẳng Cấp", "1500000", "1250000", "https://images.unsplash.com/photo-1508296695146-257a814050b4?w=300&q=80"));
                break;
                
            case "kinh-rayban":
                category.setName("Thương Hiệu Ray-Ban");
                productList.add(createProduct(11, "Kính Mát Ray-Ban Wayfarer", "3800000", "3200000", "https://images.unsplash.com/photo-1578681994506-b8f463449011?w=300&q=80"));
                productList.add(createProduct(12, "Kính Ray-Ban Clubmaster", "3500000", "2900000", "https://images.unsplash.com/photo-1559070820-22c6eeb411f5?w=300&q=80"));
                break;
                
            case "phu-kien-kinh":
                category.setName("Phụ Kiện Kính Mắt");
                productList.add(createProduct(13, "Hộp Đựng Kính Bọc Da Sang Trọng", "150000", "99000", "https://via.placeholder.com/300x300/EFEBE9/5D4037?text=Hop+Kinh"));
                productList.add(createProduct(14, "Nước Lau Kính + Khăn Nano", "80000", "50000", "https://via.placeholder.com/300x300/E0F7FA/0097A7?text=Nuoc+Lau+Kinh"));
                break;
                
            default:
                category.setName("Danh mục không tồn tại");
                break;
        }

        // Truyền tên danh mục (để khớp với JSP hiện tại ${categoryName}) 
        // và danh sách sản phẩm sang trang JSP
        request.setAttribute("categoryName", category.getName());
        request.setAttribute("products", productList);

        request.getRequestDispatcher("/jsp/public/category.jsp").forward(request, response);
    }

    /**
     * Hàm Helper để tạo nhanh object Product dựa vào Model của bạn
     */
    private Product createProduct(int id, String name, String priceStr, String salePriceStr, String imageUrl) {
        Product p = new Product();
        p.setId(id);
        p.setName(name);
        
        // Sử dụng BigDecimal cho giá tiền theo đúng Model
        p.setPrice(new BigDecimal(priceStr));
        p.setSalePrice(new BigDecimal(salePriceStr));
        
        p.setImage(imageUrl);
        p.setStock(10); // Gán số lượng tồn kho > 0 để nút "Thêm vào giỏ hàng" hiện lên
        
        return p;
    }
}