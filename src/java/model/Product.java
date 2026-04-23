package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Product {
    private int id;
    private String name;
    private String description;
    private BigDecimal price;
    private BigDecimal salePrice;
    private int stock;
    private String brand;
    private String image;
    private boolean isFeatured;
    private boolean uvProtection;
    private int categoryId;
    private String categoryName;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for product detail
    private String gender;
    private String frameMaterial;
    private String lensType;
    
    // Additional fields for variants and images
    private List<ProductImage> images;
    private List<ProductVariant> variants;
    
    // THÊM 2 TRƯỜNG NÀY CHO ĐÁNH GIÁ
    private Double averageRating;  // Điểm đánh giá trung bình
    private Integer totalReviews;   // Tổng số đánh giá
    
    // Constructors
    public Product() {}
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
    
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean featured) { isFeatured = featured; }
    
    public boolean isUvProtection() { return uvProtection; }
    public void setUvProtection(boolean uvProtection) { this.uvProtection = uvProtection; }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getFrameMaterial() { return frameMaterial; }
    public void setFrameMaterial(String frameMaterial) { this.frameMaterial = frameMaterial; }
    
    public String getLensType() { return lensType; }
    public void setLensType(String lensType) { this.lensType = lensType; }
    
    public List<ProductImage> getImages() { return images; }
    public void setImages(List<ProductImage> images) { this.images = images; }
    
    public List<ProductVariant> getVariants() { return variants; }
    public void setVariants(List<ProductVariant> variants) { this.variants = variants; }
    
    // THÊM GETTERS VÀ SETTERS CHO ĐÁNH GIÁ
    public Double getAverageRating() { 
        return averageRating != null ? averageRating : 0.0; 
    }
    public void setAverageRating(Double averageRating) { 
        this.averageRating = averageRating; 
    }
    
    public Integer getTotalReviews() { 
        return totalReviews != null ? totalReviews : 0; 
    }
    public void setTotalReviews(Integer totalReviews) { 
        this.totalReviews = totalReviews; 
    }
    
    // Helper method tính phần trăm giảm giá
    public int getDiscountPercent() {
        if (price != null && salePrice != null && price.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal discount = price.subtract(salePrice);
            BigDecimal percent = discount.multiply(BigDecimal.valueOf(100)).divide(price, 0, BigDecimal.ROUND_HALF_UP);
            return percent.intValue();
        }
        return 0;
    }
    
    // Helper method lấy số sao hiển thị
    public int getFullStars() {
        if (averageRating == null) return 0;
        return (int) Math.floor(averageRating);
    }
    
    public boolean hasHalfStar() {
        if (averageRating == null) return false;
        return (averageRating - getFullStars()) >= 0.5;
    }
    
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", salePrice=" + salePrice +
                ", averageRating=" + averageRating +
                ", totalReviews=" + totalReviews +
                '}';
    }
}