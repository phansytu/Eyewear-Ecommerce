<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Cart" %>
<%@ page import="model.CartItem" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    Cart cart = (Cart) request.getAttribute("cart");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Cửa hàng kính thời trang</title>
    
    <!-- Bootstrap & Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
    
    
</head>
<body>
  
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    
    <div class="container-fluid px-4 py-4">
        <h1 class="mb-4">🛒 Giỏ hàng của bạn</h1>
        
        <div id="message" class="message"></div>
        
        <% if (cart == null || cart.getItems().isEmpty()) { %>
            <div class="empty-cart">
                <h2>🛍️ Giỏ hàng trống</h2>
                <p>Hãy thêm sản phẩm vào giỏ hàng của bạn!</p>
                <a href="${pageContext.request.contextPath}/home" class="continue-shopping">Tiếp tục mua sắm</a>
            </div>
        <% } else { %>
            <div class="cart-container">
                <div class="cart-items">
                    <div class="cart-header">
                        <span>Sản phẩm</span>
                        <span>Đơn giá</span>
                        <span>Số lượng</span>
                        <span>Thành tiền</span>
                        <span></span>
                    </div>
                    
                    <% for (CartItem item : cart.getItems()) { %>
                        <div class="cart-item" data-item-id="<%= item.getId() %>">
                            <div class="product-info">
                                <img src="<%= item.getProductImage() != null ? item.getProductImage() : "images/default-product.jpg" %>" 
                                     alt="<%= item.getProductName() %>" class="product-image" 
                                     onerror="this.src='https://placehold.co/80x80?text=No+Image'">
                                <div class="product-details">
                                    <h4><%= item.getProductName() %></h4>
                                    <% if (item.getVariantName() != null && !item.getVariantName().isEmpty() && !"null - null".equals(item.getVariantName())) { %>
                                        <span class="variant"><%= item.getVariantName() %></span>
                                    <% } %>
                                </div>
                            </div>
                            
                            <div class="product-price"><%= item.getFormattedPrice() %></div>
                            
                            <div class="quantity-control">
                                <button class="quantity-btn" onclick="updateQuantity(<%= item.getId() %>, -1)">−</button>
                                <input type="number" class="quantity-input" id="qty-<%= item.getId() %>" 
                                       value="<%= item.getQuantity() %>" min="1" 
                                       onchange="setQuantity(<%= item.getId() %>, this.value)">
                                <button class="quantity-btn" onclick="updateQuantity(<%= item.getId() %>, 1)">+</button>
                            </div>
                            
                            <div class="subtotal"><%= item.getFormattedSubtotal() %></div>
                            
                            <button class="remove-btn" onclick="removeItem(<%= item.getId() %>)">🗑️</button>
                        </div>
                    <% } %>
                </div>
                
                <div class="cart-summary">
    <h3>Tổng giỏ hàng</h3>
    <div class="summary-row">
        <span>Tổng sản phẩm:</span>
        <span id="totalQuantitySpan"><%= cart.getTotalQuantity() %></span>
    </div>
    <div class="summary-row total">
        <span>Tổng tiền:</span>
        <span id="totalPriceSpan">
            <fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/>₫
        </span>
    </div>
    
    <button class="checkout-btn" onclick="checkout()">Tiến hành thanh toán</button>
    <button class="clear-cart-btn" onclick="clearCart()">Xóa toàn bộ giỏ hàng</button>
</div>
            </div>
        <% } %>
    </div>
    
        <jsp:include page="/WEB-INF/includes/footer.jsp" />
    
    <!-- Bootstrap JS -->

<script src="${root}/js/giohangcount.js"></script>
</body>
</html>