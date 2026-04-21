package dto;

public class OrderDetailDTO {
    private String productName;
    private String productImage;
    private int quantity;
    private double price;

    public OrderDetailDTO(String productName, String productImage, int quantity, double price) {
        this.productName = productName;
        this.productImage = productImage;
        this.quantity = quantity;
        this.price = price;
    }
    
    // Đừng quên Generate Getter & Setter cho 4 biến này nhé!
    public String getProductName() { return productName; }
    public String getProductImage() { return productImage; }
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }
}