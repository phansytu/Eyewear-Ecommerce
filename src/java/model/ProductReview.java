// model/ProductReview.java
package model;

import java.sql.Timestamp;
import java.util.List;

public class ProductReview {
    private int id;
    private int productId;
    private int userId;
    private int rating;
    private String comment;
    private String images; // JSON string
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String status;
    
    // Additional fields for display
    private String userName;
    private String userAvatar;
    private List<String> imageList;
    private ReviewReply reply;
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }
    
    public List<String> getImageList() { return imageList; }
    public void setImageList(List<String> imageList) { this.imageList = imageList; }
    
    public ReviewReply getReply() { return reply; }
    public void setReply(ReviewReply reply) { this.reply = reply; }
    
    // Helper methods
    public String getTimeAgo() {
        long diff = System.currentTimeMillis() - createdAt.getTime();
        long minutes = diff / (60 * 1000);
        long hours = minutes / 60;
        long days = hours / 24;
        
        if (minutes < 1) return "Vừa xong";
        if (minutes < 60) return minutes + " phút trước";
        if (hours < 24) return hours + " giờ trước";
        return days + " ngày trước";
    }
}

// model/ReviewReply.java
