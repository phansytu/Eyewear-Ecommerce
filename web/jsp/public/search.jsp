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
    <title>Tìm kiếm - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f5f5fa; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; }
        .product-card { border: 1px solid #e1e1e1; border-radius: 8px; transition: all 0.3s; background: white; }
        .product-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); transform: translateY(-2px); }
        .filter-sidebar { background: white; border-radius: 8px; padding: 16px; position: sticky; top: 80px; }
        .filter-title { font-weight: 600; font-size: 16px; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 2px solid #1A94FF; }
        .filter-group { margin-bottom: 20px; }
        .filter-group label { font-size: 13px; color: #666; margin-bottom: 8px; font-weight: 500; display: block; }
        .price-input { display: flex; gap: 8px; }
        .price-input input { width: 100%; padding: 6px 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; }
        .sort-bar { background: white; border-radius: 8px; padding: 12px 16px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }
        .sort-options { display: flex; gap: 10px; flex-wrap: wrap; }
        .sort-option { padding: 6px 12px; border-radius: 20px; font-size: 13px; cursor: pointer; transition: all 0.2s; background: #f0f0f0; color: #666; text-decoration: none; }
        .sort-option.active { background: #1A94FF; color: white; }
        .sort-option:hover:not(.active) { background: #e0e0e0; }
        .filter-checkbox { display: flex; align-items: center; gap: 8px; margin-bottom: 10px; cursor: pointer; }
        .filter-checkbox input { cursor: pointer; }
        .filter-checkbox span { font-size: 13px; color: #333; }
        .clear-filter { color: #1A94FF; text-decoration: none; font-size: 13px; }
        .clear-filter:hover { text-decoration: underline; }
        .pagination { margin-top: 30px; }
        .breadcrumb { background: transparent; padding: 0; margin-bottom: 20px; }
    </style>
</head>
<body>

<!-- Header giống home.jsp -->
<jsp:include page="/WEB-INF/includes/header.jsp"/>

<div class="container-fluid px-4 py-4">
    <div class="row g-4">
        <!-- Sidebar Filter -->
        <div class="col-lg-3">
            <div class="filter-sidebar">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="filter-title mb-0">Bộ lọc tìm kiếm</h6>
                    <a href="${root}/search" class="clear-filter"><i class="fas fa-times-circle me-1"></i>Xóa bộ lọc</a>
                </div>
                
                <form id="filterForm" method="GET" action="${root}/search">
                    <!-- Từ khóa -->
                    <input type="hidden" name="keyword" value="${searchKeyword}">
                    
                    <!-- Danh mục -->
                    <div class="filter-group">
                        <label><i class="fas fa-list me-1"></i>Danh mục</label>
                        <select name="categoryId" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
                                    ${cat.name}
                                </option>
                                <c:forEach var="sub" items="${cat.subCategories}">
                                    <option value="${sub.id}" ${selectedCategoryId == sub.id ? 'selected' : ''}>
                                        &nbsp;&nbsp;↳ ${sub.name}
                                    </option>
                                </c:forEach>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Khoảng giá -->
                    <div class="filter-group">
                        <label><i class="fas fa-tag me-1"></i>Khoảng giá</label>
                        <div class="price-input">
                            <input type="number" name="minPrice" class="form-control form-control-sm" placeholder="Từ" value="${selectedMinPrice}" onblur="this.form.submit()">
                            <span class="align-self-center">-</span>
                            <input type="number" name="maxPrice" class="form-control form-control-sm" placeholder="Đến" value="${selectedMaxPrice}" onblur="this.form.submit()">
                        </div>
                    </div>
                    
                    <!-- Giới tính -->
                    <div class="filter-group">
                        <label><i class="fas fa-venus-mars me-1"></i>Giới tính</label>
                        <div>
                            <label class="filter-checkbox">
                                <input type="radio" name="gender" value="all" ${empty selectedGender or selectedGender == 'all' ? 'checked' : ''} onchange="this.form.submit()">
                                <span>Tất cả</span>
                            </label>
                            <label class="filter-checkbox">
                                <input type="radio" name="gender" value="Nam" ${selectedGender == 'Nam' ? 'checked' : ''} onchange="this.form.submit()">
                                <span><i class="fas fa-mars"></i> Nam</span>
                            </label>
                            <label class="filter-checkbox">
                                <input type="radio" name="gender" value="Nữ" ${selectedGender == 'Nữ' ? 'checked' : ''} onchange="this.form.submit()">
                                <span><i class="fas fa-venus"></i> Nữ</span>
                            </label>
                            <label class="filter-checkbox">
                                <input type="radio" name="gender" value="Unisex" ${selectedGender == 'Unisex' ? 'checked' : ''} onchange="this.form.submit()">
                                <span><i class="fas fa-genderless"></i> Unisex</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Chất liệu gọng -->
                    <div class="filter-group">
                        <label><i class="fas fa-microscope me-1"></i>Chất liệu gọng</label>
                        <select name="frameMaterial" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="all">Tất cả</option>
                            <option value="Titanium" ${selectedFrameMaterial == 'Titanium' ? 'selected' : ''}>Titanium</option>
                            <option value="Acetate" ${selectedFrameMaterial == 'Acetate' ? 'selected' : ''}>Acetate</option>
                            <option value="Metal" ${selectedFrameMaterial == 'Metal' ? 'selected' : ''}>Metal</option>
                            <option value="Plastic" ${selectedFrameMaterial == 'Plastic' ? 'selected' : ''}>Plastic</option>
                            <option value="TR90" ${selectedFrameMaterial == 'TR90' ? 'selected' : ''}>TR90</option>
                        </select>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="col-lg-9">
            <!-- Sort Bar -->
            <div class="sort-bar">
                <div>
                    <span class="text-muted">Tìm thấy <strong class="text-primary">${totalProducts}</strong> sản phẩm</span>
                    <c:if test="${not empty searchKeyword}">
                        <span class="text-muted ms-2">cho từ khóa "<strong>${searchKeyword}</strong>"</span>
                    </c:if>
                </div>
                <div class="sort-options">
                    <span class="text-muted me-2">Sắp xếp:</span>
                    <a href="#" class="sort-option ${selectedSort == 'newest' ? 'active' : ''}" data-sort="newest">Mới nhất</a>
                    <a href="#" class="sort-option ${selectedSort == 'price_asc' ? 'active' : ''}" data-sort="price_asc">Giá thấp → cao</a>
                    <a href="#" class="sort-option ${selectedSort == 'price_desc' ? 'active' : ''}" data-sort="price_desc">Giá cao → thấp</a>
                    <a href="#" class="sort-option ${selectedSort == 'name_asc' ? 'active' : ''}" data-sort="name_asc">Tên A → Z</a>
                    <a href="#" class="sort-option ${selectedSort == 'best_seller' ? 'active' : ''}" data-sort="best_seller">Bán chạy</a>
                </div>
            </div>
            
            <!-- Product Grid -->
            <div class="row g-3">
                <c:forEach var="p" items="${products}">
                    <div class="col-xl-3 col-lg-4 col-md-4 col-sm-6">
                        <div class="product-card h-100 p-2">
                            <a href="${root}/product?id=${p.id}" class="text-decoration-none text-dark">
                                <img src="${root}/${p.image}" class="img-fluid rounded" alt="${p.name}" 
                                     style="width: 100%; height: 180px; object-fit: cover;"
                                     onerror="this.src='${root}/images/no-image.png'">
                                <div class="p-2">
                                    <h6 class="product-title mb-1" style="font-size: 14px; min-height: 40px;">${p.name}</h6>
                                    <div class="d-flex justify-content-between align-items-center mt-2">
                                        <div>
                                            <span class="text-danger fw-bold fs-6">
                                                <fmt:formatNumber value="${p.salePrice}" pattern="#,###"/>₫
                                            </span>
                                            <c:if test="${p.price > p.salePrice}">
                                                <small class="text-muted text-decoration-line-through ms-1">
                                                    <fmt:formatNumber value="${p.price}" pattern="#,###"/>₫
                                                </small>
                                            </c:if>
                                        </div>
                                    </div>
                                    <c:if test="${p.stock <= 0}">
                                        <span class="badge bg-secondary mt-2">Hết hàng</span>
                                    </c:if>
                                </div>
                            </a>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty products}">
                    <div class="col-12 text-center py-5">
                        <i class="fas fa-search fa-4x text-muted mb-3"></i>
                        <h5 class="text-muted">Không tìm thấy sản phẩm nào</h5>
                        <p class="text-muted">Vui lòng thử lại với từ khóa khác hoặc xem các sản phẩm gợi ý bên dưới.</p>
                        <a href="${root}/home" class="btn btn-primary mt-3">Quay lại trang chủ</a>
                    </div>
                </c:if>
            </div>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination justify-content-center">
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
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Xử lý sort
    document.querySelectorAll('.sort-option').forEach(option => {
        option.addEventListener('click', function(e) {
            e.preventDefault();
            const sortValue = this.dataset.sort;
            const form = document.getElementById('filterForm');
            const sortInput = document.createElement('input');
            sortInput.type = 'hidden';
            sortInput.name = 'sort';
            sortInput.value = sortValue;
            form.appendChild(sortInput);
            form.submit();
        });
    });
    
    // Xử lý pagination
    document.querySelectorAll('.page-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const page = this.dataset.page;
            if (page && !this.parentElement.classList.contains('disabled')) {
                const form = document.getElementById('filterForm');
                const pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                pageInput.value = page;
                form.appendChild(pageInput);
                form.submit();
            }
        });
    });
</script>
</body>
</html> 