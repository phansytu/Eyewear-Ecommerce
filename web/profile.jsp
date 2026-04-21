<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản của tôi - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f5f5fa; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; }
        .nav-pills .nav-link.active { background-color: #1A94FF; }
        .nav-pills .nav-link { color: #38383d; font-weight: 500; }
        .nav-pills .nav-link:hover:not(.active) { background-color: #f0f0f0; }
        .profile-header { background: linear-gradient(135deg, #1A94FF 0%, #0d6efd 100%); position: relative; }
        .avatar-wrapper {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }
        .avatar-wrapper:hover .avatar-overlay {
            opacity: 1;
        }
        .avatar-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;
            color: white;
            font-size: 14px;
        }
        .avatar-overlay i {
            font-size: 24px;
        }
        .avatar-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid white;
        }
        .order-card { transition: transform 0.2s, box-shadow 0.2s; }
        .order-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .status-badge { font-size: 12px; padding: 4px 8px; border-radius: 4px; }
        .status-delivered { background-color: #d4edda; color: #155724; }
        .status-processing { background-color: #fff3cd; color: #856404; }
        .status-shipped { background-color: #d1ecf1; color: #0c5460; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .cropper-container {
            max-width: 100%;
            max-height: 400px;
        }
        .preview-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto;
            border: 3px solid #ddd;
        }
        .preview-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>
    <!-- Cropper.js CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css">
</head>
<body>

<!-- Header đơn giản -->
<header class="bg-white border-bottom sticky-top">
    <div class="container-fluid px-4 py-2">
        <div class="row align-items-center">
            <div class="col-md-3">
                <a href="${root}/home" class="text-decoration-none">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-glasses text-primary fs-3 me-2"></i>
                        <span class="fw-bold fs-4 text-primary">TuKhanhHuy</span>
                    </div>
                </a>
            </div>
            <div class="col-md-6">
                <form action="${root}/search" method="GET">
                    <div class="input-group">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm sản phẩm...">
                        <button class="btn btn-primary" type="submit"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>
            <div class="col-md-3 text-end">
                <a href="${root}/cart" class="text-decoration-none text-dark me-3">
                    <i class="fas fa-shopping-cart fs-5"></i>
                    <span class="badge bg-danger rounded-pill">0</span>
                </a>
                <a href="${root}/home" class="text-decoration-none text-dark">
                    <i class="fas fa-home fs-5"></i>
                </a>
            </div>
        </div>
    </div>
</header>

<div class="container py-4">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 mb-4">
            <div class="bg-white rounded-3 shadow-sm overflow-hidden">
                <div class="profile-header text-white p-3 text-center">
                    <div class="avatar-wrapper" onclick="document.getElementById('avatarInput').click();">
                        <img id="avatarPreview" 
                             src="${not empty sessionScope.user.avatar ? sessionScope.user.avatar : 'https://ui-avatars.com/api/?name='.concat(sessionScope.user.username).concat('&background=1A94FF&color=fff&length=2&size=80')}" 
                             class="avatar-img" alt="Avatar">
                        <div class="avatar-overlay">
                            <i class="fas fa-camera"></i>
                        </div>
                    </div>
                    <form id="avatarForm" action="${root}/profile" method="POST" enctype="multipart/form-data" style="display: none;">
                        <input type="file" id="avatarInput" name="avatar" accept="imagesAvt/*" onchange="previewAndCrop(this)">
                        <input type="hidden" name="action" value="updateAvatar">
                        <input type="hidden" name="croppedImage" id="croppedImage">
                    </form>
                    <h6 class="mb-0 mt-2">${sessionScope.user.full_name != null ? sessionScope.user.full_name : sessionScope.user.username}</h6>
                    <small class="opacity-75"><i class="fas fa-envelope me-1"></i>${sessionScope.user.email}</small>
                </div>
                <div class="p-3">
                    <ul class="nav nav-pills flex-column" id="profileTabs" role="tablist">
                        <li class="nav-item mb-2">
                            <a class="nav-link ${activeTab == 'profile' ? 'active' : ''}" id="profile-tab" data-bs-toggle="pill" href="#profile" role="tab">
                                <i class="fas fa-user-circle me-2"></i> Hồ sơ của tôi
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link ${activeTab == 'orders' ? 'active' : ''}" id="orders-tab" data-bs-toggle="pill" href="#orders" role="tab">
                                <i class="fas fa-clipboard-list me-2"></i> Đơn mua
                                <span class="badge bg-secondary ms-2">3</span>
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link ${activeTab == 'security' ? 'active' : ''}" id="security-tab" data-bs-toggle="pill" href="#security" role="tab">
                                <i class="fas fa-shield-alt me-2"></i> Bảo mật
                            </a>
                        </li>
                        <li class="nav-item mt-3">
                            <hr class="my-2">
                            <a class="nav-link text-danger" href="${root}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="tab-content">
                
                <!-- Tab Hồ sơ -->
                <div class="tab-pane fade ${activeTab == 'profile' ? 'show active' : ''}" id="profile" role="tabpanel">
                    <div class="bg-white rounded-3 shadow-sm p-4">
                        <h4 class="fw-bold mb-1">Hồ Sơ Của Tôi</h4>
                        <p class="text-muted border-bottom pb-3">Quản lý thông tin cá nhân của bạn</p>
                        
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i> ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <form action="${root}/profile" method="POST" class="mt-4" id="profileForm">
                            <input type="hidden" name="action" value="updateProfile">
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Tên đăng nhập</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control bg-light" value="${sessionScope.user.username}" readonly disabled>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Họ và tên</label>
                                <div class="col-sm-9">
                                    <input type="text" name="fullName" class="form-control" value="${sessionScope.user.full_name}" placeholder="Nhập họ và tên">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Email</label>
                                <div class="col-sm-9">
                                    <input type="email" name="email" class="form-control" value="${sessionScope.user.email}" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Số điện thoại</label>
                                <div class="col-sm-9">
                                    <input type="tel" name="phone" class="form-control" value="${sessionScope.user.phone}" placeholder="Nhập số điện thoại">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Giới tính</label>
                                <div class="col-sm-9">
                                    <select name="gender" class="form-select">
                                        <option value="">Chọn giới tính</option>
                                        <option value="Nam" ${sessionScope.user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${sessionScope.user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${sessionScope.user.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Ngày sinh</label>
                                <div class="col-sm-9">
                                    <input type="date" name="dob" class="form-control" value="${sessionScope.user.dob}">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Địa chỉ</label>
                                <div class="col-sm-9">
                                    <textarea name="address" class="form-control" rows="3" placeholder="Nhập địa chỉ giao hàng">${sessionScope.user.address}</textarea>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-sm-9 offset-sm-3">
                                    <button type="submit" class="btn btn-primary px-4">
                                        <i class="fas fa-save me-2"></i> Lưu thông tin
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Tab Đơn mua -->
<div class="tab-pane fade ${activeTab == 'orders' ? 'show active' : ''}" id="orders" role="tabpanel">
    <div class="bg-white rounded-3 shadow-sm p-4">
        <h4 class="fw-bold mb-4">Đơn Mua Của Tôi</h4>
        
        <!-- Filter buttons -->
        <div class="mb-3">
            <div class="btn-group flex-wrap" role="group">
                <button type="button" class="btn btn-outline-primary btn-sm filter-btn active" data-status="all">Tất cả</button>
                <button type="button" class="btn btn-outline-primary btn-sm filter-btn" data-status="pending">Chờ xác nhận</button>
                <button type="button" class="btn btn-outline-primary btn-sm filter-btn" data-status="confirmed">Đã xác nhận</button>
                <button type="button" class="btn btn-outline-primary btn-sm filter-btn" data-status="shipping">Đang giao</button>
                <button type="button" class="btn btn-outline-primary btn-sm filter-btn" data-status="delivered">Đã giao</button>
                <button type="button" class="btn btn-outline-primary btn-sm filter-btn" data-status="cancelled">Đã hủy</button>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty orders}">
                <div class="text-center py-5 text-muted">
                    <i class="fas fa-box-open fs-1 mb-3 d-block"></i>
                    <p>Bạn chưa có đơn hàng nào.</p>
                    <a href="${root}/home" class="btn btn-primary mt-3">Mua sắm ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <div id="ordersContainer">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card border rounded-3 p-3 mb-3" data-order-status="${order.status}">
                            <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                                <div>
                                    <span class="text-muted small">Mã đơn hàng:</span>
                                    <strong>#${order.id}</strong>
                                    <span class="text-muted small ms-3">
                                        <i class="far fa-calendar-alt me-1"></i>
                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                                <div>
                                    <span class="status-badge ${order.statusBadgeClass}">
                                        <i class="fas ${order.statusIcon} me-1"></i>
                                        ${order.statusText}
                                    </span>
                                </div>
                            </div>
                            
                            <c:forEach var="detail" items="${order.orderDetails}" varStatus="loop">
                                <div class="d-flex gap-3 ${!loop.last ? 'mb-3' : ''}">
                                    <img src="${not empty detail.productImage ? root.concat('/').concat(detail.productImage) : root.concat('/images/no-image.png')}" 
                                         class="rounded border" 
                                         width="80" height="80" 
                                         alt="${detail.productName}"
                                         onerror="this.src='${root}/images/no-image.png'">
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">${detail.productName}</h6>
                                        <c:if test="${not empty detail.variantName}">
                                            <p class="text-muted small mb-1">Phân loại: ${detail.variantName}</p>
                                        </c:if>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <span class="text-danger fw-bold">
                                                    <fmt:formatNumber value="${detail.price}" pattern="#,###"/> ₫
                                                </span>
                                                <span class="text-muted small ms-2">x${detail.quantity}</span>
                                            </div>
                                            <c:if test="${order.status == 'delivered'}">
                                                <button class="btn btn-sm btn-outline-primary buy-again-btn" 
                                                        data-product-id="${detail.productId}"
                                                        data-variant-id="${detail.variantId}">
                                                    Mua lại
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <div class="border-top mt-3 pt-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="text-muted small">Địa chỉ: ${order.address}</span>
                                        <br>
                                        <span class="text-muted small">SĐT: ${order.phone}</span>
                                    </div>
                                    <div class="text-end">
                                        <span class="text-muted">Thành tiền: </span>
                                        <strong class="text-danger fs-5">
                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> ₫
                                        </strong>
                                    </div>
                                </div>
                                
                                <c:if test="${order.status == 'pending'}">
                                    <div class="text-end mt-2">
                                        <button class="btn btn-sm btn-danger cancel-order-btn" data-order-id="${order.id}">
                                            <i class="fas fa-times me-1"></i> Hủy đơn hàng
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

                <!-- Tab Bảo mật -->
                <div class="tab-pane fade ${activeTab == 'security' ? 'show active' : ''}" id="security" role="tabpanel">
                    <div class="bg-white rounded-3 shadow-sm p-4">
                        <h4 class="fw-bold mb-1">Bảo Mật Tài Khoản</h4>
                        <p class="text-muted border-bottom pb-3">Đổi mật khẩu để bảo vệ tài khoản của bạn</p>
                        
                        <form action="${root}/profile" method="POST" class="mt-4" onsubmit="return validatePassword()">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Mật khẩu hiện tại</label>
                                <div class="col-sm-9">
                                    <input type="password" name="currentPassword" id="currentPassword" class="form-control" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Mật khẩu mới</label>
                                <div class="col-sm-9">
                                    <input type="password" name="newPassword" id="newPassword" class="form-control" required>
                                    <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự</small>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label text-muted">Xác nhận mật khẩu mới</label>
                                <div class="col-sm-9">
                                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-sm-9 offset-sm-3">
                                    <button type="submit" class="btn btn-primary px-4">
                                        <i class="fas fa-key me-2"></i> Đổi mật khẩu
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Crop Ảnh -->
<div class="modal fade" id="cropModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-crop-alt me-2"></i>Cắt ảnh đại diện</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-8">
                        <div class="cropper-container">
                            <img id="cropImage" src="" style="max-width: 100%;">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="preview-circle mb-3">
                            <img id="preview" src="" alt="Preview">
                        </div>
                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-secondary" onclick="rotateImage(-90)">
                                <i class="fas fa-undo-alt"></i> Xoay trái
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="rotateImage(90)">
                                <i class="fas fa-redo-alt"></i> Xoay phải
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" onclick="cropAndUpload()">
                    <i class="fas fa-check me-2"></i>Cắt và lưu
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
<script>
    let cropper;
    let currentFile;
    const cropModal = new bootstrap.Modal(document.getElementById('cropModal'));
    
    function previewAndCrop(input) {
        if (input.files && input.files[0]) {
            currentFile = input.files[0];
            const reader = new FileReader();
            
            reader.onload = function(e) {
                document.getElementById('cropImage').src = e.target.result;
                cropModal.show();
                
                // Khởi tạo cropper sau khi modal hiển thị
                setTimeout(() => {
                    if (cropper) cropper.destroy();
                    const image = document.getElementById('cropImage');
                    cropper = new Cropper(image, {
                        aspectRatio: 1,
                        viewMode: 1,
                        dragMode: 'move',
                        preview: '.preview-circle',
                        background: false,
                        autoCropArea: 1,
                        responsive: true,
                    });
                }, 100);
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    function rotateImage(degree) {
        if (cropper) {
            cropper.rotate(degree);
        }
    }
    
    function cropAndUpload() {
        if (cropper) {
            const canvas = cropper.getCroppedCanvas({
                width: 300,
                height: 300,
            });
            
            canvas.toBlob(function(blob) {
                const formData = new FormData();
                formData.append('action', 'updateAvatar');
                formData.append('avatar', blob, 'avatar.jpg');
                
                fetch('${root}/profile', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Cập nhật ảnh hiển thị
                        document.getElementById('avatarPreview').src = data.avatarUrl + '?t=' + new Date().getTime();
                        cropModal.hide();
                        showNotification('Cập nhật ảnh đại diện thành công!', 'success');
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        showNotification(data.message || 'Cập nhật thất bại!', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra!', 'error');
                });
            }, 'image/jpeg', 0.9);
        }
    }
    
    function showNotification(message, type) {
    const alertDiv = document.createElement('div');
    const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
    const iconClass = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
    
    alertDiv.className = `alert ${alertClass} alert-dismissible fade show position-fixed`;
    alertDiv.style.cssText = 'top: 80px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = `
        <i class="fas ${iconClass} me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(alertDiv);
    setTimeout(() => alertDiv.remove(), 3000);
}
    
    function validatePassword() {
        var newPass = document.getElementById('newPassword').value;
        var confirmPass = document.getElementById('confirmPassword').value;
        
        if (newPass.length < 6) {
            alert('Mật khẩu mới phải có ít nhất 6 ký tự!');
            return false;
        }
        
        if (newPass !== confirmPass) {
            alert('Mật khẩu xác nhận không khớp!');
            return false;
        }
        
        return true;
    }
    
    // Active tab từ URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');
    if (tab) {
        const tabTrigger = document.querySelector(`#profileTabs [data-bs-toggle="pill"][href="#${tab}"]`);
        if (tabTrigger) {
            const bsTab = new bootstrap.Tab(tabTrigger);
            bsTab.show();
        }
    }
</script>
</body>
</html>