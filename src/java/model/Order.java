package model;

import java.sql.Timestamp;

public class Order {
    private int id;
    private int userId;
    private double totalAmount;
    private String status; // 'pending','confirmed','shipping','delivered','cancelled'
    private Timestamp createdAt;
    private String address;
    private String phone;
    private Integer voucherId; // Dùng Integer thay vì int để có thể nhận giá trị null
    private String paymentStatus; // 'unpaid','paid'
    // Thêm dòng này vào phần khai báo biến của class model.Order
private java.util.List<dto.OrderDetailDTO> details;

// Thêm Getter và Setter cho biến details này

public void setDetails(java.util.List<dto.OrderDetailDTO> details) { this.details = details; }

    // Constructor mặc định
    public Order() {
    }

    // Constructor đầy đủ
    public Order(int id, int userId, double totalAmount, String status, Timestamp createdAt, String address, String phone, Integer voucherId, String paymentStatus) {
        this.id = id;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
        this.address = address;
        this.phone = phone;
        this.voucherId = voucherId;
        this.paymentStatus = paymentStatus;
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

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    public java.util.List<dto.OrderDetailDTO> getDetails() { return details; }
    
}