<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .table img { object-fit: cover; border: 1px solid #dee2e6; }
        .image-preview img { max-width: 100%; max-height: 250px; border-radius: 8px; }
        /* Tùy chỉnh thụt lề cho danh mục con */
        select option.child-cat { color: #555; }
        select option.parent-cat { font-weight: bold; color: #000; }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-danger shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold fs-4" href="#"><i class="fas fa-glasses me-2"></i>Quản lý sản phẩm</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${root}/home"><i class="fas fa-home me-1"></i>Public Site</a>
                <a class="nav-link" href="users"><i class="fas fa-users me-1"></i>Người dùng</a>
                <a class="nav-link active" href="products"><i class="fas fa-box me-1"></i>Sản phẩm</a>
                <a class="nav-link" href="${root}/logout"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-xl-2 col-lg-3 mb-4">
                <div class="card shadow-sm sticky-top" style="top: 20px;">
                    <div class="card-header bg-primary text-white font-weight-bold">
                        <i class="fas fa-list me-2"></i>Menu chính
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="products" class="list-group-item list-group-item-action active fw-bold">
                            <i class="fas fa-box me-2"></i>Sản phẩm
                        </a>
                        <a href="categories" class="list-group-item list-group-item-action">
                            <i class="fas fa-tags me-2"></i>Danh mục
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-10 col-lg-9">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0 text-dark fw-bold">Quản lý Sản phẩm</h4>
                                <small class="text-muted">Tổng số: ${products.size()} sản phẩm</small>
                            </div>
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addProductModal">
                                <i class="fas fa-plus me-1"></i>Thêm mới chi tiết
                            </button>
                        </div>
                    </div>
                    
                    <div class="card-body p-0">
                        <div class="p-3 bg-light border-bottom">
                            <form method="GET" class="row g-2">
                                <div class="col-md-5">
                                    <input type="text" name="search" class="form-control" placeholder="Tìm tên, thương hiệu..." value="${param.search}">
                                </div>
                                <div class="col-md-3">
                                    <select name="category" class="form-select">
                                        <option value="">Tất cả danh mục</option>
                                        <c:forEach var="parentCat" items="${categories}">
                                            <option value="${parentCat.id}" class="parent-cat" ${param.category == parentCat.id ? 'selected' : ''}>
                                                ${parentCat.name}
                                            </option>
                                            <c:forEach var="subCat" items="${parentCat.subCategories}">
                                                <option value="${subCat.id}" class="child-cat" ${param.category == subCat.id ? 'selected' : ''}>
                                                    &nbsp;&nbsp;&nbsp;↳ ${subCat.name}
                                                </option>
                                            </c:forEach>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100">Lọc</button>
                                </div>
                            </form>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th><input type="checkbox" id="selectAll"></th>
                                        <th>ID</th>
                                        <th>Ảnh</th>
                                        <th>Thông tin sản phẩm</th>
                                        <th>Giá bán</th>
                                        <th>Kho</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${products}">
                                        <tr>
                                            <td><input type="checkbox" class="product-checkbox" value="${product.id}"></td>
                                            <td><span class="text-muted">#${product.id}</span></td>
                                            <td>
                                                <img src="${not empty product.image ? root.concat(product.image) : 'https://via.placeholder.com/50'}" 
                                                     class="rounded shadow-sm" width="50" height="50">
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark">${product.name}</div>
                                                <small class="text-muted">${product.brand} | Danh mục: <span class="text-primary">${product.categoryName}</span></small>
                                            </td>
                                            <td>
                                                <div class="text-danger fw-bold"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>đ</div>
                                                <c:if test="${product.price gt product.salePrice}">
                                                    <small class="text-decoration-line-through text-muted"><fmt:formatNumber value="${product.price}" pattern="#,###"/>đ</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge ${product.stock > 10 ? 'bg-success' : 'bg-warning'} text-white">
                                                    ${product.stock}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge ${product.status == 'active' ? 'bg-label-success' : 'bg-label-secondary'}" 
                                                      style="background-color: ${product.status == 'active' ? '#e8fadf' : '#ebeef0'}; color: ${product.status == 'active' ? '#71dd37' : '#8592a3'}; padding: 0.5em 0.8em;">
                                                    ${product.status == 'active' ? 'Hoạt động' : 'Ẩn'}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group">
                                                    <button class="btn btn-sm btn-outline-primary quick-edit" data-id="${product.id}"><i class="fas fa-edit"></i></button>
                                                    <c:choose>
                                                        <c:when test="${product.status == 'active'}">
                                                            <a href="?action=hide&id=${product.id}" class="btn btn-sm btn-outline-warning" onclick="return confirm('Ẩn sản phẩm này?')"><i class="fas fa-eye-slash"></i></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="?action=show&id=${product.id}" class="btn btn-sm btn-outline-success" onclick="return confirm('Hiển thị sản phẩm này?')"><i class="fas fa-eye"></i></a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <a href="?action=delete&id=${product.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa vĩnh viễn sản phẩm?')"><i class="fas fa-trash"></i></a>
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
    </div>

    <div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content shadow-lg">
                <form method="POST" action="products" enctype="multipart/form-data">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title"><i class="fas fa-box-open me-2"></i>Khai báo chi tiết sản phẩm</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="${not empty editProduct ? 'update' : 'add'}">
                        <c:if test="${not empty editProduct}"><input type="hidden" name="id" value="${editProduct.id}"></c:if>
                        
                        <div class="row g-4">
                            <div class="col-md-8">
                                <div class="row g-3 mb-3">
                                    <div class="col-md-8">
                                        <label class="form-label fw-bold">Tên sản phẩm *</label>
                                        <input type="text" class="form-control" name="name" value="${editProduct.name}" placeholder="VD: Kính mát Ray-Ban Aviator..." required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Thương hiệu</label>
                                        <input type="text" class="form-control" name="brand" value="${editProduct.brand}" placeholder="VD: Ray-Ban, Gucci...">
                                    </div>
                                </div>

                                <div class="row g-3 mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Phân loại Danh mục *</label>
                                        <select name="categoryId" class="form-select" required>
                                            <option value="">-- Chọn danh mục chi tiết --</option>
                                            <c:forEach var="parentCat" items="${categories}">
                                                <option value="${parentCat.id}" class="parent-cat bg-light" ${editProduct.categoryId == parentCat.id ? 'selected' : ''}>
                                                    [Cha] ${parentCat.name}
                                                </option>
                                                <c:forEach var="subCat" items="${parentCat.subCategories}">
                                                    <option value="${subCat.id}" class="child-cat" ${editProduct.categoryId == subCat.id ? 'selected' : ''}>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;↳ [Con] ${subCat.name}
                                                    </option>
                                                </c:forEach>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Số lượng tồn kho *</label>
                                        <input type="number" class="form-control" name="stock" value="${not empty editProduct ? editProduct.stock : '0'}" required>
                                    </div>
                                </div>

                                <div class="row g-3 mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Giá niêm yết (VNĐ) *</label>
                                        <input type="number" class="form-control" name="price" value="${editProduct.price}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Giá khuyến mãi (VNĐ)</label>
                                        <input type="number" class="form-control" name="salePrice" value="${editProduct.salePrice}">
                                        <small class="text-muted">Để trống hoặc bằng 0 nếu không giảm giá.</small>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Mô tả chi tiết</label>
                                    <textarea name="description" class="form-control" rows="4" placeholder="Nhập chất liệu, màu sắc, thiết kế...">${editProduct.description}</textarea>
                                </div>
                            </div>
                            
                            <div class="col-md-4 bg-light p-3 rounded shadow-sm">
                                <label class="form-label fw-bold">Ảnh đại diện sản phẩm</label>
                                <div class="image-preview border rounded bg-white d-flex align-items-center justify-content-center mb-3" style="height: 250px; overflow: hidden;">
                                    <c:choose>
                                        <c:when test="${not empty editProduct.image}">
                                            <img src="${root}${editProduct.image}" id="previewImg" class="img-fluid">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-muted" id="placeholder">
                                                <i class="fas fa-cloud-upload-alt fa-3x mb-2"></i>
                                                <p class="small">Chọn ảnh tải lên</p>
                                            </div>
                                            <img src="" id="previewImg" class="img-fluid" style="display:none">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="file" class="form-control" name="mainImage" id="mainImage" accept="images/*" ${empty editProduct ? 'required' : ''}>
                                <small class="text-muted d-block mt-1">Hỗ trợ JPG, PNG. Khuyên dùng ảnh vuông 500x500.</small>
                                
                                <hr>
                                <label class="form-label fw-bold">Thuộc tính thêm</label>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input" type="checkbox" name="isFeatured" id="isFeatured" value="true" ${editProduct.isFeatured ? 'checked' : ''}>
                                    <label class="form-check-label" for="isFeatured">Đánh dấu Sản phẩm Nổi bật</label>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" name="uvProtection" id="uvProtection" value="true" ${editProduct.uvProtection ? 'checked' : ''}>
                                    <label class="form-check-label" for="uvProtection">Có khả năng chống tia UV</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary px-4"><i class="fas fa-save me-1"></i> Lưu vào cơ sở dữ liệu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Chọn tất cả Checkbox
        document.getElementById('selectAll').addEventListener('change', function() {
            document.querySelectorAll('.product-checkbox').forEach(cb => cb.checked = this.checked);
        });

        // Xem trước ảnh khi upload
        document.getElementById('mainImage').addEventListener('change', function(e) {
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
            }
        });

        // Xử lý nút Edit (Cần có AJAX thực tế từ Servlet)
        document.querySelectorAll('.quick-edit').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                // Nếu bạn làm chỉnh sửa: Gọi AJAX truyền 'id' xuống Servlet, lấy JSON trả về và đổ vào Form
                // Hoặc điều hướng sang URL /products?action=edit&id=...
                // new bootstrap.Modal(document.getElementById('addProductModal')).show();
                window.location.href = "products?action=edit&id=" + id; 
            });
        });
    </script>
</body>
</html>