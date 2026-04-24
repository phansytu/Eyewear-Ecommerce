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
    <title>TuKhanhHuy - Kính mắt chính hãng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <!-- THÊM CSS MỚI - KHÔNG XUNG ĐỘT -->
    <link rel="stylesheet" href="css/chatbot-news.css">
</head>
<body>

<!-- Header -->
<div class="main-header">
    <div class="container-fluid px-4">
        <div class="row align-items-center">
            <div class="col-md-3">
                <a href="${root}/home" class="logo">
                    TuKhanhHuy
                    <span>Kính mắt chính hãng</span>
                </a>
            </div>
            <div class="col-md-6">
                <div class="search-wrapper">
                    <form action="${root}/search" method="GET">
                        <div class="search-box">
                            <input type="text" name="keyword" placeholder="Bạn tìm gì hôm nay?" value="<c:out value='${param.keyword}'/>">
                            <button type="submit">Tìm kiếm</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-md-3">
                <div class="header-actions">
                    <a href="${root}/home" class="header-action">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <a href="#" class="header-action" data-bs-toggle="dropdown">
                                    <i class="far fa-user-circle"></i>
                                    <span>${fn:substring(sessionScope.user.full_name, 0, 10)}</span>
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="${root}/profile">Hồ sơ của tôi</a></li>
                                    <c:if test="${sessionScope.user.role eq 'admin'}">
                                        <li><a class="dropdown-item" href="${root}/admin/dashboard">Quản trị</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${root}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${root}/login" class="header-action">
                                <i class="far fa-smile"></i>
                                <span>Đăng nhập</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${root}/cart" class="header-action position-relative">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Giỏ hàng</span>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">0</span>
                    </a>
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
            <li><a href="${root}/search?categoryId=18">Gọng kính</a></li>
            <li><a href="${root}/search?categoryId=19">Kính râm</a></li>
            <li><a href="${root}/search?categoryId=20">Kính chống ánh sáng xanh</a></li>
            <li><a href="${root}/search?categoryId=21">Tròng kính</a></li>
            <li><a href="${root}/search?categoryId=22">Kính áp tròng</a></li>
            <li><a href="${root}/search?categoryId=23">Phụ kiện</a></li>
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
                <c:if test="${not empty param.categoryId}">
                    <c:choose>
                        <c:when test="${param.categoryId == 18}">
                            <li class="breadcrumb-item active">Gọng kính</li>
                        </c:when>
                        <c:when test="${param.categoryId == 19}">
                            <li class="breadcrumb-item active">Kính râm</li>
                        </c:when>
                        <c:when test="${param.categoryId == 20}">
                            <li class="breadcrumb-item active">Kính chống ánh sáng xanh</li>
                        </c:when>
                        <c:when test="${param.categoryId == 21}">
                            <li class="breadcrumb-item active">Tròng kính</li>
                        </c:when>
                        <c:when test="${param.categoryId == 22}">
                            <li class="breadcrumb-item active">Kính áp tròng</li>
                        </c:when>
                        <c:when test="${param.categoryId == 23}">
                            <li class="breadcrumb-item active">Phụ kiện</li>
                        </c:when>
                        <c:otherwise>
                            <li class="breadcrumb-item active">Danh mục sản phẩm</li>
                        </c:otherwise>
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
    
    <!-- Banner -->
    <div class="hero-banner">
        <div class="banner-grid">
            <div class="banner-card">
                <img src="https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=800&h=400&q=80" alt="Banner chính">
            </div>
            <div class="banner-card">
                <img src="https://images.unsplash.com/photo-1577803645773-f96470509666?auto=format&fit=crop&w=600&h=400&q=80" alt="Banner phụ">
            </div>
        </div>
    </div>
    
    <!-- Content Row -->
    <div class="row g-4">
        <!-- Sidebar Filter -->
        <div class="col-lg-3">
            <div class="filter-sidebar">
                <h3 class="filter-title">Bộ lọc sản phẩm</h3>
                
                <form id="filterForm" method="GET" action="${root}/home">
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
                        <a href="${root}/home" class="btn btn-link text-danger mt-2 w-100 text-decoration-none">
                            <i class="fas fa-times-circle me-1"></i>Xóa tất cả bộ lọc
                        </a>
                    </c:if>
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
            
            
</main>
            <!-- Floating Widgets: Chatbot & News -->
<div class="floating-widgets">
    
    <!-- Chatbot Widget -->
    <div class="widget-item chatbot-widget" id="chatbotWidget">
        <div class="deal-badge">✨ AI</div>
        <div class="widget-header">
            <i class="fas fa-robot"></i>
            <div>
                <div class="widget-title">Trợ lý AI</div>
                <div class="widget-subtitle">Hỗ trợ 24/7</div>
            </div>
        </div>
        <div class="widget-content">
            <div class="quick-replies">
                <button class="quick-reply-btn" data-msg="Xem sản phẩm">🛍️ Xem sản phẩm</button>
                <button class="quick-reply-btn" data-msg="Bảng giá">💰 Bảng giá</button>
                <button class="quick-reply-btn" data-msg="Chính sách">📜 Chính sách</button>
                <button class="quick-reply-btn" data-msg="Liên hệ">📞 Liên hệ</button>
            </div>
            <div class="chat-input-area">
                <input type="text" class="chat-input" id="chatInput" placeholder="Nhập tin nhắn...">
                <button class="chat-send" id="chatSend">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>
    
    <!-- News Widget -->
    <div class="widget-item news-widget" id="newsWidget">
        <div class="deal-badge">🔥 HOT</div>
        <div class="widget-header">
            <i class="fas fa-bullhorn"></i>
            <div>
                <div class="widget-title">Tin mới & Khuyến mãi</div>
                <div class="widget-subtitle">Cập nhật liên tục</div>
            </div>
        </div>
        <div class="widget-content">
            <div class="news-item">
                <div class="news-icon">
                    <i class="fas fa-gift"></i>
                </div>
                <div class="news-content">
                    <div class="news-title">
                        Deal siêu wow! 
                        <span class="news-badge">Mới</span>
                    </div>
                    <div class="news-desc">Coupon đến 30% - Sức khỏe dồi dào</div>
                </div>
            </div>
            <div class="news-item">
                <div class="news-icon">
                    <i class="fas fa-tag"></i>
                </div>
                <div class="news-content">
                    <div class="news-title">Top deal - Siêu rẻ</div>
                    <div class="news-desc">Giảm giá sốc hàng ngàn sản phẩm</div>
                </div>
            </div>
            <div class="news-item">
                <div class="news-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="news-content">
                    <div class="news-title">Top sách đáng đọc</div>
                    <div class="news-desc">Ưu đãi lên đến 50%</div>
                </div>
            </div>
            <a href="#" class="view-all">Xem tất cả <i class="fas fa-chevron-right"></i></a>
        </div>
    </div>
    
</div>

<!-- Import widget component -->
<jsp:include page="/chatbot.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${root}/js/home.js"></script>
<!-- KHÔNG CẦN thêm chatbot.js nữa vì script đã có trong JSP -->
</body>
</html>

</body>
</html>