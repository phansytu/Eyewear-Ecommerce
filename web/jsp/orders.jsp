<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn mua của tôi - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${root}/css/style.css">
    <style>
        body { background-color: #f5f5f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        /* Order Tabs */
        .order-tabs { background: white; display: flex; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); border-radius: 8px; margin-bottom: 20px; overflow-x: auto;}
        .order-tab-item { flex: 1; text-align: center; padding: 15px 0; cursor: pointer; color: rgba(0,0,0,.8); text-decoration: none; border-bottom: 2px solid transparent; white-space: nowrap;}
        .order-tab-item:hover { color: #e11b1b; }
        .order-tab-item.active { color: #e11b1b; border-bottom: 2px solid #e11b1b; }
        
        /* Order Card */
        .order-card { background: white; border-radius: 12px; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); margin-bottom: 20px; overflow: hidden; }
        .shop-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid #efefef; }
        .shop-name { font-weight: 600; color: #333; text-decoration: none; display: flex; align-items: center; gap: 8px;}
        .order-status { font-weight: 500; font-size: 14px; }
        .order-status.pending { color: #ff9800; }
        .order-status.confirmed { color: #2196f3; }
        .order-status.shipping { color: #00bcd4; }
        .order-status.delivered { color: #4caf50; }
        .order-status.cancelled { color: #f44336; }
        
        .product-item { display: flex; align-items: center; padding: 16px 20px; border-bottom: 1px solid #f5f5f5; }
        .product-img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; margin-right: 16px; }
        .product-info { flex: 1; }
        .product-name { font-size: 16px; font-weight: 500; color: #333; margin-bottom: 5px; }
        .product-variant { font-size: 13px; color: #999; margin-bottom: 5px; }
        .product-quantity { font-size: 13px; color: #666; }
        .product-price { text-align: right; }
        .current-price { color: #e11b1b; font-size: 18px; font-weight: 600; }
        
        .order-footer { padding: 16px 20px; border-top: 1px solid #efefef; display: flex; justify-content: flex-end; align-items: center; gap: 20px; flex-wrap: wrap; }
        .total-section { text-align: right; }
        .total-label { font-size: 14px; color: #666; }
        .total-price { color: #e11b1b; font-size: 22px; font-weight: 700; margin-left: 10px; }
        .action-buttons { display: flex; gap: 12px; }
        .btn-buy-again { background-color: #e11b1b; color: white; border: none; padding: 8px 24px; border-radius: 4px; text-decoration: none; font-weight: 500; }
        .btn-buy-again:hover { background-color: #c41717; color: white; }
        .btn-contact { background-color: white; border: 1px solid #ddd; color: #333; padding: 8px 24px; border-radius: 4px; text-decoration: none; }
        .btn-contact:hover { background: #f5f5f5; }
        .btn-cancel { background-color: white; border: 1px solid #ddd; color: #f44336; padding: 8px 24px; border-radius: 4px; text-decoration: none; }
        .btn-cancel:hover { background: #ffebee; }
        
        .empty-orders { text-align: center; padding: 60px 20px; background: white; border-radius: 12px; }
        .empty-orders i { font-size: 64px; color: #ddd; margin-bottom: 20px; }
        
        /* Sidebar */
        .sidebar-profile { background: white; border-radius: 12px; padding: 20px; position: sticky; top: 80px; }
        .sidebar-item { padding: 10px 0; cursor: pointer; color: #555; text-decoration: none; display: block; font-weight: 500; transition: 0.2s; }
        .sidebar-item:hover, .sidebar-item.active { color: #e11b1b; }
        .sidebar-icon { width: 24px; text-align: center; margin-right: 8px; }
        
        @media (max-width: 768px) {
            .product-item { flex-wrap: wrap; }
            .product-price { margin-top: 10px; text-align: left; }
            .order-footer { flex-direction: column; align-items: stretch; }
            .action-buttons { justify-content: center; }
            .total-section { text-align: center; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="container py-4">
    <div class="row g-4">
        <!-- Sidebar -->
        <div class="col-md-3">
            <div class="sidebar-profile">
                <div class="d-flex align-items-center mb-4 pb-2 border-bottom">
                    <img src="${not empty sessionScope.user.avatar ? sessionScope.user.avatar : 'https://ui-avatars.com/api/?name='.concat(sessionScope.user.username).concat('&background=e11b1b&color=fff')}" 
                         class="rounded-circle me-3" width="50" height="50" style="object-fit: cover;">
                    <div>
                        <div class="fw-bold">${sessionScope.user.full_name != null ? sessionScope.user.full_name : sessionScope.user.username}</div>
                        <small class="text-muted">${sessionScope.user.email}</small>
                    </div>
                </div>
                
                <a href="${root}/profile" class="sidebar-item">
                    <i class="fas fa-user-circle sidebar-icon"></i> Hồ sơ của tôi
                </a>
                <a href="${root}/orders" class="sidebar-item active">
                    <i class="fas fa-clipboard-list sidebar-icon"></i> Đơn mua
                </a>
                <c:if test="${sessionScope.user.role eq 'admin'}">
                    <a href="${root}/admin/dashboard" class="sidebar-item">
                        <i class="fas fa-shield-alt sidebar-icon"></i> Quản trị hệ thống
                    </a>
                </c:if>
                <hr class="my-2">
                <a href="${root}/logout" class="sidebar-item text-danger">
                    <i class="fas fa-sign-out-alt sidebar-icon"></i> Đăng xuất
                </a>
            </div>
        </div>
        
        <!-- Orders Main Content -->
        <div class="col-md-9">
            <!-- Order Tabs -->
            <div class="order-tabs">
                <a href="${root}/orders?type=all" class="order-tab-item ${activeTab == 'all' ? 'active' : ''}">Tất cả</a>
                <a href="${root}/orders?type=wait_pay" class="order-tab-item ${activeTab == 'wait_pay' ? 'active' : ''}">Chờ thanh toán</a>
                <a href="${root}/orders?type=confirmed" class="order-tab-item ${activeTab == 'confirmed' ? 'active' : ''}">Đã xác nhận</a>
                <a href="${root}/orders?type=shipping" class="order-tab-item ${activeTab == 'shipping' ? 'active' : ''}">Đang giao</a>
                <a href="${root}/orders?type=completed" class="order-tab-item ${activeTab == 'completed' ? 'active' : ''}">Hoàn thành</a>
                <a href="${root}/orders?type=cancelled" class="order-tab-item ${activeTab == 'cancelled' ? 'active' : ''}">Đã hủy</a>
            </div>
            
            <!-- Orders List -->
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-orders">
                        <i class="fas fa-box-open"></i>
                        <h5>Bạn chưa có đơn hàng nào</h5>
                        <p class="text-muted">Hãy mua sắm ngay để có trải nghiệm tuyệt vời!</p>
                        <a href="${root}/home" class="btn btn-danger mt-3">Mua sắm ngay</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <!-- Shop Header -->
                            <div class="shop-header">
                                <div class="shop-name">
                                    <i class="fas fa-store text-primary"></i>
                                    <span>TuKhanhHuy Official Store</span>
                                </div>
                                <div class="order-status ${order.status}">
                                    <c:choose>
                                        <c:when test="${order.status == 'pending'}">
                                            <i class="fas fa-clock me-1"></i>Chờ thanh toán
                                        </c:when>
                                        <c:when test="${order.status == 'confirmed'}">
                                            <i class="fas fa-check-circle me-1"></i>Đã xác nhận
                                        </c:when>
                                        <c:when test="${order.status == 'shipping'}">
                                            <i class="fas fa-truck me-1"></i>Đang giao hàng
                                        </c:when>
                                        <c:when test="${order.status == 'delivered'}">
                                            <i class="fas fa-check-circle me-1"></i>Giao hàng thành công
                                        </c:when>
                                        <c:when test="${order.status == 'cancelled'}">
                                            <i class="fas fa-times-circle me-1"></i>Đã hủy
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <!-- Products -->
                            <c:forEach var="detail" items="${order.orderDetails}">
                                <div class="product-item">
                                    <img src="${root}${detail.productImage != null ? detail.productImage : '/image/anhdanhmuc/no-image.png'}" 
                                         class="product-img" 
                                         onerror="this.src='${root}/image/anhdanhmuc/no-image.png'">
                                    <div class="product-info">
                                        <div class="product-name">${detail.productName}</div>
                                        <c:if test="${not empty detail.variantName}">
                                            <div class="product-variant">Phân loại: ${detail.variantName}</div>
                                        </c:if>
                                        <div class="product-quantity">x${detail.quantity}</div>
                                    </div>
                                    <div class="product-price">
                                        <div class="current-price">
                                            <fmt:formatNumber value="${detail.price}" pattern="#,###"/>₫
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Order Footer -->
                            <div class="order-footer">
                                <div class="total-section">
                                    <span class="total-label">Tổng số tiền (${fn:length(order.orderDetails)} sản phẩm):</span>
                                    <span class="total-price">
                                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>₫
                                    </span>
                                </div>
                                <div class="action-buttons">
                                    <c:if test="${order.status == 'pending'}">
                                        <a href="${root}/payment?orderId=${order.id}" class="btn-buy-again">
                                            <i class="fas fa-credit-card me-2"></i>Thanh toán ngay
                                        </a>
                                        <button class="btn-cancel" onclick="cancelOrder(${order.id})">
                                            <i class="fas fa-times me-2"></i>Hủy đơn
                                        </button>
                                    </c:if>
                                    
                                    <c:if test="${order.status == 'confirmed'}">
                                        <button class="btn-cancel" onclick="cancelOrder(${order.id})">
                                            <i class="fas fa-times me-2"></i>Hủy đơn
                                        </button>
                                    </c:if>
                                    
                                    <c:if test="${order.status == 'delivered'}">
                                        <a href="${root}/product?review=${order.id}" class="btn-buy-again">
                                            <i class="fas fa-star me-2"></i>Đánh giá
                                        </a>
                                    </c:if>
                                    
                                    <c:if test="${order.status != 'cancelled' && order.status != 'delivered'}">
                                        <a href="#" class="btn-contact">
                                            <i class="fas fa-headset me-2"></i>Liên hệ
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${root}';
    
    async function cancelOrder(orderId) {
        if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')) {
            try {
                const response = await fetch(contextPath + '/cart', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ action: 'cancelOrder', orderId: orderId })
                });
                const data = await response.json();
                if (data.success) {
                    alert('Đã hủy đơn hàng thành công!');
                    location.reload();
                } else {
                    alert(data.message || 'Hủy đơn hàng thất bại!');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('Có lỗi xảy ra!');
            }
        }
    }
</script>
</body>
</html>