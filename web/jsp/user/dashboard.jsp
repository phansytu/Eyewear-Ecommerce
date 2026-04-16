<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<%-- Bảo vệ trang: Nếu chưa đăng nhập thì đẩy về trang login --%>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tài khoản cá nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f5f5fa; font-family: sans-serif; }
        .sidebar-user { background: #fff; border-radius: 8px; padding: 15px; }
        .sidebar-user a { color: #38383d; text-decoration: none; display: block; padding: 10px; border-radius: 4px; transition: 0.2s;}
        .sidebar-user a:hover, .sidebar-user a.active { background: #ebebf0; color: #1A94FF; font-weight: 500;}
        .sidebar-user i { width: 25px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${root}/home"><i class="fas fa-glasses me-2"></i>KÍNH MẮT TIKI</a>
            <div class="d-flex align-items-center text-white">
                <span class="me-3">Xin chào, <strong>${sessionScope.user.username}</strong>!</span>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <div class="sidebar-user shadow-sm">
                    <div class="text-center mb-3">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=random" class="rounded-circle" width="60" alt="Avatar">
                        <h6 class="mt-2 mb-0">${sessionScope.user.username}</h6>
                    </div>
                    <hr>
                    <a href="#" class="active"><i class="far fa-user"></i> Thông tin tài khoản</a>
                    <a href="#"><i class="fas fa-clipboard-list"></i> Quản lý đơn hàng</a>
                    <a href="#"><i class="far fa-bell"></i> Thông báo của tôi</a>
                    <a href="${root}/home"><i class="fas fa-store"></i> Tiếp tục mua sắm</a>
                    <a href="${root}/logout" class="text-danger mt-3"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                </div>
            </div>

            <div class="col-md-9">
                <div class="bg-white p-4 rounded-3 shadow-sm">
                    <h4 class="mb-4">Thông tin cá nhân</h4>
                    <form>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">Tên đăng nhập</label>
                                <input type="text" class="form-control" value="${sessionScope.user.username}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" value="email@example.com">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" value="0987654321">
                        </div>
                        <button type="button" class="btn btn-primary px-4">Cập nhật thông tin</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>