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
        .admin-top-bar {
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            color: white;
            padding: 10px 0;
            font-size: 14px;
        }
        .admin-badge {
            background: #dc3545;
            padding: 5px 15px;
            border-radius: 30px;
            font-size: 12px;
        }
        .form-container {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .form-header {
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .form-header h3 {
            font-size: 22px;
            font-weight: 600;
            color: #333;
        }
        .form-label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }
        .required {
            color: #dc3545;
        }
        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #ddd;
            padding: 10px 15px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220,53,69,0.1);
        }
        .btn-submit {
            background: linear-gradient(135deg, #00b4d8, #0077b6);
            border: none;
            padding: 12px 30px;
            border-radius: 30px;
            font-weight: 500;
        }
        .btn-submit:hover {
            background: linear-gradient(135deg, #0096b8, #005f8c);
        }
        .preview-img {
            max-width: 150px;
            max-height: 150px;
            border-radius: 12px;
            border: 2px solid #28a745;
            margin-top: 10px;
            padding: 5px;
        }
        .info-sidebar {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            position: sticky;
            top: 20px;
        }
        .info-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }
        .btn-back {
            width: 100%;
            padding: 10px;
            border-radius: 30px;
            background: #f8f9fa;
            color: #333;
            text-align: center;
            text-decoration: none;
            display: block;
            margin-top: 15px;
        }
        .btn-back:hover {
            background: #e9ecef;
            color: #dc3545;
        }
        .breadcrumb-custom {
            background: #f8f9fa;
            padding: 12px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<div class="admin-top-bar">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center">
            <div><i class="fas fa-glasses me-2"></i> Eyeglass Store Admin</div>
            <div><i class="fas fa-user-shield me-1"></i> Xin chào, Admin<span class="admin-badge ms-2">Quản trị viên</span></div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/header.jsp" />

<main class="container-fluid px-4 py-4">
    
    <div class="breadcrumb-custom">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${root}/admin/dashboard"><i class="fas fa-tachometer-alt me-1"></i>Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${root}/admin/categories"><i class="fas fa-folder-open me-1"></i>Quản lý danh mục</a></li>
                <li class="breadcrumb-item active"><i class="fas fa-plus-circle me-1"></i>Sửa danh mục</li>
            </ol>
        </nav>
    </div>
    
    <div class="row g-4">
        <div class="col-lg-3">
            <div class="info-sidebar">
                <h3 class="info-title"><i class="fas fa-info-circle me-2"></i>Hướng dẫn</h3>
                <p class="text-muted small">Điền đầy đủ thông tin bên dưới để thêm danh mục mới.</p>
                <hr>
                <div class="help-text mb-2"><i class="fas fa-tag me-1"></i> Tên danh mục: bắt buộc</div>
                <div class="help-text mb-2"><i class="fas fa-tree me-1"></i> Danh mục cha: tùy chọn</div>
                <div class="help-text mb-2"><i class="fas fa-image me-1"></i> Hình ảnh: tối đa 2MB</div>
                <hr>
                <a href="${root}/admin/categories" class="btn-back"><i class="fas fa-arrow-left me-2"></i>Quay lại danh sách</a>
            </div>
        </div>
        
        <div class="col-lg-9">
            <div class="form-container">
                <div class="form-header">
                    <h3><i class="fas fa-plus-circle me-2 text-danger"></i>Sửa danh mục mới</h3>
                    <p class="text-muted mt-2 mb-0">Tạo danh mục sản phẩm mới để phân loại sản phẩm</p>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i>${success}</div>
                    <script>setTimeout(function(){ window.location.href='${root}/admin/categories'; },1500);</script>
                </c:if>
                
                <form method="POST" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục <span class="required">*</span></label>
                        <input type="text" name="name" class="form-control" value="${oldName}" placeholder="Ví dụ: Kính râm, Kính cận..." required>
                        <div class="help-text">Tên danh mục ngắn gọn, dễ nhớ, không trùng với danh mục khác</div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Danh mục cha</label>
                        <select name="parent_id" class="form-select">
                            <option value="0">-- Danh mục gốc --</option>
                            <c:forEach var="pcat" items="${parentCategories}">
                                <option value="${pcat.id}" ${oldParentId == pcat.id ? 'selected' : ''}>${pcat.name}</option>
                            </c:forEach>
                        </select>
                        <div class="help-text">Chọn danh mục cha nếu muốn tạo danh mục con</div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="4" placeholder="Mô tả chi tiết về danh mục sản phẩm này...">${oldDescription}</textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Hình ảnh đại diện</label>
                        <input type="file" name="image" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp" id="imageInput">
                        <div class="help-text">Hỗ trợ: JPG, PNG, GIF, WEBP. Kích thước tối đa: 2MB</div>
                        <div id="imagePreview"></div>
                    </div>
                    
                    <div class="d-flex gap-3 mt-4">
                        <button type="submit" class="btn btn-submit text-white"><i class="fas fa-save me-2"></i>Lưu danh mục</button>
                        <button type="reset" class="btn btn-cancel text-white"><i class="fas fa-undo me-2"></i>Nhập lại</button>
                        <a href="${root}/admin/categories" class="btn btn-outline-danger">Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/chatbot.jsp" />
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('imageInput').addEventListener('change', function(e) {
        const preview = document.getElementById('imagePreview');
        const file = e.target.files[0];
        if (file) {
            const allowed = ['image/jpeg','image/png','image/gif','image/webp'];
            if (!allowed.includes(file.type)) {
                alert('Chỉ chấp nhận file ảnh!');
                this.value = '';
                preview.innerHTML = '';
                return;
            }
            if (file.size > 2*1024*1024) {
                alert('Kích thước ảnh tối đa 2MB!');
                this.value = '';
                preview.innerHTML = '';
                return;
            }
            const reader = new FileReader();
            reader.onload = function(event) {
                preview.innerHTML = `<img src="${event.target.result}" class="preview-img">`;
            };
            reader.readAsDataURL(file);
        } else {
            preview.innerHTML = '';
        }
    });
</script>
</body>
</html>