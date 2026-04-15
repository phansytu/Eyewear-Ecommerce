package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Product {
    private int id, categoryId, stock;
    private String name, description, brand, gender, frameMaterial, lensType, image, status;
    private BigDecimal price, salePrice;
    private boolean uvProtection, isFeatured;
    private Timestamp createdAt;
    
    // Lists for detail page
    private List<ProductImage> images;
    private List<ProductVariant> variants;
    private String categoryName;
    
    // Constructors
    public Product() {}
    
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public BigDecimal getSalePrice() { return salePrice != null ? salePrice : price; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
    
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getFrameMaterial() { return frameMaterial; }
    public void setFrameMaterial(String frameMaterial) { this.frameMaterial = frameMaterial; }
    
    public String getLensType() { return lensType; }
    public void setLensType(String lensType) { this.lensType = lensType; }
    
    public boolean isUvProtection() { return uvProtection; }
    public void setUvProtection(boolean uvProtection) { this.uvProtection = uvProtection; }
    
    public boolean isIsFeatured() { return isFeatured; }
    public void setIsFeatured(boolean isFeatured) { this.isFeatured = isFeatured; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public List<ProductImage> getImages() { return images; }
    public void setImages(List<ProductImage> images) { this.images = images; }
    
    public List<ProductVariant> getVariants() { return variants; }
    public void setVariants(List<ProductVariant> variants) { this.variants = variants; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    // Helper methods
    public String getDiscountPercent() {
        if (salePrice == null || salePrice.equals(price)) return "0%";
        BigDecimal discount = price.subtract(salePrice).divide(price, 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100"));
        return discount.setScale(0, BigDecimal.ROUND_HALF_UP).toString() + "%";
    }
    
    public boolean isInStock() {
        return stock > 0;
    }
}