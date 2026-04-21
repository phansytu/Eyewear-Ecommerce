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
        
        .btn-action { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: none; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #dee2e6; }
        .image-preview img { max-width: 100%; max-height: 250px; border-radius: 8px; object-fit: contain; }
        
        .badge-active { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-inactive { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .filter-active {
            background-color: #007bff !important;
            color: white !important;
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
            <h2 class="h3 mb-0 text-gray-800">Quản lý Sản phẩm</h2>
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
        <div class="row">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card primary h-100 py-2">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng sản phẩm</div>
                        <div class="h5 mb-0 font-weight-bold">${totalProducts} Sản phẩm</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card success h-100 py-2">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Đang hoạt động</div>
                        <div class="h5 mb-0 font-weight-bold">${activeProducts} Sản phẩm</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card warning h-100 py-2">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Sắp hết hàng</div>
                        <div class="h5 mb-0 font-weight-bold">${lowStockProducts} Sản phẩm</div>
                        <small class="text-muted">(Stock &lt; 10)</small>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card danger h-100 py-2">
                    <div class="card-body">
                        <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Hết hàng</div>
                        <div class="h5 mb-0 font-weight-bold">${outOfStockProducts} Sản phẩm</div>
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
                                <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>
                                    ${cat.name}
                                </option>
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
                            <button type="submit" class="btn btn-primary flex-grow-1">Lọc dữ liệu</button>
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
                <h6 class="m-0 font-weight-bold text-primary">Danh sách sản phẩm</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="productsTable">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" id="selectAll"></th>
                                <th style="width: 70px;">ID</th>
                                <th style="width: 80px;">Ảnh</th>
                                <th>Thông tin sản phẩm</th>
                                <th>Danh mục</th>
                                <th>Giá bán</th>
                                <th>Tồn kho</th>
                                <th>Trạng thái</th>
                                <th style="width: 120px;" class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td><input type="checkbox" class="product-checkbox" value="${product.id}"></td>
                                    <td><span class="text-muted">${product.id}</span></td>
                                    <td>
                                        <%-- SỬA ĐƯỜNG DẪN ẢNH ĐÚNG VỚI THƯ MỤC image/anhdanhmuc --%>
                                        <c:choose>
                                            <c:when test="${not empty product.image}">
                                                <img src="${root}/${product.image}" 
                                                     class="product-img" 
                                                     onerror="this.src='${root}/image/anhdanhmuc/no-image.png'"
                                                     alt="${product.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${root}/image/anhdanhmuc/no-image.png" 
                                                     class="product-img" 
                                                     alt="No image">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">${product.name}</div>
                                        <small class="text-muted">
                                            <i class="fa-solid fa-tag me-1"></i>${product.brand != null ? product.brand : 'Không có thương hiệu'}
                                        </small>
                                     </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary">${product.categoryName != null ? product.categoryName : 'Chưa phân loại'}</span>
                                    </td>
                                    <td>
                                        <div class="text-danger fw-bold">
                                            <fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>₫
                                        </div>
                                        <c:if test="${product.price > product.salePrice}">
                                            <small class="text-decoration-line-through text-muted">
                                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                                            </small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.stock <= 0}">
                                                <span class="badge bg-danger">Hết hàng</span>
                                            </c:when>
                                            <c:when test="${product.stock <= 10}">
                                                <span class="badge bg-warning text-dark">Còn ${product.stock}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">${product.stock}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 'active'}">
                                                <span class="badge badge-active">Đang hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive">Đã ẩn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-info text-white btn-action edit-product" 
                                                    data-id="${product.id}"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#addProductModal">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${product.status == 'active'}">
                                                    <a href="${root}/admin/products?action=hide&id=${product.id}" 
                                                       class="btn btn-warning btn-action" 
                                                       onclick="return confirm('Ẩn sản phẩm này?')">
                                                        <i class="fa-solid fa-eye-slash"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${root}/admin/products?action=show&id=${product.id}" 
                                                       class="btn btn-success btn-action" 
                                                       onclick="return confirm('Hiển thị sản phẩm này?')">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="${root}/admin/products?action=delete&id=${product.id}" 
                                               class="btn btn-danger btn-action" 
                                               onclick="return confirm('Xóa vĩnh viễn sản phẩm này? Hành động này không thể hoàn tác!')">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty products}">
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-box-open fa-3x mb-3 d-block"></i>
                                        Không có sản phẩm nào
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
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content shadow-lg">
            <form method="POST" action="${root}/admin/products" enctype="multipart/form-data" id="productForm">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fa-solid fa-box-open me-2"></i>
                        <span id="modalTitle">Thêm sản phẩm mới</span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="id" id="productId" value="">
                    
                    <div class="row g-4">
                        <div class="col-md-8">
                            <div class="row g-3 mb-3">
                                <div class="col-md-8">
                                    <label class="form-label fw-bold">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="name" id="productName" 
                                           placeholder="VD: Kính mát Ray-Ban Aviator..." required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold">Thương hiệu</label>
                                    <input type="text" class="form-control" name="brand" id="productBrand" 
                                           placeholder="VD: Ray-Ban, Gucci...">
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
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
                                    <label class="form-label fw-bold">Số lượng tồn kho <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="stock" id="productStock" 
                                           value="0" required min="0">
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Giá niêm yết (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="price" id="productPrice" 
                                           required min="0">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Giá khuyến mãi (VNĐ)</label>
                                    <input type="number" class="form-control" name="salePrice" id="productSalePrice" 
                                           value="0" min="0">
                                    <small class="text-muted">Để 0 nếu không giảm giá</small>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Giới tính</label>
                                    <select name="gender" id="productGender" class="form-select">
                                        <option value="">-- Chọn giới tính --</option>
                                        <option value="Nam">Nam</option>
                                        <option value="Nữ">Nữ</option>
                                        <option value="Unisex">Unisex</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Chất liệu gọng</label>
                                    <select name="frameMaterial" id="productFrameMaterial" class="form-select">
                                        <option value="">-- Chọn chất liệu --</option>
                                        <option value="Titanium">Titanium</option>
                                        <option value="Acetate">Acetate</option>
                                        <option value="Metal">Metal</option>
                                        <option value="Plastic">Plastic</option>
                                        <option value="TR90">TR90</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Loại tròng</label>
                                    <select name="lensType" id="productLensType" class="form-select">
                                        <option value="">-- Chọn loại tròng --</option>
                                        <option value="Chống ánh sáng xanh">Chống ánh sáng xanh</option>
                                        <option value="Phân cực">Phân cực</option>
                                        <option value="Đổi màu">Đổi màu</option>
                                        <option value="Thường">Thường</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Mô tả chi tiết</label>
                                <textarea name="description" class="form-control" rows="4" id="productDescription" 
                                          placeholder="Nhập chất liệu, màu sắc, thiết kế..."></textarea>
                            </div>
                        </div>
                        
                        <div class="col-md-4 bg-light p-3 rounded shadow-sm">
                            <label class="form-label fw-bold">Ảnh đại diện</label>
                            <div class="image-preview border rounded bg-white d-flex align-items-center justify-content-center mb-3" 
                                 style="height: 250px; overflow: hidden; background: #f8f9fa;">
                                <img src="" id="previewImg" class="img-fluid" style="max-height: 100%; object-fit: contain; display: none;">
                                <div class="text-center text-muted" id="placeholder">
                                    <i class="fas fa-cloud-upload-alt fa-4x mb-2"></i>
                                    <p class="small mb-0">Chọn ảnh tải lên</p>
                                    <p class="small text-muted">PNG, JPG, JPEG (Tối đa 5MB)</p>
                                </div>
                            </div>
                            <input type="file" class="form-control" name="mainImage" id="mainImage" accept="image/jpeg,image/png,image/jpg">
                            <small class="text-muted d-block mt-2">Khuyên dùng ảnh vuông 500x500px</small>
                            
                            <hr class="my-3">
                            
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" name="isFeatured" id="isFeatured" value="true">
                                <label class="form-check-label fw-bold" for="isFeatured">
                                    <i class="fa-solid fa-star text-warning me-1"></i> Sản phẩm nổi bật
                                </label>
                            </div>
                            
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="uvProtection" id="uvProtection" value="true">
                                <label class="form-check-label fw-bold" for="uvProtection">
                                    <i class="fa-solid fa-sun me-1 text-primary"></i> Chống tia UV
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="fas fa-save me-2"></i> Lưu sản phẩm
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Select all checkbox
    document.getElementById('selectAll')?.addEventListener('change', function() {
        document.querySelectorAll('.product-checkbox').forEach(cb => cb.checked = this.checked);
    });

    // Preview image
    document.getElementById('mainImage')?.addEventListener('change', function(e) {
        const file = e.target.files[0];
        const preview = document.getElementById('previewImg');
        const placeholder = document.getElementById('placeholder');
        
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
                if(placeholder) placeholder.style.display = 'none';
            };
            reader.readAsDataURL(file);
        } else {
            preview.style.display = 'none';
            if(placeholder) placeholder.style.display = 'block';
        }
    });

    // Edit product - fetch data via AJAX
    document.querySelectorAll('.edit-product').forEach(btn => {
        btn.addEventListener('click', function() {
            const productId = this.dataset.id;
            
            // Fetch product data
            fetch('${root}/admin/products?action=get&id=' + productId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const product = data.product;
                        
                        // Set form values
                        document.getElementById('formAction').value = 'update';
                        document.getElementById('productId').value = product.id;
                        document.getElementById('productName').value = product.name;
                        document.getElementById('productBrand').value = product.brand || '';
                        document.getElementById('productCategory').value = product.categoryId;
                        document.getElementById('productStock').value = product.stock;
                        document.getElementById('productPrice').value = product.price;
                        document.getElementById('productSalePrice').value = product.salePrice || 0;
                        document.getElementById('productDescription').value = product.description || '';
                        document.getElementById('productGender').value = product.gender || '';
                        document.getElementById('productFrameMaterial').value = product.frameMaterial || '';
                        document.getElementById('productLensType').value = product.lensType || '';
                        document.getElementById('isFeatured').checked = product.isFeatured === true;
                        document.getElementById('uvProtection').checked = product.uvProtection === true;
                        document.getElementById('modalTitle').innerText = 'Chỉnh sửa sản phẩm';
                        
                        // Show current image
                        if (product.image) {
                            const preview = document.getElementById('previewImg');
                            const placeholder = document.getElementById('placeholder');
                            preview.src = '${root}' + product.image;
                            preview.style.display = 'block';
                            if(placeholder) placeholder.style.display = 'none';
                        }
                    } else {
                        alert('Không thể tải thông tin sản phẩm!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi tải thông tin sản phẩm!');
                });
        });
    });
    
    // Reset form when modal is closed
    document.getElementById('addProductModal')?.addEventListener('hidden.bs.modal', function() {
        document.getElementById('productForm').reset();
        document.getElementById('formAction').value = 'add';
        document.getElementById('productId').value = '';
        document.getElementById('modalTitle').innerText = 'Thêm sản phẩm mới';
        document.getElementById('previewImg').style.display = 'none';
        const placeholder = document.getElementById('placeholder');
        if(placeholder) placeholder.style.display = 'block';
    });
    
    // Validate form before submit
    document.getElementById('productForm')?.addEventListener('submit', function(e) {
        const price = parseFloat(document.getElementById('productPrice').value);
        const salePrice = parseFloat(document.getElementById('productSalePrice').value);
        
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
</script>
</body>
</html>