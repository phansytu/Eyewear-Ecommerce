package model;

import java.util.List;

public class Category {
    private int id, parentId;
    private String name, description, image;
    private List<Product> products; // Lazy load
    private List<Category> subCategories; // Hierarchical
    
    // Constructors
    public Category() {}
    
    public Category(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public int getParentId() { return parentId; }
    public void setParentId(int parentId) { this.parentId = parentId; }
    
    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
    
    public List<Category> getSubCategories() { return subCategories; }
    public void setSubCategories(List<Category> subCategories) { this.subCategories = subCategories; }
    
    // Helper: Is parent category?
    public boolean isParent() {
        return parentId == 0;
    }
    
    @Override
    public String toString() {
        return name + (parentId != 0 ? " (Sub)" : "");
    }
}