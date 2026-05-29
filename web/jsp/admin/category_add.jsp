<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm danh mục - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${root}/css/style.css">
    <style>
        .form-container {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        .form-header {
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .preview-img {
            max-width: 150px;
            max-height: 150px;
            border-radius: 12px;
            border: 2px solid #ddd;
            margin-top: 10px;
        }
        .required {
            color: #dc3545;
        }
        .btn-submit {
            background: linear-gradient(135deg, #00b4d8, #0077b6);
            border: none;
            padding: 12px 30px;
            border-radius: 30px;
        }
        .breadcrumb-custom {
            background: #f8f9fa;
            padding: 12px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<main class="container-fluid px-4 py-4">
    <!-- Breadcrumb -->
    <div class="breadcrumb-custom d-flex justify-content-between align-items-center">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${root}/admin/dashboard"><i class="fas fa-tachometer-alt me-1"></i>Trang chủ Admin</a></li>
                <li class="breadcrumb-item"><a href="${root}/admin/categories">Quản lý danh mục</a></li>
                <li class="breadcrumb-item active">Thêm danh mục</li>
            </ol>
        </nav>
        <span class="admin-badge"><i class="fas fa-user-shield me-1"></i>Quản trị viên</span>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="form-container">
                <div class="form-header">
                    <h3 class="mb-0"><i class="fas fa-plus-circle me-2 text-danger"></i>Thêm danh mục mới</h3>
                    <p class="text-muted mt-2 mb-0">Tạo danh mục sản phẩm mới để phân loại sản phẩm của bạn</p>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i>${success}</div>
                    <script>
                        setTimeout(function() {
                            window.location.href = '${root}/admin/categories';
                        }, 1500);
                    </script>
                </c:if>
                
                <form method="POST" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tên danh mục <span class="required">*</span></label>
                        <input type="text" name="name" class="form-control" value="${oldName}" placeholder="Ví dụ: Kính râm, Kính cận, Kính chống ánh sáng xanh..." required>
                        <div class="form-text">Tên danh mục ngắn gọn, dễ nhớ, không trùng với danh mục khác</div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Danh mục cha</label>
                        <select name="parent_id" class="form-select">
                            <option value="">-- Danh mục gốc --</option>
                            <c:forEach var="pcat" items="${parentCategories}">
                                <option value="${pcat.id}" ${oldParentId == pcat.id ? 'selected' : ''}>${pcat.name}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Chọn danh mục cha nếu muốn tạo danh mục con</div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Mô tả</label>
                        <textarea name="description" class="form-control" rows="4" placeholder="Mô tả chi tiết về danh mục sản phẩm này...">${oldDescription}</textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Hình ảnh đại diện</label>
                        <input type="file" name="image" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp" id="imageInput">
                        <div class="form-text">Hỗ trợ: JPG, PNG, GIF, WEBP. Kích thước tối đa: 2MB</div>
                        <div id="imagePreview"></div>
                    </div>
                    
                    <div class="d-flex gap-3 mt-4">
                        <button type="submit" class="btn btn-submit text-white"><i class="fas fa-save me-2"></i>Lưu danh mục</button>
                        <button type="reset" class="btn btn-outline-secondary"><i class="fas fa-undo me-2"></i>Nhập lại</button>
                        <a href="${root}/admin/categories" class="btn btn-outline-danger">Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('imageInput').addEventListener('change', function(e) {
        const preview = document.getElementById('imagePreview');
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(event) {
                preview.innerHTML = `<img src="\${event.target.result}" class="preview-img">`;
            };
            reader.readAsDataURL(file);
        } else {
            preview.innerHTML = '';
        }
    });
</script>
</body>
</html>