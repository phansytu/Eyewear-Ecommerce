package model;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private double totalAmount;
    private String status;
    private Timestamp createdAt;
    private String address;
    private String phone;
    private Integer voucherId;
    private String paymentStatus;
    
    private String customerUsername;
    private String customerFullName;
    private String customerEmail;
    
    private List<OrderDetail> orderDetails;
    
    public Order() {}
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public Integer getVoucherId() { return voucherId; }
    public void setVoucherId(Integer voucherId) { this.voucherId = voucherId; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public List<OrderDetail> getOrderDetails() { return orderDetails; }
    public void setOrderDetails(List<OrderDetail> orderDetails) { this.orderDetails = orderDetails; }
    
    public String getCustomerUsername() { return customerUsername; }
    public void setCustomerUsername(String customerUsername) { this.customerUsername = customerUsername; }
    
    public String getCustomerFullName() { return customerFullName; }
    public void setCustomerFullName(String customerFullName) { this.customerFullName = customerFullName; }
    
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    
    public String getCustomerDisplayName() {
        if (customerFullName != null && !customerFullName.trim().isEmpty()) {
            return customerFullName;
        }
        if (customerUsername != null && !customerUsername.trim().isEmpty()) {
            return customerUsername;
        }
        return "Khách #" + userId;
    }
    
    public String getStatusText() {
        switch(status != null ? status : "") {
            case "pending": return "Chờ xác nhận";
            case "confirmed": return "Đã xác nhận";
            case "shipping": return "Đang giao hàng";
            case "delivered": return "Hoàn thành";
            case "cancelled": return "Đã hủy";
            default: return status;
        }
    }
    
    public String getStatusClass() {
        switch(status != null ? status : "") {
            case "pending": return "warning";
            case "confirmed": return "info";
            case "shipping": return "primary";
            case "delivered": return "success";
            case "cancelled": return "danger";
            default: return "secondary";
        }
    }
    
    // ✅ THÊM 2 METHOD NÀY
    public String getStatusBadgeClass() {
        switch(status != null ? status : "") {
            case "pending": return "status-processing";
            case "confirmed": return "status-processing";
            case "shipping": return "status-shipped";
            case "delivered": return "status-delivered";
            case "cancelled": return "status-cancelled";
            default: return "";
        }
    }
    
    public String getStatusIcon() {
        switch(status != null ? status : "") {
            case "pending": return "fa-clock";
            case "confirmed": return "fa-check-circle";
            case "shipping": return "fa-truck";
            case "delivered": return "fa-check-double";
            case "cancelled": return "fa-times-circle";
            default: return "fa-info-circle";
        }
    }
}