<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <style>
        body { background-color: #f4f6f9; }
        .sidebar { height: 100vh; background: #343a40; color: #fff; position: fixed; width: 250px;}
        .sidebar a { color: #c2c7d0; text-decoration: none; padding: 12px 20px; display: block; transition: 0.3s;}
        .sidebar a:hover, .sidebar a.active { background: #007bff; color: #fff; }
        .main-content { margin-left: 250px; padding: 20px; }
        .stat-card { border-left: 4px solid; border-radius: 8px; }
    </style>
</head>
<body>

    <div class="sidebar pt-3">
        <h4 class="text-center mb-4"><i class="fas fa-crown text-warning"></i> ADMIN PANEL</h4>
        <div class="px-3 mb-3 d-flex align-items-center">
            <i class="fas fa-user-circle fa-2x me-2 text-secondary"></i>
            <span>${sessionScope.user.username}</span>
        </div>
        <a href="#" class="active"><i class="fas fa-tachometer-alt me-2"></i> Tổng quan</a>
        <a href="#"><i class="fas fa-box me-2"></i> Quản lý sản phẩm</a>
        <a href="#"><i class="fas fa-list me-2"></i> Quản lý danh mục</a>
        <a href="#"><i class="fas fa-shopping-cart me-2"></i> Quản lý đơn hàng</a>
        <a href="#"><i class="fas fa-users me-2"></i> Quản lý người dùng</a>
        <a href="${root}/logout" class="text-danger mt-5"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Bảng điều khiển</h2>
            <a href="${root}/home" class="btn btn-outline-primary"><i class="fas fa-external-link-alt"></i> Xem Website</a>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-primary">
                    <div class="card-body">
                        <h6 class="text-muted">Tổng Doanh Thu</h6>
                        <h3 class="text-primary mb-0">45.000.000₫</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-success">
                    <div class="card-body">
                        <h6 class="text-muted">Đơn Hàng Mới</h6>
                        <h3 class="text-success mb-0">12 Đơn</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-warning">
                    <div class="card-body">
                        <h6 class="text-muted">Sản Phẩm</h6>
                        <h3 class="text-warning mb-0">150 Mẫu</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm border-info">
                    <div class="card-body">
                        <h6 class="text-muted">Khách Hàng</h6>
                        <h3 class="text-info mb-0">340</h3>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0">Đơn hàng cần xử lý</h5>
            </div>
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Khách hàng</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>#DH001</td>
                            <td>Nguyễn Văn A</td>
                            <td>16/04/2026</td>
                            <td>1.500.000₫</td>
                            <td><span class="badge bg-warning text-dark">Chờ duyệt</span></td>
                            <td><button class="btn btn-sm btn-info text-white">Xem</button></td>
                        </tr>
                        <tr>
                            <td>#DH002</td>
                            <td>Trần Thị B</td>
                            <td>16/04/2026</td>
                            <td>850.000₫</td>
                            <td><span class="badge bg-warning text-dark">Chờ duyệt</span></td>
                            <td><button class="btn btn-sm btn-info text-white">Xem</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>