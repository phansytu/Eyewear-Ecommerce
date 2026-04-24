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
    <title>Quản lý Sản phẩm - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Reset và tối ưu hiệu suất */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            background-color: #f4f6f9; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .wrapper { 
            display: flex; 
            width: 100%; 
            align-items: stretch; 
        }
        
        .sidebar { 
            min-width: 250px; 
            max-width: 250px; 
            background: #343a40; 
            color: #fff; 
            min-height: 100vh; 
            position: sticky; 
            top: 0; 
        }
        
        .sidebar a { 
            color: #c2c7d0; 
            text-decoration: none; 
            padding: 15px 20px; 
            display: block; 
            border-left: 3px solid transparent;
        }
        
        .sidebar a:hover, .sidebar a.active { 
            background: #494e53; 
            color: #fff; 
            border-left: 3px solid #007bff; 
        }
        
        .main-content { 
            width: 100%; 
            padding: 20px; 
        }
        
        .card { 
            border: none; 
            border-radius: 8px; 
            box-shadow: 0 0 15px rgba(0,0,0,.05); 
            margin-bottom: 24px; 
        }
        
        .stat-card { 
            border-left: 4px solid; 
            transition: transform 0.2s; 
            cursor: pointer; 
        }
        
        .stat-card:hover { 
            transform: translateY(-3px); 
        }
        
        .stat-card.primary { border-color: #007bff; }
        .stat-card.success { border-color: #28a745; }
        .stat-card.warning { border-color: #ffc107; }
        .stat-card.danger { border-color: #dc3545; }
        
        .btn-action { 
            width: 32px; 
            height: 32px; 
            display: inline-flex; 
            align-items: center; 
            justify-content: center; 
            border-radius: 6px; 
            border: none; 
            margin: 0 2px;
        }
        
        .product-img { 
            width: 45px; 
            height: 45px; 
            object-fit: cover; 
            border-radius: 8px; 
            border: 1px solid #dee2e6; 
        }
        
        .image-preview img { 
            max-width: 100%; 
            max-height: 250px; 
            border-radius: 8px; 
            object-fit: contain; 
        }
        
        .badge-active { 
            background-color: #d4edda; 
            color: #155724; 
            border: 1px solid #c3e6cb; 
        }
        
        .badge-inactive { 
            background-color: #f8d7da; 
            color: #721c24; 
            border: 1px solid #f5c6cb; 
        }
        
        /* Modal scroll */
        .modal-body-custom {
            max-height: 65vh;
            overflow-y: auto;
            padding: 20px;
        }
        
        /* Hiệu ứng hover mượt */
        .table tbody tr {
            transition: background-color 0.2s;
        }
        
        .table tbody tr:hover {
            background-color: rgba(0,123,255,0.05);
        }
        /* Tối ưu hiệu suất render */
.card, .stat-card, .btn, .product-img {
    will-change: transform;
    backface-visibility: hidden;
    -webkit-font-smoothing: antialiased;
}

.table tbody tr {
    transform: translateZ(0);
}

.modal-content {
    animation: none !important;
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
            <a href="${root}/admin/products" class="active"><i class="fa-solid fa-box me-3"></i>Sản phẩm</a>
            <a href="${root}/admin/orders"><i class="fa-solid fa-cart-shopping me-3"></i>Đơn hàng</a>
            <a href="${root}/admin/users"><i class="fa-solid fa-users me-3"></i>Khách hàng</a>
            <a href="${root}/logout" class="mt-5 text-danger"><i class="fa-solid fa-sign-out-alt me-3"></i>Đăng xuất</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h3 mb-0">Quản lý Sản phẩm</h2>
            <div>
                <a href="${root}/admin/products" class="btn btn-outline-primary me-2">
                    <i class="fa-solid fa-rotate me-2"></i>Làm mới
                </a>
                <button class="btn btn-success shadow-sm" data-bs-toggle="modal" data-bs-target="#addProductModal">
                    <i class="fa-solid fa-plus me-2"></i>Thêm sản phẩm
                </button>
            </div>
        </div>

        <!-- Thống kê sản phẩm -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card primary h-100">
                    <div class="card-body">
                        <div class="text-uppercase text-primary small fw-bold mb-1">Tổng sản phẩm</div>
                        <div class="h3 mb-0 fw-bold">${totalProducts}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card success h-100">
                    <div class="card-body">
                        <div class="text-uppercase text-success small fw-bold mb-1">Đang hoạt động</div>
                        <div class="h3 mb-0 fw-bold">${activeProducts}</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card warning h-100">
                    <div class="card-body">
                        <div class="text-uppercase text-warning small fw-bold mb-1">Sắp hết hàng</div>
                        <div class="h3 mb-0 fw-bold">${lowStockProducts}</div>
                        <small class="text-muted">(Stock &lt; 10)</small>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card danger h-100">
                    <div class="card-body">
                        <div class="text-uppercase text-danger small fw-bold mb-1">Hết hàng</div>
                        <div class="h3 mb-0 fw-bold">${outOfStockProducts}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bộ lọc -->
        <div class="card">
            <div class="card-body">
                <form action="${root}/admin/products" method="GET" class="row g-3 align-items-center" id="filterForm">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="fa-solid fa-search"></i></span>
                            <input type="text" name="search" class="form-control border-start-0" 
                                   placeholder="Tìm theo tên, thương hiệu..." value="${searchValue}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select name="categoryId" class="form-select">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Đã ẩn</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-grow-1">Lọc</button>
                            <c:if test="${not empty param.search or not empty param.categoryId or not empty param.status}">
                                <a href="${root}/admin/products" class="btn btn-secondary">Xóa lọc</a>
                            </c:if>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Danh sách sản phẩm -->
        <div class="card">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold text-primary">Danh sách sản phẩm</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="selectAll"></th>
                                <th style="width: 60px;">ID</th>
                                <th style="width: 70px;">Ảnh</th>
                                <th>Thông tin sản phẩm</th>
                                <th>Danh mục</th>
                                <th>Giá bán</th>
                                <th>Tồn kho</th>
                                <th>Trạng thái</th>
                                <th style="width: 110px;" class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td><input type="checkbox" class="product-checkbox" value="${product.id}"></td>
                                    <td>${product.id}</span></td>
                                    <td>
                                        <img src="${root}${not empty product.image ? product.image : '/image/anhdanhmuc/no-image.png'}" 
                                             class="product-img" 
                                             onerror="this.src='${root}/image/anhdanhmuc/no-image.png'"
                                             alt="${product.name}">
                                    </td>
                                    <td>
                                        <div class="fw-bold">${product.name}</div>
                                        <small class="text-muted">${product.brand != null ? product.brand : 'Không có thương hiệu'}</small>
                                    </div>
                                    </td>
                                    <td>${product.categoryName != null ? product.categoryName : 'Chưa phân loại'}</span></td>
                                    <td>
                                        <div class="text-danger fw-bold">
                                            <fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>₫
                                        </div>
                                        <c:if test="${product.price > product.salePrice}">
                                            <small class="text-decoration-line-through"><fmt:formatNumber value="${product.price}" pattern="#,###"/>₫</small>
                                        </c:if>
                                    </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.stock <= 0}"><span class="badge bg-danger">Hết</span></c:when>
                                            <c:when test="${product.stock <= 10}"><span class="badge bg-warning">${product.stock}</span></c:when>
                                            <c:otherwise><span class="badge bg-success">${product.stock}</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 'active'}">
                                                <span class="badge badge-active">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive">Ẩn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center">
                                            <button class="btn btn-info btn-sm text-white edit-product" 
                                                    data-id="${product.id}"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#addProductModal"
                                                    title="Sửa">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${product.status == 'active'}">
                                                    <a href="${root}/admin/products?action=hide&id=${product.id}" 
                                                       class="btn btn-warning btn-sm" 
                                                       onclick="return confirm('Ẩn sản phẩm này?')"
                                                       title="Ẩn">
                                                        <i class="fa-solid fa-eye-slash"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${root}/admin/products?action=show&id=${product.id}" 
                                                       class="btn btn-success btn-sm" 
                                                       onclick="return confirm('Hiển thị sản phẩm này?')"
                                                       title="Hiện">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="${root}/admin/products?action=delete&id=${product.id}" 
                                               class="btn btn-danger btn-sm" 
                                               onclick="return confirm('Xóa vĩnh viễn?')"
                                               title="Xóa">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </div>
                                    </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty products}">
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-box-open fa-3x mb-2 d-block"></i>
                                        Không có sản phẩm nào
                                    </div>
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

<!-- Modal Thêm/Sửa sản phẩm -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <form method="POST" action="${root}/admin/products" enctype="multipart/form-data" id="productForm">
                <div class="modal-header bg-primary text-white py-3">
                    <h5 class="modal-title">
                        <i class="fa-solid fa-box-open me-2"></i>
                        <span id="modalTitle">Thêm sản phẩm mới</span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body-custom">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="id" id="productId" value="">
                    <input type="hidden" name="existingImage" id="existingImage" value="">
                    
                    <div class="row g-4">
                        <div class="col-md-8">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label fw-bold">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="name" id="productName" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Thương hiệu</label>
                                    <input type="text" class="form-control" name="brand" id="productBrand">
                                </div>
                            </div>

                            <div class="row g-3 mt-2">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Danh mục <span class="text-danger">*</span></label>
                                    <select name="categoryId" id="productCategory" class="form-select" required>
                                        <option value="">-- Chọn danh mục --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}">${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Số lượng <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="stock" id="productStock" value="0" required min="0">
                                </div>
                            </div>

                            <div class="row g-3 mt-2">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Giá niêm yết <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="price" id="productPrice" required min="0">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Giá khuyến mãi</label>
                                    <input type="number" class="form-control" name="salePrice" id="productSalePrice" value="0" min="0">
                                    <small class="text-muted">Để 0 nếu không giảm giá</small>
                                </div>
                            </div>

                            <div class="row g-3 mt-2">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Giới tính</label>
                                    <select name="gender" id="productGender" class="form-select">
                                        <option value="">-- Chọn --</option>
                                        <option value="Nam">Nam</option>
                                        <option value="Nữ">Nữ</option>
                                        <option value="Unisex">Unisex</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Chất liệu gọng</label>
                                    <select name="frameMaterial" id="productFrameMaterial" class="form-select">
                                        <option value="">-- Chọn --</option>
                                        <option value="Titanium">Titanium</option>
                                        <option value="Acetate">Acetate</option>
                                        <option value="Metal">Metal</option>
                                        <option value="Plastic">Plastic</option>
                                        <option value="TR90">TR90</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row g-3 mt-2">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Loại tròng</label>
                                    <select name="lensType" id="productLensType" class="form-select">
                                        <option value="">-- Chọn --</option>
                                        <option value="Chống ánh sáng xanh">Chống ánh sáng xanh</option>
                                        <option value="Phân cực">Phân cực</option>
                                        <option value="Đổi màu">Đổi màu</option>
                                        <option value="Thường">Thường</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mt-3">
                                <label class="form-label fw-bold">Mô tả chi tiết</label>
                                <textarea name="description" class="form-control" rows="4" id="productDescription"></textarea>
                            </div>
                        </div>
                        
                        <div class="col-md-4 bg-light p-3 rounded">
                            <label class="form-label fw-bold">Ảnh đại diện</label>
                            <div class="image-preview border rounded bg-white d-flex align-items-center justify-content-center mb-3" 
                                 style="height: 220px; background: #f8f9fa;">
                                <img src="" id="previewImg" style="max-height: 100%; object-fit: contain; display: none;">
                                <div class="text-center text-muted" id="placeholder">
                                    <i class="fas fa-cloud-upload-alt fa-4x mb-2"></i>
                                    <p class="small mb-0">Chọn ảnh tải lên</p>
                                </div>
                            </div>
                            <input type="file" class="form-control" name="mainImage" id="mainImage" accept="image/*">
                            <small class="text-muted">PNG, JPG (Tối đa 5MB)</small>
                            
                            <hr>
                            
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" name="isFeatured" id="isFeatured" value="true">
                                <label class="form-check-label" for="isFeatured"> Sản phẩm nổi bật</label>
                            </div>
                            
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="uvProtection" id="uvProtection" value="true">
                                <label class="form-check-label" for="uvProtection"> Chống tia UV</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="fas fa-save me-2"></i> Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function() {
        'use strict';
        
        // Select all checkbox
        const selectAllCheckbox = document.getElementById('selectAll');
        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', function() {
                document.querySelectorAll('.product-checkbox').forEach(cb => cb.checked = this.checked);
            });
        }
        
        // Preview image
        const mainImage = document.getElementById('mainImage');
        if (mainImage) {
            mainImage.addEventListener('change', function(e) {
                const file = e.target.files[0];
                const preview = document.getElementById('previewImg');
                const placeholder = document.getElementById('placeholder');
                
                if (file && file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                        if (placeholder) placeholder.style.display = 'none';
                    };
                    reader.readAsDataURL(file);
                } else {
                    preview.style.display = 'none';
                    if (placeholder) placeholder.style.display = 'block';
                    if (file) alert('Vui lòng chọn file ảnh hợp lệ!');
                }
            });
        }
        
        // Edit product
        document.querySelectorAll('.edit-product').forEach(btn => {
            btn.addEventListener('click', function() {
                const productId = this.dataset.id;
                
                fetch('${root}/admin/products?action=get&id=' + productId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const p = data.product;
                            document.getElementById('formAction').value = 'update';
                            document.getElementById('productId').value = p.id;
                            document.getElementById('productName').value = p.name || '';
                            document.getElementById('productBrand').value = p.brand || '';
                            document.getElementById('productCategory').value = p.categoryId || '';
                            document.getElementById('productStock').value = p.stock || 0;
                            document.getElementById('productPrice').value = p.price || 0;
                            document.getElementById('productSalePrice').value = p.salePrice || 0;
                            document.getElementById('productDescription').value = p.description || '';
                            document.getElementById('productGender').value = p.gender || '';
                            document.getElementById('productFrameMaterial').value = p.frameMaterial || '';
                            document.getElementById('productLensType').value = p.lensType || '';
                            document.getElementById('isFeatured').checked = p.featured === true;
                            document.getElementById('uvProtection').checked = p.uvProtection === true;
                            document.getElementById('existingImage').value = p.image || '';
                            document.getElementById('modalTitle').innerText = 'Chỉnh sửa sản phẩm';
                            
                            if (p.image) {
                                const preview = document.getElementById('previewImg');
                                const placeholder = document.getElementById('placeholder');
                                preview.src = '${root}' + p.image;
                                preview.style.display = 'block';
                                if (placeholder) placeholder.style.display = 'none';
                            }
                        } else {
                            alert('Không thể tải thông tin sản phẩm!');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra!');
                    });
            });
        });
        
        // Reset modal on close
        const modal = document.getElementById('addProductModal');
        if (modal) {
            modal.addEventListener('hidden.bs.modal', function() {
                document.getElementById('productForm').reset();
                document.getElementById('formAction').value = 'add';
                document.getElementById('productId').value = '';
                document.getElementById('existingImage').value = '';
                document.getElementById('modalTitle').innerText = 'Thêm sản phẩm mới';
                document.getElementById('previewImg').style.display = 'none';
                const placeholder = document.getElementById('placeholder');
                if (placeholder) placeholder.style.display = 'block';
            });
        }
        
        // Validate form
        const productForm = document.getElementById('productForm');
        if (productForm) {
            productForm.addEventListener('submit', function(e) {
                const price = parseFloat(document.getElementById('productPrice').value) || 0;
                const salePrice = parseFloat(document.getElementById('productSalePrice').value) || 0;
                
                if (salePrice > price) {
                    e.preventDefault();
                    alert('Giá khuyến mãi không thể lớn hơn giá niêm yết!');
                    return false;
                }
                
                const fileInput = document.getElementById('mainImage');
                const action = document.getElementById('formAction').value;
                
                if (action === 'add' && (!fileInput.files || fileInput.files.length === 0)) {
                    e.preventDefault();
                    alert('Vui lòng chọn ảnh cho sản phẩm!');
                    return false;
                }
                
                return true;
            });
        }
    })();
</script>
</body>
</html>