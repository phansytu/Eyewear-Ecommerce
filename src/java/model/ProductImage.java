package model;

public class ProductImage {
    private int id, productId;
    private String imageUrl;
    private boolean isMain;
    
    // getters/setters...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public boolean isIsMain() { return isMain; }
    public void setIsMain(boolean isMain) { this.isMain = isMain; }
}