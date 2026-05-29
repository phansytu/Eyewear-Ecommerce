<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${root}/css/style.css">
    <style>
        /* Header Admin Badge */
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
        
        /* Category Card - Giống Product Card của Home */
        .category-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 25px;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        .category-img-wrapper {
            position: relative;
            height: 200px;
            overflow: hidden;
            background: #f8f9fa;
        }
        .category-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .category-card:hover .category-img {
            transform: scale(1.05);
        }
        .category-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #dc3545;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
        }
        .category-info {
            padding: 15px;
            flex: 1;
        }
        .category-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .category-name a {
            color: #333;
            text-decoration: none;
            transition: color 0.2s;
        }
        .category-name a:hover {
            color: #dc3545;
        }
        .category-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .product-count {
            font-size: 13px;
            color: #6c757d;
        }
        .parent-badge {
            background: #e9ecef;
            color: #495057;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 20px;
        }
        .category-desc {
            font-size: 13px;
            color: #6c757d;
            line-height: 1.4;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .category-actions {
            display: flex;
            gap: 10px;
            padding: 12px 15px;
            background: #f8f9fa;
            border-top: 1px solid #eee;
        }
        .btn-action {
            flex: 1;
            padding: 8px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            text-align: center;
            transition: all 0.2s;
            text-decoration: none;
        }
        .btn-edit {
            background: #ffc107;
            color: #333;
        }
        .btn-edit:hover {
            background: #e0a800;
            color: #333;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .btn-delete:hover {
            background: #c82333;
            color: white;
        }
        
        /* Sidebar Filter */
        .filter-sidebar {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            position: sticky;
            top: 20px;
        }
        .filter-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }
        .btn-add {
            background: linear-gradient(135deg, #00b4d8, #0077b6);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 30px;
            font-weight: 500;
            width: 100%;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        .btn-add:hover {
            background: linear-gradient(135deg, #0096b8, #005f8c);
            color: white;
        }
        .stat-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px dashed #eee;
        }
        .stat-label {
            font-size: 14px;
            color: #6c757d;
        }
        .stat-value {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }
        
        /* Breadcrumb */
        .breadcrumb-custom {
            background: #f8f9fa;
            padding: 12px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }
        
        /* Search Box */
        .search-box input {
            border-radius: 30px;
            padding: 10px 15px;
            border: 1px solid #ddd;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 16px;
        }
        .empty-state i {
            font-size: 60px;
            color: #dee2e6;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<!-- Top Admin Bar -->
<div class="admin-top-bar">
    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <i class="fas fa-glasses me-2"></i> Eyeglass Store Admin
            </div>
            <div>
                <i class="fas fa-user-shield me-1"></i> Xin chào, Admin
                <span class="admin-badge ms-2">Quản trị viên</span>
            </div>
        </div>
    </div>
</div>

<!-- Header (giống Home) -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<!-- Main Content -->
<main class="container-fluid px-4 py-4">
    
    <!-- Breadcrumb -->
    <div class="breadcrumb-custom">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${root}/admin/dashboard"><i class="fas fa-tachometer-alt me-1"></i>Dashboard</a></li>
                <li class="breadcrumb-item active"><i class="fas fa-folder-open me-1"></i>Quản lý danh mục</li>
            </ol>
        </nav>
    </div>
    
    <div class="row g-4">
        <!-- Sidebar (giống Home) -->
        <div class="col-lg-3">
            <div class="filter-sidebar">
                <h3 class="filter-title"><i class="fas fa-sliders-h me-2"></i>Thao tác nhanh</h3>
                
                <a href="${root}/admin/categories/add" class="btn btn-add">
                    <i class="fas fa-plus-circle me-2"></i>Thêm danh mục mới
                </a>
                
                <hr>
                
                <h5 class="mb-3"><i class="fas fa-chart-line me-2"></i>Thống kê</h5>
                
                <div class="stat-item">
                    <span class="stat-label"><i class="fas fa-list me-1"></i>Tổng danh mục</span>
                    <span class="stat-value">${fn:length(categories)}</span>
                </div>
                
                <c:set var="parentCount" value="0"/>
                <c:set var="childCount" value="0"/>
                <c:forEach var="cat" items="${categories}">
                    <c:if test="${cat.parentId == 0 || cat.parentId == null}">
                        <c:set var="parentCount" value="${parentCount + 1}"/>
                    </c:if>
                    <c:if test="${cat.parentId != 0 && cat.parentId != null}">
                        <c:set var="childCount" value="${childCount + 1}"/>
                    </c:if>
                </c:forEach>
                
                <div class="stat-item">
                    <span class="stat-label"><i class="fas fa-tree me-1"></i>Danh mục cha</span>
                    <span class="stat-value">${parentCount}</span>
                </div>
                
                <div class="stat-item">
                    <span class="stat-label"><i class="fas fa-code-branch me-1"></i>Danh mục con</span>
                    <span class="stat-value">${childCount}</span>
                </div>
                
                <hr>
                
                <div class="search-box">
                    <label class="form-label"><i class="fas fa-search me-1"></i>Tìm kiếm danh mục</label>
                    <input type="text" id="searchCategory" class="form-control" placeholder="Nhập tên danh mục...">
                </div>
            </div>
        </div>
        
        <!-- Category Grid (giống Product Grid của Home) -->
        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title mb-0">
                    <i class="fas fa-folder-open me-2"></i>Quản lý danh mục
                </h2>
                <div class="product-count">
                    <i class="fas fa-list me-1"></i> Hiển th�n <strong id="visibleCount">${fn:length(categories)}</strong> / <strong>${fn:length(categories)}</strong> danh mục
                </div>
            </div>
            
            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
            
            <!-- Category Cards Grid -->
            <div class="row" id="categoryGrid">
                <c:forEach var="cat" items="${categories}">
                    <div class="col-lg-4 col-md-6 category-item" data-name="${cat.name}">
                        <div class="category-card">
                            <div class="category-img-wrapper">
                                <c:choose>
                                    <c:when test="${not empty cat.image}">
                                        <img src="${root}/uploads/categories/${cat.image}" class="category-img" alt="${cat.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${root}/image/anhdanhmuc/anh1 .jpg" class="category-img" alt="Default">
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${cat.productCount > 10}">
                                    <span class="category-badge"><i class="fas fa-fire me-1"></i>Hot</span>
                                </c:if>
                            </div>
                            <div class="category-info">
                                <div class="category-name">
                                    <a href="${root}/category?id=${cat.id}">${cat.name}</a>
                                </div>
                                <div class="category-meta">
                                    <span class="product-count">
                                        <i class="fas fa-box me-1"></i> ${cat.productCount} sản phẩm
                                    </span>
                                    <c:if test="${cat.parentId == 0}">
                                        <span class="parent-badge"><i class="fas fa-tree me-1"></i>Danh mục cha</span>
                                    </c:if>
                                </div>
                                <div class="category-desc">
                                    <c:choose>
                                        <c:when test="${not empty cat.description}">
                                            ${fn:substring(cat.description, 0, 80)}...
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-edit me-1"></i>Chưa có mô tả
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="category-actions">
                                <a href="${root}/admin/categories/edit?id=${cat.id}" class="btn-action btn-edit">
                                    <i class="fas fa-edit me-1"></i> Sửa
                                </a>
                                <a href="${root}/admin/categories/delete?id=${cat.id}" 
                                   class="btn-action btn-delete"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục \"${cat.name}\"?\nSản phẩm trong danh mục này sẽ bị ảnh hưởng!')">
                                    <i class="fas fa-trash-alt me-1"></i> Xóa
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <!-- Empty State -->
            <c:if test="${empty categories}">
                <div class="empty-state">
                    <i class="fas fa-folder-open"></i>
                    <h5>Chưa có danh mục nào</h5>
                    <p class="text-muted">Hãy thêm danh mục sản phẩm đầu tiên để bắt đầu!</p>
                    <a href="${root}/admin/categories/add" class="btn btn-danger rounded-pill px-4 mt-3">
                        <i class="fas fa-plus-circle me-2"></i>Thêm danh mục mới
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- Chatbot -->
<jsp:include page="/WEB-INF/includes/chatbot.jsp" />

<!-- Footer (giống Home) -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Tìm kiếm danh mục real-time
    const searchInput = document.getElementById('searchCategory');
    const categoryItems = document.querySelectorAll('.category-item');
    const visibleCountSpan = document.getElementById('visibleCount');
    const totalCount = categoryItems.length;
    
    if (searchInput) {
        searchInput.addEventListener('keyup', function() {
            const keyword = this.value.toLowerCase().trim();
            let visibleCount = 0;
            
            categoryItems.forEach(item => {
                const categoryName = item.getAttribute('data-name')?.toLowerCase() || '';
                if (keyword === '' || categoryName.includes(keyword)) {
                    item.style.display = '';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });
            
            if (visibleCountSpan) {
                visibleCountSpan.textContent = visibleCount;
            }
        });
    }
</script>


</body>
</html>