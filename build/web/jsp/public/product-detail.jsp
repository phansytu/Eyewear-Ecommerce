<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - ShopeeVN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${root}/css/shopee.css">
</head>
<body>
    <jsp:include page="../partials/header.jsp"/>

    <main class="main-content py-4">
        <div class="container">
            <c:if test="${empty product}">
                <div class="alert alert-warning text-center py-5 shadow-sm">
                    <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                    <h4>Sản phẩm không tồn tại!</h4>
                    <a href="${root}/home" class="btn btn-danger mt-3">← Về trang chủ</a>
                </div>
            </c:if>
            
            <c:if test="${not empty product}">
                <div class="row g-5">
                    <div class="col-lg-5">
                        <div class="gallery-container sticky-top" style="top: 100px;">
                            <c:set var="productImg" value="${not empty product.image ? root.concat(product.image) : 'https://via.placeholder.com/500x500?text=No+Image'}" />
                            <div class="main-image mb-4 shadow rounded-4 overflow-hidden bg-white">
                                <img src="${productImg}" 
                                     class="img-fluid w-100" alt="${product.name}" id="mainProductImage"
                                     onerror="this.src='https://via.placeholder.com/500x500?text=Error+Image'">
                            </div>
                            
                            <c:if test="${not empty product.images}">
                                <div class="row g-2 thumbnail-gallery">
                                    <c:forEach var="image" items="${product.images}" varStatus="status">
                                        <div class="col-3">
                                            <img src="${root}${image.imageUrl}" 
                                                 class="img-fluid rounded-3 shadow-sm thumbnail-img ${image.isMain ? 'active border border-danger' : ''}"
                                                 onclick="changeMainImage('${root}${image.imageUrl}', event)"
                                                 alt="Thumbnail ${status.index + 1}" style="cursor: pointer; height: 80px; width: 100%; object-fit: cover;">
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="col-lg-7">
                        <div class="product-info-card p-4 shadow rounded-4 h-100 bg-white">
                            <div class="d-flex justify-content-between align-items-start mb-4">
                                <div>
                                    <h1 class="product-title mb-2 fs-2 fw-bold">${product.name}</h1>
                                    <div class="product-id small text-muted mb-2">Mã SP: PD${product.id}</div>
                                    <div class="rating-section d-flex align-items-center mb-3">
                                        <div class="stars me-3 text-warning">
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                                        </div>
                                        <span class="text-muted small">4.8 (127 đánh giá)</span>
                                    </div>
                                </div>
                                <c:if test="${not empty sessionScope.user}">
                                    <button class="btn btn-outline-danger btn-lg rounded-circle wishlist-toggle" onclick="toggleWishlist(${product.id})">
                                        <i class="far fa-heart"></i>
                                    </button>
                                </c:if>
                            </div>
                            
                            <div class="price-section bg-light p-4 rounded-3 mb-4">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <div class="h2 mb-1 fw-bold text-danger">
                                            <fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>đ
                                        </div>
                                        <c:if test="${product.price gt product.salePrice}">
                                            <div class="h5 text-decoration-line-through text-muted mb-1">
                                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>đ
                                            </div>
                                            <div class="badge bg-danger fs-6 px-3 py-1">-${product.discountPercent}% GIẢM</div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-4 text-md-end">
                                        <div class="stock-status ${product.stock > 0 ? 'text-success' : 'text-danger'} fw-bold">
                                            <i class="fas fa-${product.stock > 0 ? 'check-circle' : 'times-circle'} me-1"></i>
                                            ${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty product.variants}">
                                <div class="variants-section mb-4">
                                    <h6 class="fw-bold mb-3">🎨 Chọn phiên bản:</h6>
                                    <div class="d-flex flex-wrap gap-2">
                                        <c:forEach var="variant" items="${product.variants}">
                                            <input type="radio" class="btn-check" name="variant" id="variant${variant.id}" value="${variant.id}" ${variant.stock > 0 ? '' : 'disabled'}>
                                            <label class="btn btn-outline-dark d-flex align-items-center p-2" for="variant${variant.id}">
                                                <span class="variant-color me-2 shadow-sm" style="background: ${variant.color}; width: 18px; height: 18px; border-radius: 50%;"></span>
                                                ${variant.color} - ${variant.size}
                                            </label>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                            
                            <div class="quantity-section mb-4">
                                <label class="form-label fw-bold mb-2">Số lượng:</label>
                                <div class="input-group" style="width: 140px;">
                                    <button class="btn btn-outline-secondary" onclick="changeQty(-1)">-</button>
                                    <input type="number" class="form-control text-center qty-input fw-bold" value="1" min="1" max="${product.stock}">
                                    <button class="btn btn-outline-secondary" onclick="changeQty(1)">+</button>
                                </div>
                            </div>
                            
                            <div class="buy-actions row g-2 mb-4">
                                <div class="col-6">
                                    <button class="btn btn-danger btn-lg w-100 fw-bold py-3 buy-now-btn" onclick="buyNow()" ${product.stock > 0 ? '' : 'disabled'}>
                                        <i class="fas fa-bolt me-2"></i>MUA NGAY
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button class="btn btn-outline-danger btn-lg w-100 fw-bold py-3 add-cart-detail-btn" onclick="addToCartDetail()" ${product.stock > 0 ? '' : 'disabled'}>
                                        <i class="fas fa-cart-plus me-2"></i>THÊM GIỎ HÀNG
                                    </button>
                                </div>
                            </div>
                            
                            <div class="product-specs border-top pt-4">
                                <h6 class="fw-bold mb-3"><i class="fas fa-info-circle me-2 text-primary"></i>Thông số kỹ thuật</h6>
                                <div class="row g-3 small">
                                    <div class="col-6"><span class="text-muted">Thương hiệu:</span> <span class="fw-bold">${product.brand}</span></div>
                                    <div class="col-6"><span class="text-muted">Danh mục:</span> <span class="fw-bold">${product.categoryName}</span></div>
                                    <div class="col-6"><span class="text-muted">Giới tính:</span> <span class="fw-bold">${product.gender}</span></div>
                                    <div class="col-6"><span class="text-muted">Chất liệu:</span> <span class="fw-bold">${product.frameMaterial}</span></div>
                                    <c:if test="${not empty product.lensType}">
                                        <div class="col-6"><span class="text-muted">Loại tròng:</span> <span class="fw-bold">${product.lensType}</span></div>
                                    </c:if>
                                    <div class="col-6">
                                        <span class="text-muted">Chống UV:</span> 
                                        <span class="${product.uvProtection ? 'text-success' : 'text-muted'} fw-bold">
                                            ${product.uvProtection ? 'Có' : 'Không'}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </main>

    <jsp:include page="../partials/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let selectedVariantId = null;
        const hasVariants = ${not empty product.variants};

        function changeMainImage(imageUrl, event) {
            document.getElementById('mainProductImage').src = imageUrl;
            document.querySelectorAll('.thumbnail-img').forEach(img => {
                img.classList.remove('active', 'border', 'border-danger');
            });
            event.currentTarget.classList.add('active', 'border', 'border-danger');
        }

        function changeQty(delta) {
            const input = document.querySelector('.qty-input');
            const maxStock = parseInt(input.max) || 1;
            let val = parseInt(input.value) + delta;
            input.value = Math.max(1, Math.min(val, maxStock));
        }

        document.querySelectorAll('input[name="variant"]').forEach(radio => {
            radio.addEventListener('change', function() {
                selectedVariantId = this.value;
            });
        });

        function addToCartDetail() {
            if (hasVariants && !selectedVariantId) {
                alert("Vui lòng chọn phiên bản sản phẩm!");
                return;
            }
            const qty = document.querySelector('.qty-input').value;
            // Gọi hàm addToCart chung từ header/main JS
            if (typeof addToCart === "function") {
                addToCart(null, '${product.id}', qty, selectedVariantId);
            } else {
                console.error("Hàm addToCart chưa được định nghĩa.");
            }
        }

        function buyNow() {
            if (hasVariants && !selectedVariantId) {
                alert("Vui lòng chọn phiên bản sản phẩm!");
                return;
            }
            const qty = document.querySelector('.qty-input').value;
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${root}/checkout';
            
            const params = { productId: '${product.id}', variantId: selectedVariantId || '', quantity: qty };
            for (const key in params) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = params[key];
                form.appendChild(input);
            }
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
</html>