package model;

import java.math.BigDecimal;

public class ProductVariant {
    private int id, productId, stock;
    private String color, size, sku;
    private BigDecimal price;
    
    // getters/setters...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    // ... other getters/setters

    public ProductVariant() {
    }
    

    public ProductVariant(int id, int productId, int stock, String color, String size, String sku, BigDecimal price) {
        this.id = id;
        this.productId = productId;
        this.stock = stock;
        this.color = color;
        this.size = size;
        this.sku = sku;
        this.price = price;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
}