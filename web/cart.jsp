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
    
    <style>
        .cart-container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        .cart-items {
            flex: 2;
            min-width: 300px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .cart-header {
            display: grid;
            grid-template-columns: 3fr 1fr 1.5fr 1fr 0.5fr;
            padding: 15px 20px;
            background: #667eea;
            color: white;
            font-weight: 600;
        }
        .cart-item {
            display: grid;
            grid-template-columns: 3fr 1fr 1.5fr 1fr 0.5fr;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #eee;
        }
        .product-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            background: #f0f0f0;
        }
        .product-details h4 {
            margin-bottom: 5px;
            color: #333;
            font-size: 16px;
        }
        .product-details .variant {
            font-size: 13px;
            color: #888;
        }
        .product-price {
            color: #e74c3c;
            font-weight: 600;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .quantity-btn {
            width: 32px;
            height: 32px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: all 0.2s;
        }
        .quantity-btn:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        .quantity-input {
            width: 50px;
            height: 32px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .subtotal {
            color: #e74c3c;
            font-weight: 600;
        }
        .remove-btn {
            width: 32px;
            height: 32px;
            border: none;
            background: #fee2e2;
            color: #dc3545;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: all 0.2s;
        }
        .remove-btn:hover {
            background: #dc3545;
            color: white;
        }
        .cart-summary {
            flex: 1;
            min-width: 300px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            height: fit-content;
        }
        .cart-summary h3 {
            margin-bottom: 20px;
            color: #333;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        .summary-row.total {
            border-bottom: none;
            font-weight: 700;
            font-size: 18px;
            color: #e74c3c;
            margin-top: 10px;
        }
        .checkout-btn {
            width: 100%;
            padding: 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: background 0.2s;
        }
        .checkout-btn:hover {
            background: #5a6fd6;
        }
        .clear-cart-btn {
            width: 100%;
            padding: 10px;
            background: transparent;
            color: #888;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 10px;
            transition: all 0.2s;
        }
        .clear-cart-btn:hover {
            background: #fee2e2;
            color: #dc3545;
            border-color: #dc3545;
        }
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
        }
        .empty-cart h2 {
            color: #888;
            margin-bottom: 20px;
        }
        .continue-shopping {
            display: inline-block;
            padding: 12px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            margin-top: 20px;
        }
        .message {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        
        @media (max-width: 768px) {
            .cart-header { display: none; }
            .cart-item {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            .product-info { justify-content: center; }
            .product-price::before { content: "Giá: "; font-weight: normal; color: #666; }
            .subtotal::before { content: "Thành tiền: "; font-weight: normal; color: #666; }
        }
    </style>
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
                        <span><%= cart.getTotalQuantity() %></span>
                    </div>
                    <div class="summary-row total">
                        <span>Tổng tiền:</span>
                        <span><%= cart.getFormattedTotalPrice() %></span>
                    </div>
                    
                    <button class="checkout-btn" onclick="checkout()">Tiến hành thanh toán</button>
                    <button class="clear-cart-btn" onclick="clearCart()">Xóa toàn bộ giỏ hàng</button>
                </div>
            </div>
        <% } %>
    </div>
    
        <jsp:include page="/WEB-INF/includes/footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="..."></script>
</body>
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        
        function showMessage(msg, type) {
            const msgDiv = document.getElementById('message');
            msgDiv.textContent = msg;
            msgDiv.className = 'message ' + type;
            msgDiv.style.display = 'block';
            setTimeout(() => msgDiv.style.display = 'none', 3000);
        }
        
        async function updateQuantity(itemId, change) {
            const input = document.getElementById('qty-' + itemId);
            let newQuantity = parseInt(input.value) + change;
            if (newQuantity < 1) newQuantity = 1;
            input.value = newQuantity;
            await setQuantity(itemId, newQuantity);
        }
        
        async function setQuantity(itemId, quantity) {
            if (quantity < 1) quantity = 1;
            
            try {
                const response = await fetch(contextPath + '/cart', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ action: 'update', itemId: itemId, quantity: quantity })
                });
                
                const data = await response.json();
                if (data.success) {
                    location.reload();
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra!', 'error');
            }
        }
        
        async function removeItem(itemId) {
            if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;
            
            try {
                const response = await fetch(contextPath + '/cart', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ action: 'remove', itemId: itemId })
                });
                
                const data = await response.json();
                if (data.success) {
                    location.reload();
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra!', 'error');
            }
        }
        
        async function clearCart() {
            if (!confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')) return;
            
            try {
                const response = await fetch(contextPath + '/cart', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ action: 'clear' })
                });
                
                const data = await response.json();
                if (data.success) {
                    location.reload();
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra!', 'error');
            }
        }
        
        function checkout() {
            window.location.href = contextPath + '/checkout';
        }
    </script>
</body>
</html>