<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hồ Sơ Của Tôi | TuHuyKhanh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f5f5f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .shopee-color { color: #ee4d2d; }
        .bg-shopee { background-color: #ee4d2d; }
        
        /* Navbar */
        .top-navbar { background: white; padding: 15px 0; border-bottom: 1px solid rgba(0,0,0,.05); margin-bottom: 30px; }
        .top-navbar a { text-decoration: none; color: #ee4d2d; font-size: 20px; font-weight: 500; }
        
        /* Sidebar */
        .sidebar-item { padding: 8px 0; cursor: pointer; color: rgba(0,0,0,.65); text-decoration: none; display: block; font-weight: 500; transition: 0.2s;}
        .sidebar-item:hover, .sidebar-item.active { color: #ee4d2d; }
        .sidebar-icon { width: 24px; text-align: center; margin-right: 8px; color: #1a9cb7;} /* Màu icon Shopee */
        
        /* Main Content */
        .profile-container { background: white; padding: 0; border-radius: 4px; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); }
        .profile-header { padding: 20px 30px; border-bottom: 1px solid #efefef; }
        .profile-body { padding: 30px; }
        .form-control:focus { border-color: #ee4d2d; box-shadow: none; }
        .btn-shopee { background-color: #ee4d2d; color: white; padding: 10px 25px; border: none; border-radius: 2px; }
        .btn-shopee:hover { background-color: #d73211; color: white; }
    </style>
</head>
<body>
    <div class="top-navbar shadow-sm">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="home.jsp"><i class="fa-solid fa-bag-shopping me-2"></i>Profile</a>
            <a href="home.jsp" style="font-size: 15px; color: #333;"><i class="fa-solid fa-house me-1"></i> Về Trang chủ</a>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row">
            <div class="col-md-2">
                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                    <img src="${not empty sessionScope.user.avatar ? sessionScope.user.avatar : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'}" 
                         class="rounded-circle me-2" width="50" height="50" style="object-fit: cover; border: 1px solid #efefef;">
                    <div>
                        <div class="fw-bold text-truncate" style="max-width: 100px;">${sessionScope.user.username}</div>
                        <div class="text-muted" style="font-size: 13px;"><i class="fa-solid fa-pen text-secondary me-1"></i>Sửa hồ sơ</div>
                    </div>
                </div>
                <div class="list-group list-group-flush">
                    <a href="profile" class="sidebar-item active"><i class="fa-regular fa-user sidebar-icon" style="color: #0b5edd;"></i> Tài khoản của tôi</a>
                    
                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <a href="jsp/admin/dashboard.jsp" class="sidebar-item"><i class="fa-solid fa-gauge sidebar-icon" style="color: #ee4d2d;"></i> Quản trị hệ thống</a>
                    </c:if>
                    
                    <a href="orders" class="sidebar-item"><i class="fa-solid fa-clipboard-list sidebar-icon" style="color: #1a9cb7;"></i> Đơn mua</a>
                    <a href="logout" class="sidebar-item mt-3"><i class="fa-solid fa-right-from-bracket sidebar-icon" style="color: gray;"></i> Đăng xuất</a>
                </div>
            </div>

            <div class="col-md-10">
                <div class="profile-container">
                    <div class="profile-header">
                        <h4 class="mb-1" style="font-size: 18px; font-weight: 500;">Hồ Sơ Của Tôi</h4>
                        <div class="text-muted" style="font-size: 14px;">Quản lý thông tin hồ sơ để bảo mật tài khoản</div>
                    </div>
                    
                    <div class="profile-body">
                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="profile" method="POST">
                            <div class="row">
                                <div class="col-md-8 pe-5 border-end">
                                    <div class="row mb-4 align-items-center">
                                        <label class="col-sm-3 text-end text-muted" style="font-size: 14px;">Tên đăng nhập</label>
                                        <div class="col-sm-9 fw-bold">${sessionScope.user.username}</div>
                                    </div>

                                    <div class="row mb-4 align-items-center">
                                        <label class="col-sm-3 text-end text-muted" style="font-size: 14px;">Họ và tên</label>
                                        <div class="col-sm-9">
                                            <input type="text" name="fullName" class="form-control" value="${sessionScope.user.full_name}">
                                        </div>
                                    </div>

                                    <div class="row mb-4 align-items-center">
                                        <label class="col-sm-3 text-end text-muted" style="font-size: 14px;">Email</label>
                                        <div class="col-sm-9">
                                            <input type="email" name="email" class="form-control" value="${sessionScope.user.email}">
                                        </div>
                                    </div>

                                    <div class="row mb-4 align-items-center">
                                        <label class="col-sm-3 text-end text-muted" style="font-size: 14px;">Số điện thoại</label>
                                        <div class="col-sm-9">
                                            <input type="text" name="phone" class="form-control" value="${sessionScope.user.phone}">
                                        </div>
                                    </div>

                                    <div class="row mb-4 align-items-center">
                                        <label class="col-sm-3 text-end text-muted" style="font-size: 14px;">Giới tính</label>
                                        <div class="col-sm-9 d-flex align-items-center">
                                            <div class="form-check form-check-inline mb-0">
                                                <input class="form-check-input" type="radio" name="gender" id="gNam" value="Nam" ${sessionScope.user.gender == 'Nam' ? 'checked' : ''}>
                                                <label class="form-check-label" for="gNam">Nam</label>
                                            </div>
                                            <div class="form-check form-check-inline mb-0">
                                                <input class="form-check-input" type="radio" name="gender" id="gNu" value="Nữ" ${sessionScope.user.gender == 'Nữ' ? 'checked' : ''}>
                                                <label class="form-check-label" for="gNu">Nữ</label>
                                            </div>
                                            <div class="form-check form-check-inline mb-0">
                                                <input class="form-check-input" type="radio" name="gender" id="gKhac" value="Khác" ${sessionScope.user.gender == 'Khác' ? 'checked' : ''}>
                                                <label class="form-check-label" for="gKhac">Khác</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row mb-5 align-items-center">
                                        <label class="col-sm-3 text-end text-muted" style="font-size: 14px;">Ngày sinh</label>
                                        <div class="col-sm-9">
                                            <input type="date" name="dob" class="form-control" value="${sessionScope.user.dob}">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-3"></div>
                                        <div class="col-sm-9">
                                            <button type="submit" class="btn btn-shopee">Lưu</button>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-4 d-flex flex-column align-items-center justify-content-center">
                                    <img src="${not empty sessionScope.user.avatar ? sessionScope.user.avatar : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'}" 
                                         class="rounded-circle mb-3" width="100" height="100" style="object-fit: cover; border: 1px solid #efefef;">
                                    <button type="button" class="btn btn-outline-secondary btn-sm mb-2">Chọn Ảnh</button>
                                    <div class="text-muted text-center" style="font-size: 12px;">
                                        Dụng lượng file tối đa 1 MB<br>Định dạng: .JPEG, .PNG
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>