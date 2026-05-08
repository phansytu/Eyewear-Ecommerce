<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f5f5f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        .confirmation-wrapper {
            max-width: 700px;
            margin: 50px auto;
            padding: 0 15px;
        }
        
        .confirmation-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .confirmation-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }
        
        .confirmation-header .icon-circle {
            width: 90px;
            height: 90px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 45px;
        }
        
        .confirmation-header h2 {
            font-size: 28px;
            margin-bottom: 5px;
            font-weight: 700;
        }
        
        .confirmation-header p {
            opacity: 0.9;
            margin: 0;
        }
        
        .confirmation-body {
            padding: 35px 30px;
            text-align: center;
        }
        
        .order-number {
            font-size: 32px;
            font-weight: 800;
            color: #667eea;
            margin: 15px 0;
            letter-spacing: 2px;
        }
        
        .order-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 25px 0;
            text-align: left;
        }
        
        .order-info .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        
        .order-info .info-row:last-child {
            border-bottom: none;
        }
        
        .order-info .info-row .label {
            color: #888;
        }
        
        .order-info .info-row .value {
            font-weight: 600;
            color: #333;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 25px;
            flex-wrap: wrap;
        }
        
        .btn-primary-custom {
            padding: 14px 35px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-outline-custom {
            padding: 14px 35px;
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-outline-custom:hover {
            background: #667eea;
            color: white;
        }
        
        .support-text {
            margin-top: 25px;
            font-size: 13px;
            color: #999;
        }
        
        .support-text i {
            color: #667eea;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    
    <div class="confirmation-wrapper">
        <div class="confirmation-card">
            <!-- Header -->
            <div class="confirmation-header">
                <div class="icon-circle">
                    <i class="fas fa-check"></i>
                </div>
                <h2>Đặt hàng thành công!</h2>
                <p>Cảm ơn bạn đã tin tưởng mua sắm tại TuKhanhHuy</p>
            </div>
            
            <!-- Body -->
            <div class="confirmation-body">
                <p style="color: #666; margin: 0;">Mã đơn hàng của bạn</p>
                <div class="order-number">#${orderId}</div>
                
                <div class="order-info">
                    <div class="info-row">
                        <span class="label"><i class="fas fa-box me-2"></i>Trạng thái</span>
                        <span class="value" style="color: #ffc107;">Chờ xác nhận</span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-credit-card me-2"></i>Thanh toán</span>
                        <span class="value">Thanh toán khi nhận hàng (COD)</span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-truck me-2"></i>Giao hàng</span>
                        <span class="value">Dự kiến 3-5 ngày</span>
                    </div>
                </div>
                
                <p style="color: #666; font-size: 14px;">
                    Chúng tôi sẽ liên hệ với bạn qua số điện thoại để xác nhận đơn hàng.
                </p>
                
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/orders" class="btn-primary-custom">
                        <i class="fas fa-list me-2"></i>Xem đơn hàng của tôi
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn-outline-custom">
                        <i class="fas fa-shopping-bag me-2"></i>Tiếp tục mua sắm
                    </a>
                </div>
                
                <p class="support-text">
                    <i class="fas fa-headset"></i> Cần hỗ trợ? Liên hệ hotline: <strong>1900 1234</strong>
                </p>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>