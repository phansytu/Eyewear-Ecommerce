<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<%
    // ⭐ LẤY ROLE TỪ SESSION CHO CHATBOT
    HttpSession userSession = request.getSession(false);
    String userRole = "GUEST";  // Mặc định là khách chưa đăng nhập
    
    if (userSession != null) {
        String role = (String) userSession.getAttribute("user_role");
        if (role != null) {
            userRole = role;
        } else {
            // Fallback: kiểm tra role cũ nếu có
            Object userObj = userSession.getAttribute("user");
            if (userObj != null) {
                // Giả sử user object có method isAdmin()
                // Nếu không thì dùng attribute "role" đã set trong LoginServlet
                String oldRole = (String) userSession.getAttribute("role");
                if ("admin".equals(oldRole)) {
                    userRole = "ADMIN";
                    userSession.setAttribute("user_role", "ADMIN");
                } else if ("user".equals(oldRole)) {
                    userRole = "USER";
                    userSession.setAttribute("user_role", "USER");
                }
            }
        }
    }
    request.setAttribute("userRole", userRole);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TuKhanhHuy - Kính mắt chính hãng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <!-- ⭐ CHỈ IMPORT CSS TƯƠNG ỨNG VỚI ROLE -->
    <c:choose>
        <c:when test="${userRole == 'ADMIN'}">
            <link rel="stylesheet" href="${root}/css/chatbot-admin.css">
        </c:when>
        <c:otherwise>
            <link rel="stylesheet" href="${root}/css/chatbot-user.css">
        </c:otherwise>
    </c:choose>
</head>
<body>
    <header>
        <jsp:include page="/WEB-INF/includes/header.jsp" />
    </header>

    <!-- Main Content -->
    <main class="container-fluid px-4 py-4">
        <!-- Breadcrumb Navigation -->
        <div class="breadcrumb-area">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${root}/home"><i class="fas fa-home me-1"></i>Trang chủ</a></li>
                    <c:if test="${not empty param.categoryId}">
                        <c:choose>
                            <c:when test="${param.categoryId == 18}"><li class="breadcrumb-item active">Gọng kính</li></c:when>
                            <c:when test="${param.categoryId == 19}"><li class="breadcrumb-item active">Kính râm</li></c:when>
                            <c:when test="${param.categoryId == 20}"><li class="breadcrumb-item active">Kính chống ánh sáng xanh</li></c:when>
                            <c:when test="${param.categoryId == 21}"><li class="breadcrumb-item active">Tròng kính</li></c:when>
                            <c:when test="${param.categoryId == 22}"><li class="breadcrumb-item active">Kính áp tròng</li></c:when>
                            <c:when test="${param.categoryId == 23}"><li class="breadcrumb-item active">Phụ kiện</li></c:when>
                            <c:otherwise><li class="breadcrumb-item active">Danh mục sản phẩm</li></c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${not empty param.gender}">
                        <li class="breadcrumb-item active">
                            <c:choose>
                                <c:when test="${param.gender == 'Nam'}">Kính nam</c:when>
                                <c:when test="${param.gender == 'Nữ'}">Kính nữ</c:when>
                                <c:when test="${param.gender == 'Unisex'}">Kính Unisex</c:when>
                            </c:choose>
                        </li>
                    </c:if>
                    <c:if test="${not empty param.minPrice or not empty param.maxPrice}">
                        <li class="breadcrumb-item active">
                            Giá 
                            <c:if test="${not empty param.minPrice}">từ ${param.minPrice}đ</c:if>
                            <c:if test="${not empty param.maxPrice}">đến ${param.maxPrice}đ</c:if>
                        </li>
                    </c:if>
                    <c:if test="${empty param.categoryId and empty param.gender and empty param.minPrice and empty param.maxPrice}">
                        <li class="breadcrumb-item active">Tất cả sản phẩm</li>
                    </c:if>
                </ol>
            </nav>
        </div>
        
        <!-- Banner Slider -->
<div class="hero-banner">
    <div id="mainBanner" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4000">
        <!-- Indicators -->
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#mainBanner" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#mainBanner" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#mainBanner" data-bs-slide-to="2"></button>
        </div>
        
        <!-- Slides -->
        <div class="carousel-inner rounded-4 shadow">
            <div class="carousel-item active">
                <img src="https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=1200&h=400&q=80" 
                     class="d-block w-100" alt="Banner 1" style="height: 400px; object-fit: cover;">
                <div class="carousel-caption d-none d-md-block">
                    <h3 class="fw-bold">Kính mắt thời trang 2026</h3>
                    <p>Giảm đến 30% cho bộ sưu tập mới</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1577803645773-f96470509666?auto=format&fit=crop&w=1200&h=400&q=80" 
                     class="d-block w-100" alt="Banner 2" style="height: 400px; object-fit: cover;">
                <div class="carousel-caption d-none d-md-block">
                    <h3 class="fw-bold">Kính râm cao cấp</h3>
                    <p>Chống UV 100% - Bảo vệ đôi mắt của bạn</p>
                </div>
            </div>
            <div class="carousel-item">
               <img src="https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&w=1200&h=400&q=80" 
                     class="d-block w-100" alt="Banner 3" style="height: 400px; object-fit: cover;">
                <div class="carousel-caption d-none d-md-block">
                    <h3 class="fw-bold">Gọng kính nhẹ Titanium</h3>
                    <p>Siêu nhẹ - Siêu bền - Sang trọng</p>
                </div>
            </div>
        </div>
        
        <!-- Controls -->
        <button class="carousel-control-prev" type="button" data-bs-target="#mainBanner" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#mainBanner" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>
</div>
        
<!-- Content Row -->
<div class="row g-4">
    <!-- Sidebar Filter -->
    <div class="col-lg-3">
        <div class="filter-sidebar">
            <h3 class="filter-title">Bộ lọc sản phẩm</h3>
            
            <!-- Selected filters sẽ hiển thị ở đây -->
            <div class="selected-filters"></div>
            
            <form id="filterForm" method="GET" action="${root}/home">
                
                <!-- FILTER: GIÁ (có dropdown) -->
                <div class="filter-group has-header">
                    <div class="filter-header">
                        <label class="filter-label">💰 Giá</label>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="filter-content">
                        <div class="price-inputs">
                            <input type="number" name="minPrice" placeholder="Từ" value="${param.minPrice}">
                            <input type="number" name="maxPrice" placeholder="Đến" value="${param.maxPrice}">
                        </div>
                        <div class="price-presets">
                            <button type="button" class="price-preset" data-min="0" data-max="500000">Dưới 500k</button>
                            <button type="button" class="price-preset" data-min="500000" data-max="1000000">500k - 1tr</button>
                            <button type="button" class="price-preset" data-min="1000000" data-max="2000000">1tr - 2tr</button>
                            <button type="button" class="price-preset" data-min="2000000" data-max="5000000">2tr - 5tr</button>
                            <button type="button" class="price-preset" data-min="5000000" data-max="0">Trên 5tr</button>
                        </div>
                    </div>
                </div>
                
                <!-- FILTER: GIỚI TÍNH (có dropdown) -->
                <div class="filter-group has-header">
                    <div class="filter-header">
                        <label class="filter-label">👤 Giới tính</label>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="filter-content">
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
                </div>
                
                <!-- FILTER: CHẤT LIỆU (có dropdown) -->
                <div class="filter-group has-header">
                    <div class="filter-header">
                        <label class="filter-label">🔧 Chất liệu</label>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="filter-content">
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
                </div>
                
                <!-- FILTER: THƯƠNG HIỆU (có dropdown) - SỬA ĐÚNG CẤU TRÚC -->
                <div class="filter-group has-header">
                    <div class="filter-header">
                        <label class="filter-label">🏷️ Thương hiệu</label>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="filter-content">
                        <div class="radio-group">
                            <label class="radio-item">
                                <input type="radio" name="brand" value="" ${empty param.brand ? 'checked' : ''}>
                                <span>Tất cả</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Ray-Ban" ${param.brand == 'Ray-Ban' ? 'checked' : ''}>
                                <span>Ray-Ban</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Gucci" ${param.brand == 'Gucci' ? 'checked' : ''}>
                                <span>Gucci</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Dior" ${param.brand == 'Dior' ? 'checked' : ''}>
                                <span>Dior</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Oakley" ${param.brand == 'Oakley' ? 'checked' : ''}>
                                <span>Oakley</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Prada" ${param.brand == 'Prada' ? 'checked' : ''}>
                                <span>Prada</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Tom Ford" ${param.brand == 'Tom Ford' ? 'checked' : ''}>
                                <span>Tom Ford</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Essilor" ${param.brand == 'Essilor' ? 'checked' : ''}>
                                <span>Essilor</span>
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="brand" value="Zeiss" ${param.brand == 'Zeiss' ? 'checked' : ''}>
                                <span>Zeiss</span>
                            </label>
                        </div>
                    </div>
                </div>
                
                <input type="hidden" name="sort" id="sortInput" value="${param.sort != null ? param.sort : 'newest'}">
                <!-- Thêm id cho nút áp dụng -->
<button type="button" id="applyFilterBtn" class="filter-btn">
    <i class="fas fa-filter me-2"></i>Áp dụng bộ lọc
</button>
                
                <!-- THÊM NÚT XÓA DUY NHẤT NÀY -->
<div class="d-flex gap-2 mt-3">
    <button type="button" id="clearAllFiltersBtn" class="filter-btn">
        <i class="fas fa-trash-alt me-1"></i>Xóa hết
    </button>
</div>
            </form>
        </div>
    </div>
    
    
   

            
            <!-- Product Section -->
            <div class="col-lg-9">
                <div class="section-header">
                    <h2 class="section-title">Tất cả sản phẩm</h2>
                    <div class="sort-wrapper">
                        <span class="sort-label">Sắp xếp:</span>
                        <select class="sort-select" id="sortSelect">
                            <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="best_seller" ${param.sort == 'best_seller' ? 'selected' : ''}>Bán chạy nhất</option>
                            <option value="rating_desc" ${param.sort == 'rating_desc' ? 'selected' : ''}>Đánh giá cao nhất</option>
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
                                        -${(1 - (p.salePrice * 1.0) / p.price) * 100}%
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
                                        <c:when test="${p.stock <= 0}"><i class="fas fa-times-circle me-1"></i>Hết hàng</c:when>
                                        <c:when test="${p.stock < 10}"><i class="fas fa-exclamation-circle me-1"></i>Còn ${p.stock} sản phẩm</c:when>
                                        <c:otherwise><i class="fas fa-check-circle me-1"></i>Còn hàng</c:otherwise>
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
                        <p class="text-muted">Vui lòng thử lại với bộ lọc khác</p>
                        <a href="${root}/home" class="btn btn-danger rounded-pill px-4 mt-3">Xem tất cả sản phẩm</a>
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
        </div>
    </main>
    
    <!-- ⭐ CHATBOT - HIỂN THỊ THEO ROLE ⭐ -->
    <c:choose>
        <c:when test="${userRole == 'ADMIN'}">
            <jsp:include page="/WEB-INF/views/chatbot-admin.jsp" />
        </c:when>
        <c:otherwise>
            <jsp:include page="/WEB-INF/views/chatbot-user.jsp" />
        </c:otherwise>
    </c:choose>

    <footer>
        <jsp:include page="/WEB-INF/includes/footer.jsp" />
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${root}/js/home.js"></script>
    <script src="${root}/js/giohangcount.js"></script>
    
    <!-- ⭐ TRUYỀN ROLE VÀ CONTEXT PATH CHO JAVASCRIPT ⭐ -->
    <script>
        window.contextPath = '${root}';
        window.userRole = '${userRole}';
        console.log('User role:', window.userRole);
    </script>
</body>
</html>