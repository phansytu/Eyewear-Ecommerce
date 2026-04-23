package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private int id;
    private int userId;
    private Timestamp createdAt;
    private List<CartItem> items;
    
    public Cart() {
        items = new ArrayList<>();
    }

    public Cart(int id, int userId, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.createdAt = createdAt;
        this.items = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }
    
    // Tính tổng số lượng sản phẩm
    public int getTotalQuantity() {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        return total;
    }
    
    // Tính tổng tiền
    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : items) {
            total += item.getSubtotal();
        }
        return total;
    }
    
    // Định dạng tiền VND
    public String getFormattedTotalPrice() {
        return String.format("%,.0f₫", getTotalPrice()).replace(",", ".");
    }
}