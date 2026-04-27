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
    <title>${not empty categoryName ? categoryName : 'Danh mục sản phẩm'} - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Reset & Base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background-color: #f8f9fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #333;
        }
        
        /* Header Styles */
        .main-header {
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            padding: 10px 20px;
        }
        
        .logo {
            font-size: 28px;
            font-weight: 800;
            color: #e11b1b;
            text-decoration: none;
            display: inline-block;
        }
        
        .logo span {
            font-size: 11px;
            font-weight: 300;
            color: #888;
            display: block;
            letter-spacing: 0.5px;
        }
        
        .search-wrapper {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
        }
        
        .search-box {
            display: flex;
            border: 2px solid #e11b1b;
            border-radius: 40px;
            overflow: hidden;
            background: white;
            transition: box-shadow 0.2s;
        }
        
        .search-box:focus-within {
            box-shadow: 0 0 0 3px rgba(225, 27, 27, 0.2);
        }
        
        .search-box input {
            flex: 1;
            border: none;
            padding: 12px 10px;
            font-size: 14px;
            outline: none;
        }
        
        .search-box button {
            background: #e11b1b;
            border: none;
            padding: 0 24px;
            color: white;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .search-box button:hover {
            background: #c41717;
        }
        
        .header-actions {
            display: flex;
            justify-content: flex-end;
            gap: 50px;
        }
        
        .header-action {
            text-align: center;
            color: #555;
            text-decoration: none;
            font-size: 12px;
            transition: color 0.2s;
        }
        
        .header-action i {
            font-size: 22px;
            display: block;
            margin-bottom: 4px;
        }
        
        .header-action:hover {
            color: #e11b1b;
        }
        
        /* Navbar Styles */
        .navbar-menu {
            background: white;
            border-bottom: 1px solid #eee;
            position: sticky;
            top: 0;
            z-index: 999;
        }
        
        .navbar-list {
            display: flex;
            justify-content: center;
            gap: 32px;
            list-style: none;
            margin: 0;
            padding: 12px 0;
        }
        
        .navbar-list li a {
            display: block;
            padding: 8px 0;
            color: #333;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            position: relative;
        }
        
        .navbar-list li a::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 0;
            height: 2px;
            background: #e11b1b;
            transition: width 0.2s;
        }
        
        .navbar-list li a:hover::after,
        .navbar-list li a.active::after {
            width: 100%;
        }
        
        .navbar-list li a:hover {
            color: #e11b1b;
        }
        
        /* Breadcrumb Styles */
        .breadcrumb-area {
            background: transparent;
            padding: 12px 0;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin: 0;
        }
        
        .breadcrumb-item {
            font-size: 13px;
        }
        
        .breadcrumb-item a {
            color: #666;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .breadcrumb-item a:hover {
            color: #e11b1b;
        }
        
        .breadcrumb-item.active {
            color: #e11b1b;
            font-weight: 500;
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            color: #aaa;
            font-size: 16px;
        }
        
        /* Filter Sidebar */
        .filter-sidebar {
            background: white;
            border-radius: 16px;
            padding: 20px;
            position: sticky;
            top: 80px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid #eee;
        }
        
        .filter-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e11b1b;
            display: inline-block;
        }
        
        .filter-group {
            margin-bottom: 24px;
        }
        
        .filter-label {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            display: block;
            margin-bottom: 12px;
        }
        
        .price-inputs {
            display: flex;
            gap: 8px;
            align-items: center;
            width: 100%;
        }
        
        .price-inputs input {
            flex: 1;
            min-width: 0;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.2s;
            box-sizing: border-box;
        }
        
        .price-inputs input:focus {
            outline: none;
            border-color: #e11b1b;
            box-shadow: 0 0 0 2px rgba(225,27,27,0.1);
        }
        
        .radio-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .radio-item {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }
        
        .radio-item input {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #e11b1b;
        }
        
        .radio-item span {
            font-size: 14px;
            color: #555;
        }
        
        .filter-btn {
            width: 100%;
            padding: 12px;
            background: #e11b1b;
            color: white;
            border: none;
            border-radius: 40px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 8px;
        }
        
        .filter-btn:hover {
            background: #c41717;
        }
        
        /* Product Section */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 700;
            color: #333;
            margin: 0;
        }
        
        .sort-wrapper {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .sort-label {
            font-size: 14px;
            color: #666;
        }
        
        .sort-select {
            padding: 8px 16px;
            border: 1px solid #ddd;
            border-radius: 40px;
            font-size: 13px;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .sort-select:focus {
            outline: none;
            border-color: #e11b1b;
        }
        
        .product-count {
            font-size: 14px;
            color: #888;
            margin-bottom: 16px;
        }
        
        /* Product Grid */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 24px;
        }
        
        .product-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #333;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid #f0f0f0;
        }
        
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.1);
        }
        
        .product-img-wrapper {
            position: relative;
            overflow: hidden;
            background: #f8f8f8;
        }
        
        .product-img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            transition: transform 0.4s;
        }
        
        .product-card:hover .product-img {
            transform: scale(1.05);
        }
        
        .product-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: #e11b1b;
            color: white;
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }
        
        .product-info {
            padding: 16px;
        }
        
        .product-name {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
            line-height: 1.4;
            height: 40px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        
        .product-price {
            font-size: 18px;
            font-weight: 700;
            color: #e11b1b;
            margin-bottom: 4px;
        }
        
        .product-old-price {
            font-size: 13px;
            color: #aaa;
            text-decoration: line-through;
            margin-left: 8px;
            font-weight: 400;
        }
        
        .product-stock {
            font-size: 12px;
            color: #28a745;
            margin-top: 8px;
        }
        
        .product-stock.out {
            color: #dc3545;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 16px;
        }
        
        .empty-state i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        /* Pagination */
        .pagination-container {
            margin-top: 40px;
            display: flex;
            justify-content: center;
        }
        
        .pagination {
            gap: 8px;
        }
        
        .pagination .page-link {
            border-radius: 12px;
            padding: 8px 16px;
            color: #555;
            border: 1px solid #e0e0e0;
            transition: all 0.2s;
        }
        
        .pagination .page-link:hover {
            background: #e11b1b;
            color: white;
            border-color: #e11b1b;
        }
        
        .pagination .active .page-link {
            background: #e11b1b;
            border-color: #e11b1b;
            color: white;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            }
            
            .navbar-list {
                gap: 20px;
                overflow-x: auto;
                padding: 12px 16px;
            }
            
            .navbar-list li a {
                white-space: nowrap;
            }
        }
        
        @media (max-width: 768px) {
            .header-actions {
                justify-content: center;
                margin-top: 16px;
            }
            
            .search-wrapper {
                margin: 16px 0;
            }
            
            .section-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .price-inputs {
                flex-wrap: wrap;
            }
            
            .price-inputs input {
                width: 100%;
                min-width: 100%;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Navbar Menu -->
<div class="navbar-menu">
    <div class="container-fluid px-4">
        <ul class="navbar-list">
            <li><a href="${root}/home">Trang chủ</a></li>
            <li><a href="${root}/category?id=18" ${param.id == 18 ? 'class="active"' : ''}>Gọng kính</a></li>
            <li><a href="${root}/category?id=19" ${param.id == 19 ? 'class="active"' : ''}>Kính râm</a></li>
            <li><a href="${root}/category?id=20" ${param.id == 20 ? 'class="active"' : ''}>Kính chống ánh sáng xanh</a></li>
            <li><a href="${root}/category?id=21" ${param.id == 21 ? 'class="active"' : ''}>Tròng kính</a></li>
            <li><a href="${root}/category?id=22" ${param.id == 22 ? 'class="active"' : ''}>Kính áp tròng</a></li>
            <li><a href="${root}/category?id=23" ${param.id == 23 ? 'class="active"' : ''}>Phụ kiện</a></li>
        </ul>
    </div>
</div>

<!-- Main Content -->
<main class="container-fluid px-4 py-4">
    <!-- Breadcrumb Navigation -->
    <div class="breadcrumb-area">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${root}/home"><i class="fas fa-home me-1"></i>Trang chủ</a></li>
                <li class="breadcrumb-item active">${not empty categoryName ? categoryName : 'Danh mục sản phẩm'}</li>
                <c:if test="${not empty subCategoryName}">
                    <li class="breadcrumb-item active">${subCategoryName}</li>
                </c:if>
            </ol>
        </nav>
    </div>
    
    <!-- Content Row -->
    <div class="row g-4">
        <!-- Sidebar Filter -->
        <div class="col-lg-3">
            <div class="filter-sidebar">
                <h3 class="filter-title">Bộ lọc sản phẩm</h3>
                
                <form id="filterForm" method="GET" action="${root}/category">
                    <input type="hidden" name="id" value="${param.id}">
                    <c:if test="${not empty param.sub_id}">
                        <input type="hidden" name="sub_id" value="${param.sub_id}">
                    </c:if>
                    
                    <!-- Giá -->
                    <div class="filter-group">
                        <label class="filter-label">💰 Giá</label>
                        <div class="price-inputs">
                            <input type="number" name="minPrice" placeholder="Từ" value="${param.minPrice}">
                            <input type="number" name="maxPrice" placeholder="Đến" value="${param.maxPrice}">
                        </div>
                    </div>
                    
                    <!-- Giới tính -->
                    <div class="filter-group">
                        <label class="filter-label">👤 Giới tính</label>
                        <div class="radio-group">
                            <label class="radio-item">
                                <input type="radio" name="gender" value="" ${empty param.gender ? 'checked' : ''}>
                                <span>Tất cả</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="gender" value="Nam" ${param.gender == 'Nam' ? 'checked' : ''}>
                                <span><i class="fas fa-mars me-1"></i>Nam</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="gender" value="Nữ" ${param.gender == 'Nữ' ? 'checked' : ''}>
                                <span><i class="fas fa-venus me-1"></i>Nữ</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="gender" value="Unisex" ${param.gender == 'Unisex' ? 'checked' : ''}>
                                <span><i class="fas fa-genderless me-1"></i>Unisex</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Chất liệu -->
                    <div class="filter-group">
                        <label class="filter-label">🔧 Chất liệu</label>
                        <div class="radio-group">
                            <label class="radio-item">
                                <input type="radio" name="frameMaterial" value="" ${empty param.frameMaterial ? 'checked' : ''}>
                                <span>Tất cả</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="frameMaterial" value="Titanium" ${param.frameMaterial == 'Titanium' ? 'checked' : ''}>
                                <span>Titanium</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="frameMaterial" value="Acetate" ${param.frameMaterial == 'Acetate' ? 'checked' : ''}>
                                <span>Acetate</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="frameMaterial" value="Metal" ${param.frameMaterial == 'Metal' ? 'checked' : ''}>
                                <span>Metal</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="frameMaterial" value="Plastic" ${param.frameMaterial == 'Plastic' ? 'checked' : ''}>
                                <span>Plastic</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="frameMaterial" value="TR90" ${param.frameMaterial == 'TR90' ? 'checked' : ''}>
                                <span>TR90</span>
                            </label>
                        </div>
                    </div>
                    
                    <input type="hidden" name="sort" id="sortInput" value="${param.sort != null ? param.sort : 'newest'}">
                    <button type="submit" class="filter-btn"><i class="fas fa-filter me-2"></i>Áp dụng bộ lọc</button>
                    
                    <c:if test="${not empty param.minPrice or not empty param.maxPrice or not empty param.gender or not empty param.frameMaterial}">
                        <a href="${root}/category?id=${param.id}${not empty param.sub_id ? '&sub_id='.concat(param.sub_id) : ''}" class="btn btn-link text-danger mt-2 w-100 text-decoration-none">
                            <i class="fas fa-times-circle me-1"></i>Xóa tất cả bộ lọc
                        </a>
                    </c:if>
                </form>
            </div>
        </div>
        
        <!-- Product Section -->
        <div class="col-lg-9">
            <div class="section-header">
                <h2 class="section-title">${not empty categoryName ? categoryName : 'Sản phẩm'}</h2>
                <div class="sort-wrapper">
                    <span class="sort-label">Sắp xếp:</span>
                    <select class="sort-select" id="sortSelect">
                        <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                        <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá thấp → cao</option>
                        <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá cao → thấp</option>
                        <option value="name_asc" ${param.sort == 'name_asc' ? 'selected' : ''}>Tên A → Z</option>
                    </select>
                </div>
            </div>
            
            <div class="product-count">
                Hiển thị <strong>${fn:length(products)}</strong> / <strong>${totalProducts}</strong> sản phẩm
            </div>
            
            <!-- Product Grid -->
            <div class="product-grid">
                <c:forEach var="p" items="${products}">
                    <a href="${root}/product?id=${p.id}" class="product-card">
                        <div class="product-img-wrapper">
                            <img src="${root}${p.image}" class="product-img" alt="${p.name}" 
                                 onerror="this.src='https://placehold.co/300x300?text=No+Image'">
                            <c:if test="${p.price > p.salePrice && p.price != 0}">
                                <span class="product-badge">
                                    -${Math.round((1 - (p.salePrice * 1.0) / p.price) * 100)}%
                                </span>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <div class="product-name">${p.name}</div>
                            <div>
                                <span class="product-price">
                                    <fmt:formatNumber value="${p.salePrice}" pattern="#,###"/>₫
                                </span>
                                <c:if test="${p.price > p.salePrice}">
                                    <span class="product-old-price">
                                        <fmt:formatNumber value="${p.price}" pattern="#,###"/>₫
                                    </span>
                                </c:if>
                            </div>
                            <div class="product-stock ${p.stock <= 0 ? 'out' : ''}">
                                <c:choose>
                                    <c:when test="${p.stock <= 0}">
                                        <i class="fas fa-times-circle me-1"></i>Hết hàng
                                    </c:when>
                                    <c:when test="${p.stock < 10}">
                                        <i class="fas fa-exclamation-circle me-1"></i>Còn ${p.stock} sản phẩm
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-check-circle me-1"></i>Còn hàng
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
            
            <!-- Empty State -->
            <c:if test="${empty products}">
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h5>Không tìm thấy sản phẩm</h5>
                    <p class="text-muted">Danh mục này hiện chưa có sản phẩm nào hoặc không phù hợp với bộ lọc.</p>
                    <a href="${root}/category?id=${param.id}" class="btn btn-danger rounded-pill px-4 mt-3">Xem tất cả sản phẩm</a>
                </div>
            </c:if>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <nav>
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="#" data-page="${currentPage - 1}">«</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="#" data-page="${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="#" data-page="${currentPage + 1}">»</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Xử lý sort
    const sortSelect = document.getElementById('sortSelect');
    const sortInput = document.getElementById('sortInput');
    const filterForm = document.getElementById('filterForm');
    
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            sortInput.value = this.value;
            filterForm.submit();
        });
    }
    
    // Xử lý pagination
    document.querySelectorAll('.page-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const page = this.dataset.page;
            if (page && !this.parentElement.classList.contains('disabled')) {
                const pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                pageInput.value = page;
                filterForm.appendChild(pageInput);
                filterForm.submit();
            }
        });
    });
    
    // Tự động submit khi thay đổi radio
    document.querySelectorAll('input[type="radio"]').forEach(radio => {
        radio.addEventListener('change', function() {
            filterForm.submit();
        });
    });
</script>
</body>
</html>