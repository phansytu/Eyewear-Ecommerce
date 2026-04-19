package model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.List;

public class Product {
    // 1. Các trường dữ liệu cơ bản (Khớp với CSDL và Form)
    private int id;
    private int categoryId;
    private int stock;
    private String name;
    private String description;
    private String brand;
    private String image;       // Ảnh đại diện chính
    private String status;      // 'active', 'hidden', v.v.
    
    // 2. Các trường giá cả (Dùng BigDecimal là chuẩn nhất cho tiền tệ)
    private BigDecimal price;
    private BigDecimal salePrice;
    
    // 3. Các thuộc tính đặc trưng (Khớp với Checkbox ở Form)
    private boolean uvProtection;
    private boolean featured;   // Đổi tên biến từ isFeatured -> featured để getter đẹp hơn
    
    // 4. Các thuộc tính mở rộng (Dành cho bộ lọc chi tiết hoặc trang chi tiết)
    private String gender;
    private String frameMaterial;
    private String lensType;
    private Timestamp createdAt;
    
    // 5. Các trường hiển thị bổ sung (Không có trong DB bảng products, dùng để JOIN và hiển thị UI)
    private String categoryName;
    private List<ProductImage> images;      // Danh sách ảnh phụ gallery
    private List<ProductVariant> variants;  // Danh sách biến thể (màu sắc, size...)
    
    // --- Constructors ---
    public Product() {}

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getSalePrice() { return salePrice != null ? salePrice : price; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }

    public boolean isUvProtection() { return uvProtection; }
    public void setUvProtection(boolean uvProtection) { this.uvProtection = uvProtection; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getFrameMaterial() { return frameMaterial; }
    public void setFrameMaterial(String frameMaterial) { this.frameMaterial = frameMaterial; }

    public String getLensType() { return lensType; }
    public void setLensType(String lensType) { this.lensType = lensType; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public List<ProductImage> getImages() { return images; }
    public void setImages(List<ProductImage> images) { this.images = images; }

    public List<ProductVariant> getVariants() { return variants; }
    public void setVariants(List<ProductVariant> variants) { this.variants = variants; }

    // --- Helper methods ---
    
    // Tính phần trăm giảm giá (Sử dụng RoundingMode chuẩn Java mới)
    public String getDiscountPercent() {
        if (salePrice == null || salePrice.compareTo(price) >= 0) return "0%";
        
        BigDecimal discount = price.subtract(salePrice)
                                   .divide(price, 4, RoundingMode.HALF_UP)
                                   .multiply(new BigDecimal("100"));
        
        return discount.setScale(0, RoundingMode.HALF_UP).toString() + "%";
    }
    
    // Kiểm tra còn hàng không
    public boolean isInStock() {
        return stock > 0;
    }
}