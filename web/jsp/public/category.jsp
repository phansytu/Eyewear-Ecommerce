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
    <link rel="stylesheet" href="${root}/css/style.css">
    <link rel="stylesheet" href="${root}/css/chatbot.css">
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

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
                    
                    <div class="filter-group">
                        <label class="filter-label">💰 Giá</label>
                        <div class="price-inputs">
                            <input type="number" name="minPrice" placeholder="Từ" value="${param.minPrice}">
                            <input type="number" name="maxPrice" placeholder="Đến" value="${param.maxPrice}">
                        </div>
                    </div>
                    
                    <div class="filter-group">
                        <label class="filter-label">👤 Giới tính</label>
                        <div class="radio-group">
                            <label class="radio-item"><input type="radio" name="gender" value="" ${empty param.gender ? 'checked' : ''}><span>Tất cả</span></label>
                            <label class="radio-item"><input type="radio" name="gender" value="Nam" ${param.gender == 'Nam' ? 'checked' : ''}><span><i class="fas fa-mars me-1"></i>Nam</span></label>
                            <label class="radio-item"><input type="radio" name="gender" value="Nữ" ${param.gender == 'Nữ' ? 'checked' : ''}><span><i class="fas fa-venus me-1"></i>Nữ</span></label>
                            <label class="radio-item"><input type="radio" name="gender" value="Unisex" ${param.gender == 'Unisex' ? 'checked' : ''}><span><i class="fas fa-genderless me-1"></i>Unisex</span></label>
                        </div>
                    </div>
                    
                    <div class="filter-group">
                        <label class="filter-label">🔧 Chất liệu</label>
                        <div class="radio-group">
                            <label class="radio-item"><input type="radio" name="frameMaterial" value="" ${empty param.frameMaterial ? 'checked' : ''}><span>Tất cả</span></label>
                            <label class="radio-item"><input type="radio" name="frameMaterial" value="Titanium" ${param.frameMaterial == 'Titanium' ? 'checked' : ''}><span>Titanium</span></label>
                            <label class="radio-item"><input type="radio" name="frameMaterial" value="Acetate" ${param.frameMaterial == 'Acetate' ? 'checked' : ''}><span>Acetate</span></label>
                            <label class="radio-item"><input type="radio" name="frameMaterial" value="Metal" ${param.frameMaterial == 'Metal' ? 'checked' : ''}><span>Metal</span></label>
                            <label class="radio-item"><input type="radio" name="frameMaterial" value="Plastic" ${param.frameMaterial == 'Plastic' ? 'checked' : ''}><span>Plastic</span></label>
                            <label class="radio-item"><input type="radio" name="frameMaterial" value="TR90" ${param.frameMaterial == 'TR90' ? 'checked' : ''}><span>TR90</span></label>
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
            
            <div class="product-grid">
                <c:forEach var="p" items="${products}">
                    <a href="${root}/product?id=${p.id}" class="product-card">
                        <div class="product-img-wrapper">
                            <img src="${root}${p.image}" class="product-img" alt="${p.name}" 
                                 onerror="this.src='${root}/image/anhdanhmuc/no-image.png'">
                            <c:if test="${p.price > p.salePrice && p.price != 0}">
                                <span class="product-badge">-${Math.round((1 - (p.salePrice * 1.0) / p.price) * 100)}%</span>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <div class="product-name">${p.name}</div>
                            <div>
                                <span class="product-price"><fmt:formatNumber value="${p.salePrice}" pattern="#,###"/>₫</span>
                                <c:if test="${p.price > p.salePrice}">
                                    <span class="product-old-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>₫</span>
                                </c:if>
                            </div>
                            <div class="product-stock ${p.stock <= 0 ? 'out' : ''}">
                                <c:choose>
                                    <c:when test="${p.stock <= 0}"><i class="fas fa-times-circle me-1"></i>Hết hàng</c:when>
                                    <c:when test="${p.stock < 10}"><i class="fas fa-exclamation-circle me-1"></i>Còn ${p.stock} sản phẩm</c:when>
                                    <c:otherwise><i class="fas fa-check-circle me-1"></i>Còn hàng</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
            
            <c:if test="${empty products}">
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h5>Không tìm thấy sản phẩm</h5>
                    <p class="text-muted">Danh mục này hiện chưa có sản phẩm nào hoặc không phù hợp với bộ lọc.</p>
                    <a href="${root}/category?id=${param.id}" class="btn btn-danger rounded-pill px-4 mt-3">Xem tất cả sản phẩm</a>
                </div>
            </c:if>
            
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <nav>
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&id=${param.id}">«</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&id=${param.id}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&id=${param.id}">»</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- Chatbot -->
<jsp:include page="/WEB-INF/includes/chatbot.jsp" />

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const sortSelect = document.getElementById('sortSelect');
    const sortInput = document.getElementById('sortInput');
    const filterForm = document.getElementById('filterForm');
    
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            sortInput.value = this.value;
            filterForm.submit();
        });
    }
    
    document.querySelectorAll('input[type="radio"]').forEach(radio => {
        radio.addEventListener('change', function() {
            filterForm.submit();
        });
    });
</script>
</body>
</html>