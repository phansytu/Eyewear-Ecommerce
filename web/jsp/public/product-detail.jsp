<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    <style>
        .review-section { margin-top: 0; }
        .review-summary { background: #f8f9fa; border-radius: 12px; padding: 25px; }
        .review-avg { font-size: 48px; font-weight: 700; color: #333; }
        .review-stars { color: #ffc107; font-size: 18px; }
        .review-bar { height: 8px; border-radius: 4px; background: #e9ecef; }
        .review-bar-fill { height: 100%; border-radius: 4px; background: #ffc107; }
        .review-item { border-bottom: 1px solid #eee; padding: 20px 0; }
        .review-item:last-child { border-bottom: none; }
        .review-avatar { width: 45px; height: 45px; border-radius: 50%; background: #667eea; color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 18px; }
        .star-rating i { cursor: pointer; font-size: 28px; transition: transform 0.15s; }
        .star-rating i:hover { transform: scale(1.2); }
        .specs-table { width: 100%; }
        .specs-table td { padding: 10px 15px; border-bottom: 1px solid #eee; }
        .specs-label { width: 180px; color: #888; font-weight: 500; }
    </style>
</head>
<body>

<header>
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
        <div class="row g-4">
            <div class="col-md-5">
                <div class="sticky-top" style="top: 80px;">
                    <div class="main-image mb-3">
                        <img src="${root}${product.image}" id="mainProductImage" class="img-fluid w-100" alt="${product.name}"
                             onerror="this.src='${root}/image/anhdanhmuc/no-image.png'">
                    </div>
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
                                    <c:when test="${i <= product.averageRating}"><i class="fas fa-star"></i></c:when>
                                    <c:when test="${i - 0.5 <= product.averageRating}"><i class="fas fa-star-half-alt"></i></c:when>
                                    <c:otherwise><i class="far fa-star"></i></c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <span class="text-muted">(${product.totalReviews} đánh giá)</span>
                    </div>
                    
                    <div class="price-section mb-4">
                        <span class="h2 text-danger fw-bold mb-0"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>₫</span>
                        <c:if test="${product.price > product.salePrice}">
                            <span class="text-decoration-line-through text-muted"><fmt:formatNumber value="${product.price}" pattern="#,###"/>₫</span>
                            <span class="badge bg-danger">-${product.discountPercent}%</span>
                        </c:if>
                    </div>
                    
                    <c:if test="${not empty product.variants}">
                        <div class="mb-4">
                            <label class="fw-bold mb-2">Phiên bản:</label>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="v" items="${product.variants}">
                                    <button class="btn btn-outline-secondary variant-btn" data-id="${v.id}" data-price="${v.price}">${v.color} - ${v.size}</button>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="mb-4">
                        <label class="fw-bold mb-2">Số lượng:</label>
                        <div class="input-group" style="width: 130px;">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">-</button>
                            <input type="number" class="form-control text-center qty-input" id="quantity" value="1" min="1" max="${product.stock}">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">+</button>
                        </div>
                    </div>
                    
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
                </div>
            </div>
        </div>
        
        <!-- Tabs -->
        <div class="row mt-4">
            <div class="col-12">
                <ul class="nav nav-tabs" id="productTabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#description" type="button">Mô tả</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#specifications" type="button">Thông số</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#reviews" type="button">Đánh giá</button>
                    </li>
                </ul>
                
                <div class="tab-content bg-white rounded-3 p-4" style="border-top-left-radius: 0 !important;">
                    <div class="tab-pane fade show active" id="description" role="tabpanel">
                        <c:if test="${not empty product.description}">
                            <%= ((model.Product) request.getAttribute("product")).getDescription().replace("\n", "<br/>") %>
                        </c:if>
                        <c:if test="${empty product.description}">Chưa có mô tả.</c:if>
                    </div>
                    
                    <div class="tab-pane fade" id="specifications" role="tabpanel">
                        <table class="specs-table">
                            <tr><td class="specs-label">Thương hiệu</td><td><strong>${product.brand != null ? product.brand : '---'}</strong></td></tr>
                            <tr><td class="specs-label">Giới tính</td><td><strong>${product.gender != null ? product.gender : '---'}</strong></td></tr>
                            <tr><td class="specs-label">Chất liệu</td><td><strong>${product.frameMaterial != null ? product.frameMaterial : '---'}</strong></td></tr>
                            <tr><td class="specs-label">Mã SP</td><td><strong>SP-${product.id}</strong></td></tr>
                        </table>
                    </div>
                    
                    <!-- TAB ĐÁNH GIÁ -->
                    <div class="tab-pane fade" id="reviews" role="tabpanel">
                        <div class="review-summary mb-4">
                            <div class="row align-items-center">
                                <div class="col-md-3 text-center border-end">
                                    <div class="review-avg" id="avgRating">0.0</div>
                                    <div class="review-stars mb-1" id="avgStars"></div>
                                    <div class="text-muted" id="totalReviews">0 đánh giá</div>
                                </div>
                                <div class="col-md-5" id="ratingStats"></div>
                                <div class="col-md-4 text-center">
                                    <c:if test="${not empty sessionScope.user}">
                                        <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#reviewModal">
                                            <i class="fas fa-pen me-2"></i>Viết đánh giá
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        <div id="reviewsList"></div>
                        <div class="text-center mt-3" id="loadMoreContainer" style="display:none;">
                            <button class="btn btn-outline-primary" onclick="loadMoreReviews()">Xem thêm</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</main>

<!-- Modal Viết đánh giá -->
<div class="modal fade" id="reviewModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-star text-warning me-2"></i>Viết đánh giá</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="text-center mb-3">
                    <label class="form-label">Chọn số sao:</label>
                    <div class="star-rating" id="starRating">
                        <i class="far fa-star text-warning" data-star="1"></i>
                        <i class="far fa-star text-warning" data-star="2"></i>
                        <i class="far fa-star text-warning" data-star="3"></i>
                        <i class="far fa-star text-warning" data-star="4"></i>
                        <i class="far fa-star text-warning" data-star="5"></i>
                    </div>
                    <small class="text-muted" id="ratingText">Chưa chọn</small>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nhận xét của bạn:</label>
                    <textarea id="reviewComment" class="form-control" rows="4" placeholder="Chia sẻ trải nghiệm về sản phẩm..."></textarea>
                </div>
                <!-- ===== THÊM INPUT ẢNH ===== -->
                <div class="mb-3">
                    <label class="form-label">Hình ảnh (tùy chọn):</label>
                    <input type="file" id="reviewImageInput" class="form-control" accept="image/*" multiple>
                    <small class="text-muted">Có thể chọn nhiều ảnh</small>
                    <div id="imagePreview" class="d-flex gap-2 mt-2 flex-wrap"></div>
                </div>
                <!-- ===== KẾT THÚC ===== -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" id="btnSubmitReview">Gửi đánh giá</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/chatbot.jsp" />
<footer><jsp:include page="/WEB-INF/includes/footer.jsp" /></footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
var _uploadedImages = [];
var _ctx = '${pageContext.request.contextPath}';
var _productId = ${product.id};
var _selectedVariantId = null;
var _selectedRating = 0;
var _currentReviewPage = 1;

// Preview ảnh khi chọn
document.getElementById('reviewImageInput').addEventListener('change', function(e) {
    var files = e.target.files;
    var previewDiv = document.getElementById('imagePreview');
    previewDiv.innerHTML = '';
    
    for (var i = 0; i < files.length; i++) {
        var reader = new FileReader();
        reader.onload = function(ev) {
            var img = document.createElement('img');
            img.src = ev.target.result;
            img.style.cssText = 'width:80px;height:80px;object-fit:cover;border-radius:6px;';
            previewDiv.appendChild(img);
        };
        reader.readAsDataURL(files[i]);
    }
});

// Upload từng ảnh
async function uploadImages(files) {
    var urls = [];
    for (var i = 0; i < files.length; i++) {
        var fd = new FormData();
        fd.append('image', files[i]);
        try {
            var res = await fetch(_ctx + '/upload-review-image', { method: 'POST', body: fd });
            var data = await res.json();
            if (data.success) { urls.push(data.url); }
        } catch(e) { console.error('Upload failed:', e); }
    }
    return urls;
}

// Ảnh
function changeMainImage(src, el) {
    document.getElementById('mainProductImage').src = src;
    document.querySelectorAll('.thumbnail-img').forEach(function(i) { i.classList.remove('active'); });
    el.classList.add('active');
}

// Số lượng
function changeQty(d) {
    var inp = document.getElementById('quantity');
    var v = parseInt(inp.value) + d;
    if (v < 1) v = 1;
    if (v > parseInt(inp.max)) v = parseInt(inp.max);
    inp.value = v;
}

// Variant
document.querySelectorAll('.variant-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.variant-btn').forEach(function(b) { b.classList.remove('active', 'btn-danger'); });
        this.classList.add('active', 'btn-danger');
        _selectedVariantId = this.dataset.id;
    });
});

// Giỏ hàng
function addToCartDetail() {
    <c:if test="${empty sessionScope.user}">
        if (confirm('Vui lòng đăng nhập!')) window.location.href = _ctx + '/login';
        return;
    </c:if>
    var qty = document.getElementById('quantity').value;
    var fd = new URLSearchParams();
    fd.append('action', 'add'); fd.append('productId', _productId); fd.append('quantity', qty);
    if (_selectedVariantId) fd.append('variantId', _selectedVariantId);
    fetch(_ctx + '/cart', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) { alert(d.message); if (d.cartCount) updateCartBadge(d.cartCount); });
}

function updateCartBadge(c) {
    var b = document.getElementById('cartCountBadge');
    if (b) { b.textContent = c; b.style.display = c > 0 ? 'inline-block' : 'none'; }
}

function buyNow() { 
    <c:if test="${empty sessionScope.user}">
        if (confirm('Vui lòng đăng nhập!')) window.location.href = _ctx + '/login';
        return;
    </c:if>
    
    var qty = document.getElementById('quantity').value;
    var fd = new URLSearchParams();
    fd.append('action', 'add');
    fd.append('productId', _productId);
    fd.append('quantity', qty);
    if (_selectedVariantId) fd.append('variantId', _selectedVariantId);
    
    fetch(_ctx + '/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: fd
    })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        if (d.success) {
            window.location.href = _ctx + '/checkout';
        } else {
            alert(d.message);
        }
    });
}

// Đánh giá - Stars
document.querySelectorAll('#starRating i').forEach(function(s) {
    s.addEventListener('click', function() {
        _selectedRating = parseInt(this.dataset.star);
        updateReviewStars();
    });
    s.addEventListener('mouseenter', function() {
        var v = parseInt(this.dataset.star);
        document.querySelectorAll('#starRating i').forEach(function(x, i) {
            x.className = i < v ? 'fas fa-star text-warning' : 'far fa-star text-warning';
        });
    });
    s.addEventListener('mouseleave', updateReviewStars);
});

function updateReviewStars() {
    document.querySelectorAll('#starRating i').forEach(function(x, i) {
        x.className = i < _selectedRating ? 'fas fa-star text-warning' : 'far fa-star text-warning';
    });
}

// Load reviews
function loadReviews(page) {
    fetch(_ctx + '/review?action=list&productId=' + _productId + '&page=' + page)
    .then(function(r) { return r.json(); })
    .then(function(data) {
        document.getElementById('avgRating').textContent = data.average;
        document.getElementById('totalReviews').textContent = data.total + ' đánh giá';
        
        var starsHtml = '';
        for (var i = 1; i <= 5; i++) {
            starsHtml += i <= Math.round(data.average) ? '<i class="fas fa-star"></i>' : '<i class="far fa-star"></i>';
        }
        document.getElementById('avgStars').innerHTML = starsHtml;
        
        var statsHtml = '';
        for (var j = 0; j < 5; j++) {
            var count = data.ratingStats[j] || 0;
            var pct = data.total > 0 ? (count / data.total * 100) : 0;
            statsHtml += '<div class="d-flex align-items-center mb-1">' +
                '<span class="me-2" style="width:40px;">' + (5-j) + ' ★</span>' +
                '<div class="review-bar flex-grow-1"><div class="review-bar-fill" style="width:' + pct + '%"></div></div>' +
                '<span class="ms-2" style="width:30px;">' + count + '</span></div>';
        }
        document.getElementById('ratingStats').innerHTML = statsHtml;
        
        var html = '';
        if (data.reviews && data.reviews.length > 0) {
            data.reviews.forEach(function(r) {
                var stars = '';
                for (var k = 0; k < 5; k++) {
                    stars += k < r.rating ? '<i class="fas fa-star text-warning"></i>' : '<i class="far fa-star text-warning"></i>';
                }
                var avatar = r.userName ? r.userName.charAt(0).toUpperCase() : 'U';
                html += '<div class="review-item">' +
                    '<div class="d-flex align-items-center mb-2">' +
                        '<div class="review-avatar me-3">' + avatar + '</div>' +
                        '<div><strong>' + (r.userName || 'Ẩn danh') + '</strong>' +
                        '<div class="text-muted small">' + (r.timeAgo || '') + '</div></div>' +
                        '<div class="ms-auto">' + stars + '</div>' +
                    '</div>' +
                    '<p>' + (r.comment || '') + '</p>';
                if (r.imageList && r.imageList.length > 0) {
                    html += '<div class="d-flex gap-2 flex-wrap mt-2">';
                    r.imageList.forEach(function(img) {
                        html += '<img src="' + img + '" style="width:80px;height:80px;object-fit:cover;border-radius:6px;cursor:pointer;" onclick="window.open(\'' + img + '\')" onerror="this.style.display=\'none\'">';
                    });
                    html += '</div>';
                }
                html += '</div>';
            });
        } else {
            html = '<div class="text-center py-4 text-muted">Chưa có đánh giá nào!</div>';
        }
        
        if (page === 1) document.getElementById('reviewsList').innerHTML = html;
        else document.getElementById('reviewsList').insertAdjacentHTML('beforeend', html);
        document.getElementById('loadMoreContainer').style.display = data.hasMore ? 'block' : 'none';
        _currentReviewPage = page;
    });
}

function loadMoreReviews() { loadReviews(_currentReviewPage + 1); }

async function submitReview() {
    if (_selectedRating === 0) { alert('Vui lòng chọn số sao!'); return; }
    
    var comment = document.getElementById('reviewComment').value;
    var imageFiles = document.getElementById('reviewImageInput').files;
    
    var imageUrls = [];
    if (imageFiles.length > 0) {
        imageUrls = await uploadImages(imageFiles);
    }
    
    var fd = new URLSearchParams();
    fd.append('action', 'add');
    fd.append('productId', _productId);
    fd.append('rating', _selectedRating);
    fd.append('comment', comment);
    fd.append('images', JSON.stringify(imageUrls));
    
    fetch(_ctx + '/review', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: fd
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        alert(data.message);
        if (data.success) {
            var modal = bootstrap.Modal.getInstance(document.getElementById('reviewModal'));
            if (modal) modal.hide();
            _selectedRating = 0;
            updateReviewStars();
            document.getElementById('reviewComment').value = '';
            document.getElementById('reviewImageInput').value = '';
            document.getElementById('imagePreview').innerHTML = '';
            loadReviews(1);
        }
    });
}

// Init
document.addEventListener('DOMContentLoaded', function() {
    loadReviews(1);
    var btnSubmit = document.getElementById('btnSubmitReview');
    if (btnSubmit) {
        btnSubmit.addEventListener('click', function() { submitReview(); });
    }
});
</script>
</body>
</html>
</body>
</html>