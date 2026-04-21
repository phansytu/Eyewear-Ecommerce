<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<%-- Bảo vệ trang: Kiểm tra nếu chưa đăng nhập HOẶC không phải admin thì đá ra ngoài --%>
<c:if test="${empty sessionScope.user or sessionScope.role ne 'admin'}">
    <c:redirect url="/login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Kính Mắt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f4f6f9; }
        .sidebar { 
            height: 100vh; 
            background: #343a40; 
            color: #fff; 
            position: fixed; 
            width: 260px;
            overflow-y: auto;
        }
        .sidebar a { 
            color: #c2c7d0; 
            text-decoration: none; 
            padding: 12px 20px; 
            display: block; 
            transition: 0.3s;
        }
        .sidebar a:hover, .sidebar a.active { 
            background: #007bff; 
            color: #fff; 
        }
        .main-content { 
            margin-left: 260px; 
            padding: 20px; 
        }
        .stat-card { 
            border-left: 4px solid; 
            border-radius: 8px; 
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            font-size: 2.5rem;
            opacity: 0.3;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-pending { background-color: #ffc107; color: #856404; }
        .status-confirmed { background-color: #17a2b8; color: #fff; }
        .status-shipping { background-color: #007bff; color: #fff; }
        .status-delivered { background-color: #28a745; color: #fff; }
        .status-cancelled { background-color: #dc3545; color: #fff; }
    </style>
</head>
<body>

    <div class="sidebar pt-3">
        <h4 class="text-center mb-4">
            <i class="fas fa-crown text-warning"></i> ADMIN PANEL
        </h4>
        <div class="px-3 mb-3 d-flex align-items-center border-bottom pb-3">
            <i class="fas fa-user-circle fa-2x me-2 text-secondary"></i>
            <div>
                <div>${sessionScope.user.full_name != null ? sessionScope.user.full_name : sessionScope.user.username}</div>
                <small class="text-secondary">Administrator</small>
            </div>
        </div>
        <a href="${root}/admin/dashboard" class="active">
            <i class="fas fa-tachometer-alt me-2"></i> Tổng quan
        </a>
        <a href="${root}/admin/products">
            <i class="fas fa-box me-2"></i> Quản lý sản phẩm
        </a>
        <a href="${root}/category">
            <i class="fas fa-list me-2"></i> Quản lý danh mục
        </a>
        <a href="${root}/admin/orders">
            <i class="fas fa-shopping-cart me-2"></i> Quản lý đơn hàng
        </a>
        <a href="${root}/admin/users">
            <i class="fas fa-users me-2"></i> Quản lý người dùng
        </a>
        <a href="${root}/admin/reports">
            <i class="fas fa-chart-line me-2"></i> Báo cáo thống kê
        </a>
        <a href="${root}/logout" class="text-danger mt-5">
            <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
        </a>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-tachometer-alt me-2 text-primary"></i>Bảng điều khiển</h2>
            <div>
                <span class="text-muted me-3">
                    <i class="far fa-calendar-alt me-1"></i>
                    <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy"/>
                </span>
                <a href="${root}/home" class="btn btn-outline-primary btn-sm">
                    <i class="fas fa-external-link-alt"></i> Trang chủ
                </a>
            </div>
        </div>

        <!-- Thống kê cards -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-primary">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Tổng Doanh Thu</h6>
                                <h3 class="text-primary mb-0">
                                    <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/>₫
                                </h3>
                                <small class="text-muted">Đã giao & thanh toán</small>
                            </div>
                            <div class="stat-icon text-primary">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-warning">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Đơn hàng mới</h6>
                                <h3 class="text-warning mb-0">${pendingOrders} Đơn</h3>
                                <small class="text-muted">Chờ xử lý</small>
                            </div>
                            <div class="stat-icon text-warning">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-success">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Đã giao thành công</h6>
                                <h3 class="text-success mb-0">${deliveredOrders} Đơn</h3>
                                <small class="text-muted">Hoàn thành</small>
                            </div>
                            <div class="stat-icon text-success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-info">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Khách hàng</h6>
                                <h3 class="text-info mb-0">${totalUsers}</h3>
                                <small class="text-muted">Người dùng</small>
                            </div>
                            <div class="stat-icon text-info">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thống kê bổ sung -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-secondary">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Sản phẩm</h6>
                                <h3 class="text-secondary mb-0">${totalProducts}</h3>
                                <small class="text-muted">Đang bán</small>
                            </div>
                            <div class="stat-icon text-secondary">
                                <i class="fas fa-box"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-danger">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Đã hủy</h6>
                                <h3 class="text-danger mb-0">${cancelledOrders} Đơn</h3>
                                <small class="text-muted">Đơn hủy</small>
                            </div>
                            <div class="stat-icon text-danger">
                                <i class="fas fa-times-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-primary">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Đang giao</h6>
                                <h3 class="text-primary mb-0">${shippingOrders} Đơn</h3>
                                <small class="text-muted">Đang vận chuyển</small>
                            </div>
                            <div class="stat-icon text-primary">
                                <i class="fas fa-truck"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-success">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted">Tổng đơn hàng</h6>
                                <h3 class="text-success mb-0">${totalOrders} Đơn</h3>
                                <small class="text-muted">Tất cả đơn</small>
                            </div>
                            <div class="stat-icon text-success">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3">
            <!-- Biểu đồ doanh thu -->
            <div class="col-md-7">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2 text-primary"></i>Doanh thu theo tháng</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="revenueChart" height="250"></canvas>
                    </div>
                </div>
            </div>

            <!-- Top sản phẩm bán chạy -->
            <div class="col-md-5">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0"><i class="fas fa-fire me-2 text-warning"></i>Top sản phẩm bán chạy</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th class="text-center">Đã bán</th>
                                    <th class="text-end">Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${topProducts}">
                                    <tr>
                                        <td>${product[1]}</td>
                                        <td class="text-center">${product[2]}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${product[3]}" pattern="#,##0"/>₫
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty topProducts}">
                                    <tr>
                                        <td colspan="3" class="text-center text-muted py-4">
                                            Chưa có dữ liệu
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Đơn hàng gần đây -->
        <div class="card shadow-sm border-0 mt-4">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-clock me-2 text-primary"></i>Đơn hàng gần đây</h5>
                <a href="${root}/admin/orders" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Mã ĐH</th>
                                <th>Khách hàng</th>
                                <th>Ngày đặt</th>
                                <th>SĐT</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thanh toán</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>${order.userId}</td>
                                    <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>${order.phone}</td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>₫</td>
                                    <td>
                                        <span class="status-badge status-${order.status}">
                                            ${order.statusText}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${order.paymentStatus == 'paid' ? 'bg-success' : 'bg-secondary'}">
                                            ${order.paymentStatus == 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${root}/admin/order-detail?id=${order.id}" class="btn btn-sm btn-info text-white">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">
                                        Chưa có đơn hàng nào
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Biểu đồ doanh thu
        const ctx = document.getElementById('revenueChart').getContext('2d');
        
        <c:set var="months" value=""/>
        <c:set var="revenues" value=""/>
        <c:forEach var="item" items="${monthlyRevenue}" varStatus="status">
            <c:set var="months" value="${months}${item[1]}/${item[0]}${!status.last ? ',' : ''}"/>
            <c:set var="revenues" value="${revenues}${item[2]}${!status.last ? ',' : ''}"/>
        </c:forEach>
        
        const monthLabels = [<c:forEach var="item" items="${monthlyRevenue}" varStatus="status">"${item[1]}/${item[0]}"${!status.last ? ',' : ''}</c:forEach>];
        const revenueData = [<c:forEach var="item" items="${monthlyRevenue}" varStatus="status">${item[2]}${!status.last ? ',' : ''}</c:forEach>];
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: monthLabels.length > 0 ? monthLabels : ['Chưa có dữ liệu'],
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: revenueData.length > 0 ? revenueData : [0],
                    backgroundColor: 'rgba(0, 123, 255, 0.5)',
                    borderColor: 'rgba(0, 123, 255, 1)',
                    borderWidth: 1,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + '₫';
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.raw.toLocaleString('vi-VN') + '₫';
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>