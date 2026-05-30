<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

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
        body { background: #f5f5f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .payment-wrapper { max-width: 600px; margin: 50px auto; }
        .payment-card { background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); overflow: hidden; }
        .payment-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center; color: white; }
        .payment-header .icon-circle { width: 80px; height: 80px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; font-size: 36px; }
        .payment-header h4 { margin: 0; font-weight: 700; }
        .payment-body { padding: 30px; }
        .order-info { background: #f8f9fa; border-radius: 10px; padding: 20px; margin: 20px 0; text-align: left; }
        .order-info .info-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
        .order-info .info-row:last-child { border: none; }
        
        /* Payment Method Styles */
        .payment-method { border: 1px solid #e0e0e0; border-radius: 12px; padding: 16px; margin-bottom: 16px; cursor: pointer; transition: all 0.3s; background: white; }
        .payment-method:hover { border-color: #667eea; background: #f8f9ff; }
        .payment-method.active { border-color: #667eea; background: #f0f3ff; box-shadow: 0 2px 8px rgba(102,126,234,0.1); }
        .payment-method-radio { width: 20px; height: 20px; accent-color: #667eea; margin-right: 12px; }
        .payment-method-icon { width: 45px; height: 45px; background: #f5f5f5; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 15px; font-size: 20px; }
        .payment-method.cod .payment-method-icon { color: #28a745; }
        .payment-method.payos .payment-method-icon { color: #e74c3c; }
        
        .btn-pay { padding: 14px 40px; background: #e74c3c; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s; width: 100%; }
        .btn-pay:hover { background: #c0392b; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(231,76,60,0.3); }
        .btn-pay:disabled { background: #ccc; cursor: not-allowed; transform: none; }
        .btn-back { padding: 12px 30px; background: white; color: #667eea; border: 2px solid #667eea; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s; }
        .btn-back:hover { background: #667eea; color: white; }
        
        .loading { display: inline-block; width: 20px; height: 20px; border: 2px solid #fff; border-radius: 50%; border-top-color: transparent; animation: spin 0.6s linear infinite; margin-right: 8px; }
        @keyframes spin { to { transform: rotate(360deg); } }
        
        .qr-code { text-align: center; padding: 20px; background: #f8f9fa; border-radius: 12px; margin-top: 20px; display: none; }
        .qr-code img { max-width: 200px; margin: 10px auto; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="payment-wrapper">
    <div class="payment-card">
        <div class="payment-header">
            <div class="icon-circle">
                <i class="fas fa-credit-card"></i>
            </div>
            <h4>Thanh toán đơn hàng</h4>
            <p class="mb-0 opacity-75">Mã đơn: #${orderId}</p>
        </div>
        <div class="payment-body">
            <!-- Chọn phương thức thanh toán -->
            <h6 class="mb-3">Chọn phương thức thanh toán</h6>
            
            <!-- Phương thức COD -->
            <div class="payment-method cod d-flex align-items-center" data-method="cod" onclick="selectMethod('cod')">
                <div class="payment-method-icon">
                    <i class="fas fa-money-bill-wave"></i>
                </div>
                <div class="flex-grow-1">
                    <strong>Thanh toán khi nhận hàng (COD)</strong>
                    <p class="text-muted small mb-0">Thanh toán bằng tiền mặt khi nhận hàng</p>
                </div>
                <input type="radio" name="paymentMethod" class="payment-method-radio" value="cod" checked>
            </div>
            
            <!-- Phương thức PayOS -->
            <div class="payment-method payos d-flex align-items-center" data-method="payos" onclick="selectMethod('payos')">
                <div class="payment-method-icon">
                    <i class="fas fa-qrcode"></i>
                </div>
                <div class="flex-grow-1">
                    <strong>Thanh toán qua PayOS (VietQR)</strong>
                    <p class="text-muted small mb-0">Quét mã QR thanh toán qua ngân hàng</p>
                </div>
                <input type="radio" name="paymentMethod" class="payment-method-radio" value="payos">
            </div>
            
            <!-- Thông tin đơn hàng -->
            <div class="order-info mt-4">
                <div class="info-row">
                    <span>Mã đơn hàng</span>
                    <strong>#${orderId}</strong>
                </div>
                <div class="info-row">
                    <span>Phương thức</span>
                    <strong id="selectedMethodLabel">Thanh toán khi nhận hàng (COD)</strong>
                </div>
                <div class="info-row">
                    <span>Trạng thái</span>
                    <strong style="color: #ff9800;">Chờ thanh toán</strong>
                </div>
            </div>
            
            <!-- QR Code (hiển thị khi chọn PayOS) -->
            <div id="qrContainer" class="qr-code">
                <i class="fas fa-qrcode fa-3x text-muted mb-2"></i>
                <p>Quét mã QR để thanh toán</p>
                <div id="qrLoading" class="text-muted">Đang tạo mã QR...</div>
                <img id="qrImage" src="" style="display: none;">
                <p id="qrExpiry" class="small text-muted mt-2"></p>
            </div>
            
            <!-- Nút hành động -->
            <div class="mt-4">
                <button class="btn-pay" id="payBtn" onclick="processPayment()">
                    <i class="fas fa-check me-2"></i>Xác nhận thanh toán
                </button>
            </div>
            
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/orders" class="btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại đơn hàng
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    let selectedMethod = 'cod';
    let payosLink = null;
    
    // Chọn phương thức thanh toán
    function selectMethod(method) {
        selectedMethod = method;
        
        // Cập nhật UI
        document.querySelectorAll('.payment-method').forEach(el => {
            el.classList.remove('active');
        });
        document.querySelector(`.payment-method.${method}`).classList.add('active');
        document.querySelectorAll('.payment-method-radio').forEach(radio => {
            radio.checked = radio.value === method;
        });
        
        // Cập nhật label
        const methodLabel = method === 'cod' ? 'Thanh toán khi nhận hàng (COD)' : 'Thanh toán qua PayOS (VietQR)';
        document.getElementById('selectedMethodLabel').innerText = methodLabel;
        
        // Hiển thị/ẩn QR
        const qrContainer = document.getElementById('qrContainer');
        if (method === 'payos') {
            qrContainer.style.display = 'block';
            if (!payosLink) {
                createPayOSLink();
            }
        } else {
            qrContainer.style.display = 'none';
        }
    }
    
    // Tạo link thanh toán PayOS (gọi AJAX)
    function createPayOSLink() {
        const qrLoading = document.getElementById('qrLoading');
        const qrImage = document.getElementById('qrImage');
        const qrExpiry = document.getElementById('qrExpiry');
        
        qrLoading.style.display = 'block';
        qrImage.style.display = 'none';
        
        const fd = new URLSearchParams();
        fd.append('action', 'createPayOSLink');
        fd.append('orderId', '${orderId}');
        
        fetch('${pageContext.request.contextPath}/payment', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: fd
        })
        .then(r => r.json())
        .then(data => {
            qrLoading.style.display = 'none';
            
            if (data.success) {
                payosLink = data.checkoutUrl;
                // Hiển thị QR code từ link (có thể dùng API tạo QR)
                qrImage.src = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(payosLink)}`;
                qrImage.style.display = 'block';
                qrExpiry.innerText = 'Mã QR có hiệu lực trong 15 phút';
            } else {
                qrImage.style.display = 'none';
                qrLoading.innerHTML = '<span class="text-danger">❌ ' + data.message + '</span>';
            }
        })
        .catch(error => {
            qrLoading.style.display = 'none';
            qrLoading.innerHTML = '<span class="text-danger">❌ Lỗi kết nối server</span>';
            console.error('Error:', error);
        });
    }
    
    // Xử lý thanh toán
    function processPayment() {
        if (selectedMethod === 'cod') {
            // Thanh toán COD
            if (!confirm('Xác nhận thanh toán đơn hàng #${orderId} bằng COD?')) return;
            
            const fd = new URLSearchParams();
            fd.append('action', 'pay');
            fd.append('orderId', '${orderId}');
            
            fetch('${pageContext.request.contextPath}/payment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: fd
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    alert('✅ Thanh toán thành công!');
                    window.location.href = '${pageContext.request.contextPath}/orders';
                } else {
                    alert('❌ ' + data.message);
                }
            })
            .catch(error => {
                alert('❌ Có lỗi xảy ra!');
                console.error('Error:', error);
            });
            
        } else if (selectedMethod === 'payos') {
            // Thanh toán qua PayOS - chuyển hướng
            if (payosLink) {
                window.location.href = payosLink;
            } else {
                alert('Đang tạo link thanh toán, vui lòng thử lại!');
                createPayOSLink();
            }
        }
    }
    
    // Mặc định chọn COD
    selectMethod('cod');
</script>
</body>
</html>