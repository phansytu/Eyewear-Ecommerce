<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        .payment-body { padding: 30px; text-align: center; }
        .order-info { background: #f8f9fa; border-radius: 10px; padding: 20px; margin: 20px 0; text-align: left; }
        .order-info .info-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
        .order-info .info-row:last-child { border: none; }
        .btn-pay { padding: 14px 40px; background: #e74c3c; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s; }
        .btn-pay:hover { background: #c0392b; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(231,76,60,0.3); }
        .btn-back { padding: 14px 40px; background: white; color: #667eea; border: 2px solid #667eea; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s; }
        .btn-back:hover { background: #667eea; color: white; }
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
            <i class="fas fa-shield-alt text-success" style="font-size: 50px;"></i>
            <h5 class="mt-3">Thanh toán an toàn</h5>
            <p class="text-muted">Xác nhận thanh toán để hoàn tất đơn hàng</p>
            
            <div class="order-info">
                <div class="info-row">
                    <span>Mã đơn hàng</span>
                    <strong>#${orderId}</strong>
                </div>
                <div class="info-row">
                    <span>Phương thức</span>
                    <strong>Thanh toán khi nhận hàng (COD)</strong>
                </div>
                <div class="info-row">
                    <span>Trạng thái</span>
                    <strong style="color: #ff9800;">Chờ thanh toán</strong>
                </div>
            </div>
            
            <div class="d-flex justify-content-center gap-3 mt-4">
                <button class="btn-pay" onclick="confirmPayment()">
                    <i class="fas fa-check me-2"></i>Xác nhận thanh toán
                </button>
                <a href="${pageContext.request.contextPath}/orders" class="btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    function confirmPayment() {
        if (!confirm('Xác nhận thanh toán đơn hàng #${orderId}?')) return;
        
        var fd = new URLSearchParams();
        fd.append('action', 'pay');
        fd.append('orderId', '${orderId}');
        
        fetch('${pageContext.request.contextPath}/payment', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: fd
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                alert('✅ Thanh toán thành công!');
                window.location.href = '${pageContext.request.contextPath}/orders';
            } else {
                alert('❌ ' + data.message);
            }
        });
    }
</script>
</body>
</html>