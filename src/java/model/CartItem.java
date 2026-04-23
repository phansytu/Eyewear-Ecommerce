package model;

public class CartItem {
    private int id;
    private int cartId;
    private int productId;
    private Integer variantId;
    private int quantity;
    
    // Thông tin bổ sung từ JOIN
    private String productName;
    private String productImage;
    private double price;
    private String variantName; // Ví dụ: "Màu đen, Size L"
    
    public CartItem() {}

    public CartItem(int id, int cartId, int productId, Integer variantId, int quantity) {
        this.id = id;
        this.cartId = cartId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Integer getVariantId() {
        return variantId;
    }

    public void setVariantId(Integer variantId) {
        this.variantId = variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getVariantName() {
        return variantName;
    }

    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }
    
    // Tính thành tiền
    public double getSubtotal() {
        return price * quantity;
    }
    
    // Định dạng tiền VND
    public String getFormattedPrice() {
        return String.format("%,.0f₫", price).replace(",", ".");
    }
    
    public String getFormattedSubtotal() {
        return String.format("%,.0f₫", getSubtotal()).replace(",", ".");
    }
}