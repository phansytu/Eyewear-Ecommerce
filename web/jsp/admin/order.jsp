<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        .stat-card { border-left: 4px solid; transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card.primary { border-color: #007bff; }
        .stat-card.warning { border-color: #ffc107; }
        .stat-card.success { border-color: #28a745; }
        .stat-card.danger { border-color: #dc3545; }
        
        /* Custom Badge Styles */
        .badge-pending { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .badge-confirmed { background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .badge-shipping { background-color: #cce5ff; color: #004085; border: 1px solid #b8daff; }
        .badge-delivered { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-cancelled { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .btn-action { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: none; }
        .table img { object-fit: cover; border-radius: 4px; }
    </style>
</head>
<body>

<div class="wrapper">
    <nav class="sidebar">
        <div class="p-4 fs-4 fw-bold text-center border-bottom border-secondary">
            <i class="fa-solid fa-glasses me-2 text-primary"></i>Admin Panel
        </div>
        <div class="mt-3">
            <a href="dashboard"><i class="fa-solid fa-gauge me-3"></i>Tổng quan</a>
            <a href="products"><i class="fa-solid fa-box me-3"></i>Sản phẩm</a>
            <a href="orders" class="active"><i class="fa-solid fa-cart-shopping me-3"></i>Đơn hàng</a>
            <a href="users"><i class="fa-solid fa-users me-3"></i>Khách hàng</a>
            <a href="${pageContext.request.contextPath}/logout" class="mt-5 text-danger"><i class="fa-solid fa-sign-out-alt me-3"></i>Đăng xuất</a>
        </div>
    </nav>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h3 mb-0 text-gray-800">Quản lý Đơn hàng</h2>
            <div>
                <button class="btn btn-outline-primary me-2"><i class="fa-solid fa-rotate me-2"></i>Làm mới</button>
                <button class="btn btn-success shadow-sm"><i class="fa-solid fa-file-excel me-2"></i>Xuất Excel</button>
            </div>
        </div>

        <div class="row">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card warning h-100 py-2">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Chờ xác nhận</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">12 Đơn</div>
                    </div>
                </div>
            </div>
            </div>

        <div class="card">
            <div class="card-body">
                <form action="orders" method="GET" class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="fa-solid fa-search"></i></span>
                            <input type="text" name="search" class="form-control border-start-0" placeholder="Tìm mã ĐH, SĐT...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="pending">Chờ xác nhận</option>
                            <option value="confirmed">Đã xác nhận</option>
                            <option value="shipping">Đang giao</option>
                            <option value="delivered">Hoàn thành</option>
                            <option value="cancelled">Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="date" name="date" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Lọc dữ liệu</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 font-weight-bold text-primary">Danh sách Đơn hàng mới nhất</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Mã ĐH</th>
                                <th>Thông tin khách</th>
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
                                    <td><strong>#ORD-${o.id}</strong></td>
                                    <td>
                                        <div class="fw-bold">Khách hàng #${o.userId}</div>
                                        <div class="small text-muted"><i class="fa-solid fa-phone fa-xs"></i> ${o.phone}</div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/><br>
                                        <small class="text-muted"><fmt:formatDate value="${o.createdAt}" pattern="HH:mm"/></small>
                                    </td>
                                    <td class="fw-bold text-danger">
                                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>₫
                                    </td>
                                    <td>
                                        <span class="badge ${o.paymentStatus == 'paid' ? 'bg-success' : 'bg-secondary'}">
                                            ${o.paymentStatus == 'paid' ? 'Đã trả' : 'Thanh toán COD'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 'pending'}"><span class="badge badge-pending">Chờ duyệt</span></c:when>
                                            <c:when test="${o.status == 'confirmed'}"><span class="badge badge-confirmed">Đã xác nhận</span></c:when>
                                            <c:when test="${o.status == 'shipping'}"><span class="badge badge-shipping">Đang giao</span></c:when>
                                            <c:when test="${o.status == 'delivered'}"><span class="badge badge-delivered">Hoàn thành</span></c:when>
                                            <c:when test="${o.status == 'cancelled'}"><span class="badge badge-cancelled">Đã hủy</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-info text-white btn-action" data-bs-toggle="modal" data-bs-target="#modal${o.id}"><i class="fa-solid fa-eye"></i></button>
                                            
                                            <c:if test="${o.status == 'pending'}">
                                                <form action="update-order" method="POST">
                                                    <input type="hidden" name="orderId" value="${o.id}">
                                                    <input type="hidden" name="action" value="confirm">
                                                    <button type="submit" class="btn btn-success btn-action"><i class="fa-solid fa-check"></i></button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<c:forEach items="${listOrders}" var="o">
    <div class="modal fade" id="modal${o.id}" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Chi tiết đơn hàng #ORD-${o.id}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-4">
                        <div class="col-md-6 border-end">
                            <p class="text-muted text-uppercase small fw-bold">Thông tin nhận hàng</p>
                            <p class="mb-1"><strong>SĐT:</strong> ${o.phone}</p>
                            <p><strong>Địa chỉ:</strong> ${o.address}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="text-muted text-uppercase small fw-bold">Trạng thái đơn</p>
                            <p class="mb-1"><strong>Thanh toán:</strong> ${o.paymentStatus}</p>
                            <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                        </div>
                    </div>
                    
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
                            <c:forEach items="${o.details}" var="d">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${d.productImage}" width="40" height="40" class="me-3">
                                            <span>${d.productName}</span>
                                        </div>
                                    </td>
                                    <td class="text-center">${d.quantity}</td>
                                    <td class="text-end"><fmt:formatNumber value="${d.price}" pattern="#,###"/>₫</td>
                                    <td class="text-end fw-bold"><fmt:formatNumber value="${d.price * d.quantity}" pattern="#,###"/>₫</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-end fw-bold">Tổng cộng:</td>
                                <td class="text-end text-danger fw-bold fs-5"><fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>₫</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <c:if test="${o.status != 'cancelled' && o.status != 'delivered'}">
                         <form action="update-order" method="POST">
                            <input type="hidden" name="orderId" value="${o.id}">
                            <input type="hidden" name="action" value="cancel">
                            <button type="submit" class="btn btn-danger">Hủy đơn hàng</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>