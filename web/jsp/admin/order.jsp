<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<%-- Bảo vệ trang admin --%>
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'admin'}">
    <c:redirect url="/login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn Hàng | Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .wrapper { display: flex; width: 100%; align-items: stretch; }
        .sidebar { min-width: 250px; max-width: 250px; background: #343a40; color: #fff; min-height: 100vh; position: sticky; top: 0; }
        .sidebar a { color: #c2c7d0; text-decoration: none; padding: 15px 20px; display: block; border-left: 3px solid transparent;}
        .sidebar a:hover, .sidebar a.active { background: #494e53; color: #fff; border-left: 3px solid #007bff; }
        .main-content { width: 100%; padding: 20px; }
        
        .card { border: none; border-radius: 8px; box-shadow: 0 0 15px rgba(0,0,0,.05); margin-bottom: 24px; }
        .stat-card { border-left: 4px solid; transition: transform 0.2s; cursor: pointer; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card.primary { border-color: #007bff; }
        .stat-card.warning { border-color: #ffc107; }
        .stat-card.info { border-color: #17a2b8; }
        .stat-card.success { border-color: #28a745; }
        .stat-card.danger { border-color: #dc3545; }
        
        .badge-pending { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .badge-confirmed { background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .badge-shipping { background-color: #cce5ff; color: #004085; border: 1px solid #b8daff; }
        .badge-delivered { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-cancelled { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .btn-action { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: none; }
        .product-img { width: 40px; height: 40px; object-fit: cover; border-radius: 4px; }
        
        .avatar-placeholder {
            width: 35px;
            height: 35px;
            background-color: #007bff;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="wrapper">
    <nav class="sidebar">
        <div class="p-4 fs-4 fw-bold text-center border-bottom border-secondary">
            <i class="fa-solid fa-glasses me-2 text-primary"></i>Admin Panel
        </div>
        <div class="mt-3">
            <a href="${root}/admin/dashboard"><i class="fa-solid fa-gauge me-3"></i>Tổng quan</a>
            <a href="${root}/admin/products"><i class="fa-solid fa-box me-3"></i>Sản phẩm</a>
            <a href="${root}/admin/orders" class="active"><i class="fa-solid fa-cart-shopping me-3"></i>Đơn hàng</a>
            <a href="${root}/admin/users"><i class="fa-solid fa-users me-3"></i>Khách hàng</a>
            <a href="${root}/logout" class="mt-5 text-danger"><i class="fa-solid fa-sign-out-alt me-3"></i>Đăng xuất</a>
        </div>
    </nav>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h3 mb-0 text-gray-800">Quản lý Đơn hàng</h2>
            <div>
                <a href="${root}/admin/orders" class="btn btn-outline-primary me-2">
                    <i class="fa-solid fa-rotate me-2"></i>Làm mới
                </a>
                <button class="btn btn-success shadow-sm" onclick="exportToExcel()">
                    <i class="fa-solid fa-file-excel me-2"></i>Xuất Excel
                </button>
            </div>
        </div>

        <!-- Thống kê đơn hàng -->
        <div class="row">
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card primary h-100 py-2" onclick="filterByStatus('all')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng đơn</div>
                        <div class="h5 mb-0 font-weight-bold">${listOrders.size()} Đơn</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card warning h-100 py-2" onclick="filterByStatus('pending')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Chờ xác nhận</div>
                        <div class="h5 mb-0 font-weight-bold">${pendingCount} Đơn</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card info h-100 py-2" onclick="filterByStatus('confirmed')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Đã xác nhận</div>
                        <div class="h5 mb-0 font-weight-bold">${confirmedCount} Đơn</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card primary h-100 py-2" onclick="filterByStatus('shipping')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Đang giao</div>
                        <div class="h5 mb-0 font-weight-bold">${shippingCount} Đơn</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card success h-100 py-2" onclick="filterByStatus('delivered')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Hoàn thành</div>
                        <div class="h5 mb-0 font-weight-bold">${deliveredCount} Đơn</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card danger h-100 py-2" onclick="filterByStatus('cancelled')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Đã hủy</div>
                        <div class="h5 mb-0 font-weight-bold">${cancelledCount} Đơn</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bộ lọc -->
        <div class="card">
            <div class="card-body">
                <form action="${root}/admin/orders" method="GET" class="row g-3 align-items-center" id="filterForm">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="fa-solid fa-search"></i></span>
                            <input type="text" name="search" class="form-control border-start-0" 
                                   placeholder="Tìm theo mã ĐH, tên KH, SĐT..." value="${searchValue}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select name="status" class="form-select" id="statusSelect">
                            <option value="">Tất cả trạng thái</option>
                            <option value="pending" ${currentStatus == 'pending' ? 'selected' : ''}>Chờ xác nhận</option>
                            <option value="confirmed" ${currentStatus == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="shipping" ${currentStatus == 'shipping' ? 'selected' : ''}>Đang giao</option>
                            <option value="delivered" ${currentStatus == 'delivered' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="cancelled" ${currentStatus == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="date" name="date" class="form-control" value="${currentDate}">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Lọc dữ liệu</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Danh sách đơn hàng -->
        <div class="card">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 font-weight-bold text-primary">Danh sách Đơn hàng</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="ordersTable">
                        <thead class="table-light">
                            <tr>
                                <th>Mã ĐH</th>
                                <th>Thông tin khách hàng</th>
                                <th>Ngày đặt</th>
                                <th>Tổng tiền</th>
                                <th>Thanh toán</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listOrders}" var="o">
                                <tr>
                                    <td><strong>#${o.id}</strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-placeholder me-2">
                                                ${fn:substring(o.customerDisplayName, 0, 1)}
                                            </div>
                                            <div>
                                                <div class="fw-bold">${o.customerDisplayName}</div>
                                                <div class="small text-muted">
                                                    <i class="fa-solid fa-phone fa-xs"></i> ${o.phone}
                                                    <c:if test="${not empty o.customerEmail}">
                                                        <br><i class="fa-solid fa-envelope fa-xs"></i> ${o.customerEmail}
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/><br>
                                        <small class="text-muted"><fmt:formatDate value="${o.createdAt}" pattern="HH:mm:ss"/></small>
                                    </td>
                                    <td class="fw-bold text-danger">
                                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>₫
                                    </td>
                                    <td>
                                        <span class="badge ${o.paymentStatus == 'paid' ? 'bg-success' : 'bg-secondary'}">
                                            <i class="fa-solid ${o.paymentStatus == 'paid' ? 'fa-check-circle' : 'fa-clock'} me-1"></i>
                                            ${o.paymentStatus == 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${o.statusBadgeClass}">
                                            <i class="${o.status == 'pending' ? 'fa-regular fa-clock' : 
                                                       o.status == 'confirmed' ? 'fa-regular fa-circle-check' : 
                                                       o.status == 'shipping' ? 'fa-solid fa-truck' : 
                                                       o.status == 'delivered' ? 'fa-regular fa-circle-check' : 
                                                       'fa-regular fa-circle-xmark'} me-1"></i>
                                            ${o.statusText}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-info text-white btn-action" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#orderModal${o.id}">
                                                <i class="fa-solid fa-eye"></i>
                                            </button>
                                            
                                            <c:if test="${o.status == 'pending'}">
                                                <form action="${root}/admin/orders" method="POST" class="d-inline">
                                                    <input type="hidden" name="orderId" value="${o.id}">
                                                    <input type="hidden" name="action" value="confirm">
                                                    <button type="submit" class="btn btn-success btn-action" title="Xác nhận đơn">
                                                        <i class="fa-solid fa-check"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                            
                                            <c:if test="${o.status == 'confirmed'}">
                                                <form action="${root}/admin/orders" method="POST" class="d-inline">
                                                    <input type="hidden" name="orderId" value="${o.id}">
                                                    <input type="hidden" name="action" value="shipping">
                                                    <button type="submit" class="btn btn-primary btn-action" title="Giao hàng">
                                                        <i class="fa-solid fa-truck"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                            
                                            <c:if test="${o.status == 'shipping'}">
                                                <form action="${root}/admin/orders" method="POST" class="d-inline">
                                                    <input type="hidden" name="orderId" value="${o.id}">
                                                    <input type="hidden" name="action" value="delivered">
                                                    <button type="submit" class="btn btn-success btn-action" title="Hoàn thành">
                                                        <i class="fa-solid fa-circle-check"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                            
                                            <c:if test="${o.status == 'pending' or o.status == 'confirmed'}">
                                                <button class="btn btn-danger btn-action" 
                                                        onclick="cancelOrder(${o.id})"
                                                        title="Hủy đơn">
                                                    <i class="fa-solid fa-times"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty listOrders}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-inbox fa-3x mb-3 d-block"></i>
                                        Không có đơn hàng nào
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Chi tiết đơn hàng -->
<c:forEach items="${listOrders}" var="o">
    <div class="modal fade" id="orderModal${o.id}" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-receipt me-2"></i>Chi tiết đơn hàng #${o.id}
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-4">
                        <div class="col-md-6 border-end">
                            <p class="text-muted text-uppercase small fw-bold mb-2">
                                <i class="fa-solid fa-user me-1"></i>Thông tin khách hàng
                            </p>
                            <p class="mb-1"><strong>Họ tên:</strong> ${o.customerDisplayName}</p>
                            <p class="mb-1"><strong>Tên đăng nhập:</strong> ${o.customerUsername != null ? o.customerUsername : 'N/A'}</p>
                            <p class="mb-1"><strong>Email:</strong> ${o.customerEmail != null ? o.customerEmail : 'N/A'}</p>
                            <p class="mb-1"><strong>SĐT:</strong> ${o.phone}</p>
                            <p><strong>Địa chỉ:</strong> ${o.address}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="text-muted text-uppercase small fw-bold mb-2">
                                <i class="fa-solid fa-info-circle me-1"></i>Thông tin đơn hàng
                            </p>
                            <p class="mb-1"><strong>Ngày đặt:</strong> <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                            <p class="mb-1"><strong>Trạng thái:</strong> ${o.statusText}</p>
                            <p><strong>Thanh toán:</strong> ${o.paymentStatus == 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán'}</p>
                        </div>
                    </div>
                    
                    <p class="text-muted text-uppercase small fw-bold mb-2">
                        <i class="fa-solid fa-boxes me-1"></i>Danh sách sản phẩm
                    </p>
                    <table class="table table-bordered">
                        <thead class="table-light">
                            <tr>
                                <th>Sản phẩm</th>
                                <th class="text-center">SL</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-end">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${o.orderDetails}" var="d">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty d.productImage}">
                                                    <img src="${root}/${d.productImage}" class="product-img me-3" onerror="this.src='${root}/images/no-image.png'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${root}/images/no-image.png" class="product-img me-3">
                                                </c:otherwise>
                                            </c:choose>
                                            <span>${d.productName}</span>
                                        </div>
                                    </td>
                                    <td class="text-center">${d.quantity}</td>
                                    <td class="text-end"><fmt:formatNumber value="${d.price}" pattern="#,###"/>₫</td>
                                    <td class="text-end fw-bold"><fmt:formatNumber value="${d.price * d.quantity}" pattern="#,###"/>₫</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot class="table-light">
                            <tr>
                                <td colspan="3" class="text-end fw-bold">Tổng cộng:</td>
                                <td class="text-end text-danger fw-bold fs-5">
                                    <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>₫
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <c:if test="${o.status != 'cancelled' && o.status != 'delivered'}">
                        <button class="btn btn-danger" onclick="cancelOrder(${o.id})">Hủy đơn hàng</button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterByStatus(status) {
        const statusSelect = document.getElementById('statusSelect');
        if (statusSelect) {
            statusSelect.value = status === 'all' ? '' : status;
            document.getElementById('filterForm').submit();
        }
    }
    
    function cancelOrder(orderId) {
        if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${root}/admin/orders';
            
            const orderIdInput = document.createElement('input');
            orderIdInput.type = 'hidden';
            orderIdInput.name = 'orderId';
            orderIdInput.value = orderId;
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'cancel';
            
            form.appendChild(orderIdInput);
            form.appendChild(actionInput);
            document.body.appendChild(form);
            form.submit();
        }
    }
    
    function exportToExcel() {
        let table = document.getElementById('ordersTable');
        let html = table.outerHTML;
        let url = 'data:application/vnd.ms-excel,' + encodeURIComponent(html);
        let link = document.createElement('a');
        link.download = 'orders_' + new Date().toISOString().slice(0,19) + '.xls';
        link.href = url;
        link.click();
    }
</script>
</body>
</html>