<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<%-- Bảo vệ trang admin --%>
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'admin'}">
    <c:redirect url="/login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách hàng - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ... (giữ nguyên style của bạn) ... */
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
        .stat-card.success { border-color: #28a745; }
        .stat-card.warning { border-color: #ffc107; }
        .stat-card.danger { border-color: #dc3545; }
        .stat-card.info { border-color: #17a2b8; }
        
        .btn-action { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: none; }
        .avatar-sm { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
        
        .badge-active { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-inactive { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .badge-locked { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        
        .badge-tier-diamond { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .badge-tier-gold { background: linear-gradient(135deg, #f2994a 0%, #f2c94c 100%); color: white; }
        .badge-tier-silver { background: linear-gradient(135deg, #bdc3c7 0%, #95a5a6 100%); color: white; }
        .badge-tier-bronze { background: linear-gradient(135deg, #cd7f32 0%, #b87333 100%); color: white; }
        .badge-tier-potential { background: #6c757d; color: white; }
        
        .avatar-placeholder {
            width: 40px;
            height: 40px;
            background: #007bff;
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
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="p-4 fs-4 fw-bold text-center border-bottom border-secondary">
            <i class="fa-solid fa-glasses me-2 text-primary"></i>Admin Panel
        </div>
        <div class="mt-3">
            <a href="${root}/admin/dashboard"><i class="fa-solid fa-gauge me-3"></i>Tổng quan</a>
            <a href="${root}/admin/products"><i class="fa-solid fa-box me-3"></i>Sản phẩm</a>
            <a href="${root}/admin/orders"><i class="fa-solid fa-cart-shopping me-3"></i>Đơn hàng</a>
            <a href="${root}/admin/users" class="active"><i class="fa-solid fa-users me-3"></i>Khách hàng</a>
            <a href="${root}/logout" class="mt-5 text-danger"><i class="fa-solid fa-sign-out-alt me-3"></i>Đăng xuất</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h3 mb-0 text-gray-800">Quản lý Khách hàng</h2>
            <div>
                <a href="${root}/admin/users" class="btn btn-outline-primary me-2">
                    <i class="fa-solid fa-rotate me-2"></i>Làm mới
                </a>
                <button class="btn btn-success shadow-sm" onclick="exportToExcel()">
                    <i class="fa-solid fa-file-excel me-2"></i>Xuất Excel
                </button>
            </div>
        </div>

        <!-- Thống kê -->
        <div class="row">
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card primary h-100 py-2" onclick="filterByRole('all')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng người dùng</div>
                        <div class="h5 mb-0 font-weight-bold">${totalUsers}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card success h-100 py-2" onclick="filterByStatus('active')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Đang hoạt động</div>
                        <div class="h5 mb-0 font-weight-bold">${activeUsers}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card warning h-100 py-2" onclick="filterByStatus('locked')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Đã khóa</div>
                        <div class="h5 mb-0 font-weight-bold">${lockedUsers}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card info h-100 py-2" onclick="filterByRole('admin')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Quản trị viên</div>
                        <div class="h5 mb-0 font-weight-bold">${adminUsers}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 mb-4">
                <div class="card stat-card danger h-100 py-2" onclick="filterByTier('vip')">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Khách VIP</div>
                        <div class="h5 mb-0 font-weight-bold">${vipUsers}</div>
                        <small class="text-muted">Chi tiêu > 5tr</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bộ lọc -->
        <div class="card">
            <div class="card-body">
                <form action="${root}/admin/users" method="GET" class="row g-3 align-items-center" id="filterForm">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="fa-solid fa-search"></i></span>
                            <input type="text" name="search" class="form-control border-start-0" 
                                   placeholder="Tìm theo tên, email, SĐT..." value="${searchValue}">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <select name="role" class="form-select">
                            <option value="">Tất cả vai trò</option>
                            <option value="user" ${currentRole == 'user' ? 'selected' : ''}>Khách hàng</option>
                            <option value="admin" ${currentRole == 'admin' ? 'selected' : ''}>Quản trị viên</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" ${currentStatus == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="locked" ${currentStatus == 'locked' ? 'selected' : ''}>Đã khóa</option>
                            <option value="inactive" ${currentStatus == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-grow-1">Lọc dữ liệu</button>
                            <c:if test="${not empty param.search or not empty param.role or not empty param.status}">
                                <a href="${root}/admin/users" class="btn btn-secondary">Xóa lọc</a>
                            </c:if>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Danh sách người dùng -->
        <div class="card">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 font-weight-bold text-primary">Danh sách khách hàng</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="usersTable">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" id="selectAll"></th>
                                <th>ID</th>
                                <th>Avatar</th>
                                <th>Thông tin khách hàng</th>
                                <th>Liên hệ</th>
                                <th>Đơn hàng</th>
                                <th>Tổng chi tiêu</th>
                                <th>Hạng</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td><input type="checkbox" class="user-checkbox" value="${u.id}"></td>
                                    <td><span class="text-muted">${u.id}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty u.avatar}">
                                                <img src="${root}${u.avatar}" class="avatar-sm" onerror="this.src='https://ui-avatars.com/api/?name=${u.username}&background=007bff&color=fff'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="avatar-placeholder">${fn:substring(u.username, 0, 1)}</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">${not empty u.full_name ? u.full_name : u.username}</div>
                                        <small class="text-muted"><i class="fa-regular fa-user me-1"></i>${u.username}</small>
                                        <div><small class="text-muted">Ngày đăng ký: <fmt:formatDate value="${u.createAt}" pattern="dd/MM/yyyy"/></small></div>
                                    </td>
                                    <td>
                                        <div><i class="fa-regular fa-envelope me-1"></i>${u.email}</div>
                                        <div><i class="fa-regular fa-phone me-1"></i>${not empty u.phone ? u.phone : 'Chưa cập nhật'}</div>
                                    </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary">${u.totalOrders} đơn</span>
                                    </div>
                                    </td>
                                    <td>
                                        <div class="text-danger fw-bold">
                                            <fmt:formatNumber value="${u.totalSpent}" pattern="#,###"/>₫
                                        </div>
                                    </div>
                                    </td>
                                    <td>
                                        <span class="badge ${u.tierBadgeClass}">${u.customerTier}</span>
                                    </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'admin'}">
                                                <span class="badge bg-danger"><i class="fa-solid fa-shield-alt me-1"></i>Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary"><i class="fa-regular fa-user me-1"></i>User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'active'}">
                                                <span class="badge badge-active"><i class="fa-regular fa-circle-check me-1"></i>Hoạt động</span>
                                            </c:when>
                                            <c:when test="${u.status == 'locked'}">
                                                <span class="badge badge-locked"><i class="fa-solid fa-lock me-1"></i>Đã khóa</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive"><i class="fa-regular fa-circle-xmark me-1"></i>Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-1 flex-wrap">
                                            <button class="btn btn-info text-white btn-action view-user" 
                                                    data-id="${u.id}"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#viewUserModal">
                                                <i class="fa-solid fa-eye"></i>
                                            </button>
                                            
                                            <c:if test="${u.role != 'admin'}">
                                                <c:choose>
                                                    <c:when test="${u.status == 'active'}">
                                                        <button class="btn btn-warning btn-action" 
                                                                onclick="lockUser(${u.id})"
                                                                title="Khóa tài khoản">
                                                            <i class="fa-solid fa-lock"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-success btn-action" 
                                                                onclick="unlockUser(${u.id})"
                                                                title="Mở khóa">
                                                            <i class="fa-solid fa-unlock"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <button class="btn btn-primary btn-action" 
                                                        onclick="promoteToAdmin(${u.id})"
                                                        title="Nâng cấp lên Admin">
                                                    <i class="fa-solid fa-user-shield"></i>
                                                </button>
                                                
                                                <button class="btn btn-danger btn-action" 
                                                        onclick="deleteUser(${u.id})"
                                                        title="Xóa tài khoản">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="11" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-users-slash fa-3x mb-3 d-block"></i>
                                        Không có người dùng nào
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

<!-- Modal Xem chi tiết người dùng -->
<div class="modal fade" id="viewUserModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa-solid fa-user-circle me-2"></i>Chi tiết khách hàng</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="userDetailContent">
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status"></div>
                    <p>Đang tải thông tin...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ==========================================
    // 1. CHỌN TẤT CẢ CHECKBOX
    // ==========================================
    const selectAllCheckbox = document.getElementById('selectAll');
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            document.querySelectorAll('.user-checkbox').forEach(cb => cb.checked = this.checked);
        });
    }
    
    // ==========================================
    // 2. XEM CHI TIẾT NGƯỜI DÙNG (ĐÃ SỬA LỖI JSTL TRONG JS)
    // ==========================================
    const viewModal = new bootstrap.Modal(document.getElementById('viewUserModal'));
    
    document.querySelectorAll('.view-user').forEach(btn => {
        btn.addEventListener('click', function() {
            const userId = this.dataset.id;
            const contentDiv = document.getElementById('userDetailContent');
            
            // Hiển thị loading
            contentDiv.innerHTML = `
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status"></div>
                    <p class="mt-2">Đang tải thông tin...</p>
                </div>
            `;
            
            viewModal.show();
            
            // Gọi AJAX lấy thông tin user
            fetch('${root}/admin/users?action=get&id=' + userId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const u = data.user;
                        // Format currency
                        const totalSpentFormatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(u.totalSpent || 0);
                        const createDate = u.createAt ? new Date(u.createAt).toLocaleDateString('vi-VN') : 'N/A';
                        const lastLoginDate = u.lastLogin ? new Date(u.lastLogin).toLocaleString('vi-VN') : 'Chưa đăng nhập';
                        
                        // Trong phần xem chi tiết người dùng, thay thế nội dung của contentDiv.innerHTML

contentDiv.innerHTML = `
    <div class="row">
        <div class="col-md-4 text-center">
            <div class="mb-3">
                <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center" 
                     style="width: 120px; height: 120px; font-size: 48px;">
                    ${u.username ? u.username.charAt(0).toUpperCase() : 'U'}
                </div>
            </div>
            <h5>${escapeHtml(u.full_name || u.username)}</h5>
            <p class="text-muted">@${escapeHtml(u.username)}</p>
        </div>
        <div class="col-md-8">
            <table class="table table-bordered">
                <tr><th style="width: 35%">Email</th><td>${escapeHtml(u.email || 'N/A')}</td></tr>
                <tr><th>Số điện thoại</th><td>${escapeHtml(u.phone || 'Chưa cập nhật')}</td></tr>
                <tr><th>Địa chỉ</th><td>${escapeHtml(u.address || 'Chưa cập nhật')}</td></tr>
                <tr><th>Giới tính</th><td>${escapeHtml(u.gender || 'Chưa cập nhật')}</td></tr>
                <tr><th>Ngày sinh</th><td>${escapeHtml(u.dob || 'Chưa cập nhật')}</td></tr>
                <tr><th>Ngày đăng ký</th><td>${createDate}</td></tr>
                <tr><th>Lần đăng nhập cuối</th><td>${lastLoginDate}</td></tr>
                <tr>
                    <th>Vai trò</th>
                    <td>
    <c:choose>
        <c:when test="${u.role == 'admin'}">
            <span class="badge bg-danger">Quản trị viên</span>
        </c:when>
        <c:otherwise>
            <span class="badge bg-secondary">Khách hàng</span>
        </c:otherwise>
    </c:choose>
</td>
                </tr>
                <tr>
                    <th>Trạng thái</th>
                    <td>
    <c:choose>
        <c:when test="${u.status == 'active'}">
            <span class="badge badge-active">Hoạt động</span>
        </c:when>
        <c:when test="${u.status == 'locked'}">
            <span class="badge badge-locked">Đã khóa</span>
        </c:when>
        <c:otherwise>
            <span class="badge badge-inactive">Không hoạt động</span>
        </c:otherwise>
    </c:choose>
</td>
                </tr>
                <tr class="table-info"><th>Tổng đơn hàng</th><td><strong>${u.totalOrders || 0}</strong> đơn</td></tr>
                <tr class="table-info"><th>Tổng chi tiêu</th><td class="text-danger fw-bold">${totalSpentFormatted}</td></tr>
                <tr class="table-warning"><th>Hạng khách hàng</th><td><span class="badge ${u.tierBadgeClass || 'badge-tier-potential'}">${u.customerTier || 'Tiềm năng'}</span></td></tr>
            </table>
        </div>
    </div>
`;
                    } else {
                        contentDiv.innerHTML = `<div class="text-center py-4 text-danger"><i class="fa-solid fa-circle-exclamation fa-3x mb-3"></i><p>${data.message || 'Không thể tải thông tin người dùng'}</p></div>`;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    contentDiv.innerHTML = `<div class="text-center py-4 text-danger"><i class="fa-solid fa-circle-exclamation fa-3x mb-3"></i><p>Có lỗi xảy ra khi tải thông tin!</p></div>`;
                });
        });
    });
    
    // ==========================================
    // 3. KHÓA TÀI KHOẢN
    // ==========================================
    window.lockUser = function(userId) {
        if (confirm('Bạn có chắc chắn muốn KHÓA tài khoản này?\nNgười dùng sẽ không thể đăng nhập.')) {
            fetch('${root}/admin/users', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=lock&userId=' + userId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('Đã khóa tài khoản thành công!', 'success');
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showNotification('Khóa tài khoản thất bại!', 'error');
                }
            })
            .catch(error => showNotification('Có lỗi xảy ra!', 'error'));
        }
    };
    
    // ==========================================
    // 4. MỞ KHÓA TÀI KHOẢN
    // ==========================================
    window.unlockUser = function(userId) {
        if (confirm('Bạn có chắc chắn muốn MỞ KHÓA tài khoản này?\nNgười dùng sẽ có thể đăng nhập lại.')) {
            fetch('${root}/admin/users', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=unlock&userId=' + userId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('Đã mở khóa tài khoản thành công!', 'success');
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showNotification('Mở khóa tài khoản thất bại!', 'error');
                }
            })
            .catch(error => showNotification('Có lỗi xảy ra!', 'error'));
        }
    };
    
    // ==========================================
    // 5. NÂNG CẤP LÊN ADMIN
    // ==========================================
    window.promoteToAdmin = function(userId) {
        if (confirm('⚠️ CẢNH BÁO: Bạn có chắc chắn muốn nâng cấp tài khoản này lên QUẢN TRỊ VIÊN?\nNgười dùng này sẽ có toàn quyền quản trị hệ thống.')) {
            fetch('${root}/admin/users', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=changeRole&userId=' + userId + '&newRole=admin'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('Đã nâng cấp lên Quản trị viên!', 'success');
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showNotification('Nâng cấp thất bại!', 'error');
                }
            })
            .catch(error => showNotification('Có lỗi xảy ra!', 'error'));
        }
    };
    
    // ==========================================
    // 6. XÓA TÀI KHOẢN
    // ==========================================
    window.deleteUser = function(userId) {
        if (confirm('⚠️ CẢNH BÁO: Bạn có chắc chắn muốn XÓA tài khoản này?\nHành động này KHÔNG THỂ HOÀN TÁC!')) {
            fetch('${root}/admin/users', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=delete&userId=' + userId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('Đã xóa tài khoản thành công!', 'success');
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showNotification('Xóa tài khoản thất bại!', 'error');
                }
            })
            .catch(error => showNotification('Có lỗi xảy ra!', 'error'));
        }
    };
    
    // ==========================================
    // 7. LỌC THEO TRẠNG THÁI / VAI TRÒ
    // ==========================================
    window.filterByStatus = function(status) {
        const statusSelect = document.querySelector('select[name="status"]');
        const roleSelect = document.querySelector('select[name="role"]');
        if (statusSelect) {
            statusSelect.value = status;
            roleSelect.value = '';
            document.getElementById('filterForm').submit();
        }
    };
    
    window.filterByRole = function(role) {
        const roleSelect = document.querySelector('select[name="role"]');
        const statusSelect = document.querySelector('select[name="status"]');
        if (roleSelect) {
            roleSelect.value = role === 'all' ? '' : role;
            statusSelect.value = '';
            document.getElementById('filterForm').submit();
        }
    };
    
    window.filterByTier = function(tier) {
        if (tier === 'vip') {
            window.location.href = '${root}/admin/users?search=vip';
        }
    };
    
    // ==========================================
    // 8. XUẤT EXCEL
    // ==========================================
    window.exportToExcel = function() {
        let table = document.getElementById('usersTable');
        let html = table.outerHTML;
        let url = 'data:application/vnd.ms-excel,' + encodeURIComponent(html);
        let link = document.createElement('a');
        link.download = 'users_' + new Date().toISOString().slice(0,19) + '.xls';
        link.href = url;
        link.click();
    };
    
    // ==========================================
    // 9. HIỂN THỊ THÔNG BÁO
    // ==========================================
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
    
    // ==========================================
    // 10. TỰ ĐỘNG SUBMIT FORM KHI THAY ĐỔI FILTER
    // ==========================================
    document.querySelectorAll('select[name="role"], select[name="status"]').forEach(select => {
        select.addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
    });
</script>
</body>
</html>