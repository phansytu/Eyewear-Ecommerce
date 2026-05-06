<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="css/product-detail.css">
    <link rel="stylesheet" href="${root}/css/chatbot.css">
    
    
</head>
<body>
<header>
    <!-- Cuối body, trước thẻ đóng body -->
<jsp:include page="/WEB-INF/includes/header.jsp" />
</header>

<main class="container py-4">
    <c:if test="${empty product}">
        <div class="alert alert-warning text-center py-5">
            <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
            <h4>Sản phẩm không tồn tại!</h4>
            <a href="${root}/home" class="btn btn-danger mt-3">← Về trang chủ</a>
        </div>
    </c:if>
    
    <c:if test="${not empty product}">
        <!-- Product Info Row -->
        <div class="row g-4">
            <!-- Gallery Column -->
            <div class="col-md-5">
                <div class="sticky-top" style="top: 80px;">
                    <!-- Ảnh chính -->
<div class="main-image mb-3">
    <img src="${root}${product.image}" id="mainProductImage" class="img-fluid w-100" alt="${product.name}"
         onerror="this.src='${root}/image/anhdanhmuc/no-image.png'">
</div>

<!-- Ảnh thumbnail -->
<div class="row g-2">
    <div class="col-3">
        <img src="${root}${product.image}" class="thumbnail-img active" 
             onclick="changeMainImage('${root}${product.image}', this)">
    </div>
    <c:if test="${not empty product.images}">
        <c:forEach var="img" items="${product.images}">
            <div class="col-3">
                <img src="${root}${img.imageUrl}" class="thumbnail-img" 
                     onclick="changeMainImage('${root}${img.imageUrl}', this)">
            </div>
        </c:forEach>
    </c:if>
</div>
                </div>
            </div>
            
            <!-- Product Info Column -->
            <div class="col-md-7">
                <div class="bg-white rounded-3 p-4">
                    <h1 class="product-title">${product.name}</h1>
                    
                    <div class="d-flex align-items-center gap-3 mb-3 flex-wrap">
                        <div class="rating-badge">
                            <fmt:formatNumber value="${product.averageRating}" pattern="#.0"/> ★
                        </div>
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= product.averageRating}">
                                        <i class="fas fa-star"></i>
                                    </c:when>
                                    <c:when test="${i - 0.5 <= product.averageRating}">
                                        <i class="fas fa-star-half-alt"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="far fa-star"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <span class="text-muted">(${product.totalReviews} đánh giá)</span>
                    </div>
                    
                    <div class="price-section mb-4">
                        <div class="d-flex align-items-center gap-3 flex-wrap">
                            <span class="h2 text-danger fw-bold mb-0">
                                <fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>₫
                            </span>
                            <c:if test="${product.price > product.salePrice}">
                                <span class="text-decoration-line-through text-muted">
                                    <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                                </span>
                                <span class="badge bg-danger">
                                    -${product.discountPercent}%
                                </span>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Variants -->
                    <c:if test="${not empty product.variants}">
                        <div class="mb-4">
                            <label class="fw-bold mb-2">Phiên bản:</label>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="v" items="${product.variants}">
                                    <button class="btn btn-outline-secondary variant-btn" data-id="${v.id}" data-price="${v.price}">
                                        ${v.color} - ${v.size}
                                    </button>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Quantity -->
                    <div class="mb-4">
                        <label class="fw-bold mb-2">Số lượng:</label>
                        <div class="input-group" style="width: 130px;">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">-</button>
                            <input type="number" class="form-control text-center qty-input" id="quantity" value="1" min="1" max="${product.stock}">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">+</button>
                        </div>
                        <small class="text-muted d-block mt-1">Còn ${product.stock} sản phẩm</small>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="row g-2 mb-4">
                        <div class="col-6">
                            <button class="btn btn-danger w-100 py-3 fw-bold" onclick="buyNow()" ${product.stock <= 0 ? 'disabled' : ''}>
                                <i class="fas fa-bolt me-2"></i>MUA NGAY
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="btn btn-outline-danger w-100 py-3 fw-bold" onclick="addToCartDetail()" ${product.stock <= 0 ? 'disabled' : ''}>
                                <i class="fas fa-cart-plus me-2"></i>THÊM GIỎ HÀNG
                            </button>
                        </div>
                    </div>
                    
                    <!-- Delivery info -->
                    <div class="border-top pt-3">
                        <div class="d-flex gap-3 text-muted small">
                            <span><i class="fas fa-truck me-1"></i> Giao siêu tốc 2h</span>
                            <span><i class="fas fa-shield-alt me-1"></i> Bảo hành 12 tháng</span>
                            <span><i class="fas fa-undo-alt me-1"></i> Đổi trả 30 ngày</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Tabs -->
        <div class="row mt-4">
            <div class="col-12">
                <ul class="nav nav-tabs" id="productTabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" id="desc-tab" data-bs-toggle="tab" data-bs-target="#description" type="button">
                            <i class="fas fa-file-alt me-2"></i>Mô tả sản phẩm
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="specs-tab" data-bs-toggle="tab" data-bs-target="#specifications" type="button">
                            <i class="fas fa-chart-simple me-2"></i>Thông số kỹ thuật
                        </button>
                    </li>
                </ul>
                
                <div class="tab-content bg-white rounded-3 p-4" style="border-top-left-radius: 0 !important;">
                    <!-- Mô tả -->
                    <div class="tab-pane fade show active" id="description" role="tabpanel">
                        <div class="product-description">
                            <c:choose>
    <c:when test="${not empty product.description}">
        <c:out value="${fn:replace(product.description, '
                        ', '<br/>')}" escapeXml="false"/>
    </c:when>
    <c:otherwise>
        Chưa có mô tả chi tiết cho sản phẩm này.
    </c:otherwise>
</c:choose>
                        </div>
                    </div>
                    
                    <!-- Thông số kỹ thuật -->
                    <div class="tab-pane fade" id="specifications" role="tabpanel">
                        <table class="specs-table">
                            <tr><td class="specs-label">Thương hiệu</td><td><strong>${product.brand != null ? product.brand : 'Chưa cập nhật'}</strong></td></tr>
                            <tr><td class="specs-label">Danh mục</td><td><strong>${product.categoryName != null ? product.categoryName : 'Chưa phân loại'}</strong></td></tr>
                            <tr><td class="specs-label">Giới tính</td><td><strong>${product.gender != null ? product.gender : 'Unisex'}</strong></td></tr>
                            <tr><td class="specs-label">Chất liệu gọng</td><td><strong>${product.frameMaterial != null ? product.frameMaterial : 'Chưa cập nhật'}</strong></td></tr>
                            <tr><td class="specs-label">Loại tròng</td><td><strong>${product.lensType != null ? product.lensType : 'Chưa cập nhật'}</strong></td></tr>
                            <tr><td class="specs-label">Chống tia UV</td><td><strong>${product.uvProtection ? 'Có' : 'Không'}</strong></td></tr>
                            <tr><td class="specs-label">Mã sản phẩm</td><td><strong>SP-${product.id}</strong></td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</main>
<jsp:include page="/WEB-INF/includes/chatbot.jsp" />

<footer>
<jsp:include page="/WEB-INF/includes/footer.jsp" />
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let selectedVariantId = null;
    
    // Change main image
    function changeMainImage(src, element) {
        document.getElementById('mainProductImage').src = src;
        document.querySelectorAll('.thumbnail-img').forEach(img => img.classList.remove('active'));
        element.classList.add('active');
    }
    
    // Change quantity
    function changeQty(delta) {
        const input = document.getElementById('quantity');
        let val = parseInt(input.value) || 1;
        val = val + delta;
        const max = parseInt(input.max) || 999;
        if (val < 1) val = 1;
        if (val > max) val = max;
        input.value = val;
    }
    
    // Variant selection
    document.querySelectorAll('.variant-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.variant-btn').forEach(b => b.classList.remove('active', 'btn-danger'));
            this.classList.add('active', 'btn-danger');
            selectedVariantId = this.dataset.id;
        });
    });
    
    // Add to cart
    function addToCartDetail() {
    // Kiểm tra đăng nhập
    <c:if test="${empty sessionScope.user}">
        if (confirm('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!')) {
            window.location.href = '${root}/login';
        }
        return;
    </c:if>
    
    const qty = document.getElementById('quantity').value;
    
    // Tạo form data
    const formData = new URLSearchParams();
    formData.append('action', 'add');
    formData.append('productId', '${product.id}');
    formData.append('quantity', qty);
    if (selectedVariantId) {
        formData.append('variantId', selectedVariantId);
    }
    
    // Gửi POST request
    fetch('${root}/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert('✅ ' + data.message);
            // Cập nhật số lượng trên icon giỏ hàng
            if (data.cartCount !== undefined) {
                updateCartBadge(data.cartCount);
            }
        } else {
            if (data.redirect) {
                window.location.href = '${root}/' + data.redirect;
            } else {
                alert('❌ ' + data.message);
            }
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra, vui lòng thử lại!');
    });
}

// Hàm cập nhật badge giỏ hàng
function updateCartBadge(count) {
    const badge = document.getElementById('cartCountBadge');
    if (badge) {
        if (count > 0) {
            badge.textContent = count;
            badge.style.display = 'inline-block';
        } else {
            badge.style.display = 'none';
        }
    }
}

// Hàm lấy số lượng giỏ hàng khi load trang
function loadCartCount() {
    <c:if test="${not empty sessionScope.user}">
        fetch('${root}/cart/count')
            .then(res => res.json())
            .then(data => updateCartBadge(data.count))
            .catch(err => console.error('Error:', err));
    </c:if>
}

// Gọi khi load trang
document.addEventListener('DOMContentLoaded', loadCartCount);
    
    // Buy now
    function buyNow() {
        const qty = document.getElementById('quantity').value;
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${root}/checkout';
        
        const inputs = [
            {name: 'productId', value: ${product.id}},
            {name: 'quantity', value: qty},
            {name: 'variantId', value: selectedVariantId || ''}
        ];
        
        inputs.forEach(input => {
            const hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = input.name;
            hidden.value = input.value;
            form.appendChild(hidden);
        });
        
        document.body.appendChild(form);
        form.submit();
    }
    
    // Update cart count
    function updateCartCount() {
        fetch('${root}/cart?action=count')
            .then(res => res.json())
            .then(data => {
                const badge = document.querySelector('.badge.bg-danger');
                if (badge) badge.innerText = data.count;
            })
            .catch(error => console.error('Error:', error));
    }
</script>

</body>
</html>