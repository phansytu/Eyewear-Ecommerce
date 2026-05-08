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
    if (cart == null || cart.getItems().isEmpty()) {
        response.sendRedirect("cart");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f5f5f5; }
        .checkout-container { max-width: 1000px; margin: 30px auto; padding: 20px; }
        .checkout-content { display: flex; gap: 20px; flex-wrap: wrap; }
        .checkout-form { flex: 1.5; min-width: 300px; background: white; border-radius: 10px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .checkout-summary { flex: 1; min-width: 280px; background: white; border-radius: 10px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: fit-content; }
        .form-group { margin-bottom: 15px; }
        .form-group label { font-weight: 600; margin-bottom: 5px; display: block; font-size: 14px; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; }
        .form-group textarea { resize: vertical; min-height: 80px; }
        .section-title { font-weight: 600; margin-bottom: 15px; font-size: 16px; }
        .payment-method-item {
            border: 2px solid #ddd; border-radius: 10px; padding: 15px; margin-bottom: 10px;
            cursor: pointer; transition: all 0.2s;
        }
        .payment-method-item:hover { border-color: #667eea; }
        .payment-method-item.selected { border-color: #667eea; background: #f0f4ff; }
        .payment-method-item label { cursor: pointer; display: flex; align-items: center; gap: 10px; margin: 0; }
        .payment-method-item .payment-label { font-weight: 600; }
        .payment-method-item .payment-desc { font-size: 12px; color: #888; margin-top: 5px; }
        .bank-info { display: none; background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 10px; font-size: 14px; line-height: 2; }
        .bank-info.show { display: block; }
        .bank-info b { color: #e74c3c; }
        .summary-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; }
        .summary-row.total { border-bottom: none; font-weight: 700; font-size: 20px; color: #e74c3c; margin-top: 10px; }
        .btn-confirm { width: 100%; padding: 15px; background: #e74c3c; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; }
        .btn-confirm:hover { background: #c0392b; }
        .btn-confirm:disabled { opacity: 0.6; cursor: not-allowed; }
        .message { padding: 12px; border-radius: 8px; margin-bottom: 15px; display: none; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .required { color: red; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    
    <div class="checkout-container">
        
        <div id="msgBox" class="message"></div>
        
        <div class="checkout-content">
            <div class="checkout-form">
                <h4 class="mb-4"><i class="fas fa-map-marker-alt me-2"></i>Thông tin giao hàng</h4>
                
                <div class="form-group">
                    <label>Họ và tên <span class="required">*</span></label>
                    <input type="text" id="fullName" value="<%= user.getFull_name() != null ? user.getFull_name() : "" %>">
                </div>
                <div class="form-group">
                    <label>Số điện thoại <span class="required">*</span></label>
                    <input type="tel" id="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                </div>
                <div class="form-group">
                    <label>Địa chỉ giao hàng <span class="required">*</span></label>
                    <input type="text" id="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố">
                </div>
                <div class="form-group">
                    <label>Ghi chú</label>
                    <textarea id="note" placeholder="Ghi chú về đơn hàng (nếu có)"></textarea>
                </div>
                
                <div class="section-title mt-4">
                    <i class="fas fa-wallet me-2"></i>Phương thức thanh toán
                </div>
                
                <div class="payment-method-item selected" id="payCod" onclick="chonPhuongThuc('cod')">
                    <label>
                        <i class="fas fa-money-bill-wave me-2"></i>
                        <span class="payment-label">Thanh toán khi nhận hàng (COD)</span>
                    </label>
                    <div class="payment-desc">Trả tiền mặt khi nhận được hàng</div>
                </div>
                
                <div class="payment-method-item" id="payBank" onclick="chonPhuongThuc('bank')">
                    <label>
                        <i class="fas fa-university me-2"></i>
                        <span class="payment-label">Chuyển khoản ngân hàng</span>
                    </label>
                    <div class="payment-desc">Thanh toán qua tài khoản ngân hàng</div>
                </div>
                
                <div class="bank-info" id="bankInfo">
                    <p><strong>Thông tin chuyển khoản:</strong></p>
                    <p>Ngân hàng: <b>Vietcombank</b></p>
                    <p>Số tài khoản: <b>1234567890</b></p>
                    <p>Chủ tài khoản: <b>PHAN SY TU</b></p>
                    <p>Số tiền: <b style="font-size: 20px;"><%= cart.getFormattedTotalPrice() %></b></p>
                    <p>Nội dung: <b style="color: #dc3545;">ThanhToan_Ten_SDT</b></p>
                </div>
            </div>
            
            <div class="checkout-summary">
                <h5 class="mb-3"><i class="fas fa-shopping-bag me-2"></i>Đơn hàng của bạn</h5>
                
                <% for (CartItem item : cart.getItems()) { %>
                    <div class="summary-row">
                        <span><%= item.getProductName() %> <span style="color:#888;font-size:12px;">x<%= item.getQuantity() %></span></span>
                        <span><%= item.getFormattedSubtotal() %></span>
                    </div>
                <% } %>
                
                <div class="summary-row total">
                    <span>Tổng tiền:</span>
                    <span><%= cart.getFormattedTotalPrice() %></span>
                </div>
                
                <button class="btn-confirm" id="confirmBtn" onclick="xacNhanDatHang()">
                    <i class="fas fa-lock me-2"></i>Xác nhận đặt hàng
                </button>
                
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary w-100 mt-2">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại giỏ hàng
                </a>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/includes/footer.jsp" />

    <script>
        // KHÔNG dùng const/let, dùng var để tránh xung đột với header
        var _ctx = '${pageContext.request.contextPath}';
        var _payment = 'cod';
        
        function chonPhuongThuc(type) {
            _payment = type;
            
            document.getElementById('payCod').classList.remove('selected');
            document.getElementById('payBank').classList.remove('selected');
            
            if (type === 'cod') {
                document.getElementById('payCod').classList.add('selected');
                document.getElementById('bankInfo').classList.remove('show');
            } else {
                document.getElementById('payBank').classList.add('selected');
                document.getElementById('bankInfo').classList.add('show');
            }
        }
        
        function hienThongBao(msg, type) {
            var div = document.getElementById('msgBox');
            div.textContent = msg;
            div.className = 'message ' + type;
            div.style.display = 'block';
            window.scrollTo(0, 0);
        }
        
        function xacNhanDatHang() {
            var fullName = document.getElementById('fullName').value.trim();
            var phone = document.getElementById('phone').value.trim();
            var address = document.getElementById('address').value.trim();
            var note = document.getElementById('note').value.trim();
            
            if (!fullName) { hienThongBao('Vui lòng nhập họ tên!', 'error'); return; }
            if (!phone) { hienThongBao('Vui lòng nhập số điện thoại!', 'error'); return; }
            if (!address) { hienThongBao('Vui lòng nhập địa chỉ!', 'error'); return; }
            
            var btn = document.getElementById('confirmBtn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            
            // Dùng XMLHttpRequest thay vì fetch để tránh lỗi
            var xhr = new XMLHttpRequest();
            xhr.open('POST', _ctx + '/checkout', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            xhr.onload = function() {
                try {
                    var data = JSON.parse(xhr.responseText);
                    if (data.success) {
                        hienThongBao(data.message, 'success');
                        btn.innerHTML = '<i class="fas fa-check me-2"></i>Thành công!';
                        setTimeout(function() {
                            window.location.href = _ctx + '/order-confirmation?orderId=' + data.orderId;
                        }, 1500);
                    } else {
                        hienThongBao(data.message, 'error');
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fas fa-lock me-2"></i>Xác nhận đặt hàng';
                    }
                } catch(e) {
                    hienThongBao('Lỗi: ' + xhr.responseText, 'error');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-lock me-2"></i>Xác nhận đặt hàng';
                }
            };
            
            xhr.onerror = function() {
                hienThongBao('Không thể kết nối đến server!', 'error');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-lock me-2"></i>Xác nhận đặt hàng';
            };
            
            var params = 'fullName=' + encodeURIComponent(fullName) +
                         '&phone=' + encodeURIComponent(phone) +
                         '&address=' + encodeURIComponent(address) +
                         '&note=' + encodeURIComponent(note) +
                         '&paymentMethod=' + _payment;
            
            xhr.send(params);
        }
    </script>
</body>
</html>