<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiki x Kính Mắt - Kính râm, gọng kính, tròng kính chính hãng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background-color: #f5f5fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        .text-tiki { color: #1A94FF; }
        .bg-tiki { background-color: #1A94FF; }
        
        /* Header styles */
        .tiki-header { background-color: #fff; border-bottom: 1px solid #e1e1e1; padding-bottom: 8px;}
        .top-promo { background-color: #f2fdf6; color: #00ab56; font-size: 13px; font-weight: 500; }
        .logo-text { color: #1A94FF; font-weight: 800; font-size: 32px; letter-spacing: -1px; line-height: 1; }
        .logo-sub { color: #1A94FF; font-size: 12px; font-weight: 600; }
        
        /* Search form */
        .search-box { border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .search-box input { border: none; box-shadow: none !important; font-size: 14px; }
        .search-btn { border-left: 1px solid #ddd; background: transparent; color: #1A94FF; font-weight: 500; border-radius: 0; width: 100px; }
        .search-btn:hover { background-color: #f5f5f5; color: #1A94FF; }
        .search-tags a { color: #808089; font-size: 12px; text-decoration: none; margin-right: 10px; }
        
        /* Header icons */
        .header-action { color: #808089; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 6px; padding: 8px; border-radius: 8px;}
        .header-action:hover { background-color: #f5f5fa; color: #808089; }
        .header-action.active { color: #1A94FF; }
        
        /* Commitments & Location */
        .commitment-bar { font-size: 12px; color: #808089; border-top: 1px solid #f0f0f0; padding-top: 8px; margin-top: 8px; }
        .commitment-item { display: inline-flex; align-items: center; margin-right: 16px; }
        .location-text { font-size: 13px; color: #38383d; text-decoration: underline; cursor: pointer; }
        
        /* Main Layout */
        .sidebar-menu { background: #fff; border-radius: 8px; padding: 12px 0; }
        .menu-title { font-size: 14px; font-weight: 600; color: #38383d; padding: 0 16px 8px; margin-bottom: 0;}
        .menu-item { display: flex; align-items: center; gap: 12px; padding: 8px 16px; color: #38383d; text-decoration: none; font-size: 13px; transition: background 0.2s;}
        .menu-item:hover { background: #f5f5fa; }
        .menu-item i { width: 20px; text-align: center; }
        
        /* Banners & Quick Links */
        .banner-img { width: 100%; border-radius: 8px; object-fit: cover; height: 100%; }
        .quick-link-item { text-align: center; width: 80px; text-decoration: none; color: #38383d; }
        .quick-link-item img { width: 44px; height: 44px; margin-bottom: 8px; background: #fff; border-radius: 16px; padding: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); object-fit: cover;}
        .quick-link-item span { font-size: 12px; display: block; line-height: 1.4; }
        
        /* Floating Widget */
        .floating-widget { position: fixed; right: 20px; bottom: 80px; background: #1A94FF; border-radius: 24px; padding: 10px 4px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 1000;}
        .floating-btn { width: 48px; height: 48px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; text-decoration: none; font-size: 10px; margin: 4px 0;}
        .floating-btn i { font-size: 20px; margin-bottom: 2px; }
        .floating-btn:hover { color: white; opacity: 0.9; }

        /* Product Card */
        .product-card { border: 1px solid transparent; border-radius: 8px; background: #fff; transition: box-shadow 0.2s; }
        .product-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-color: #ddd;}
    </style>
</head>
<body>

    <header class="tiki-header position-sticky top-0 z-3">
        <div class="top-promo text-center py-2">
            Tặng kèm hộp bảo vệ & khăn lau Nano cao cấp. Miễn phí vận chuyển đơn từ <strong>150.000đ</strong>
        </div>

        <div class="container-fluid px-4 pt-3">
            <div class="row align-items-start">
                <div class="col-lg-2 col-md-3">
                    <a href="${root}/home" class="text-decoration-none d-inline-block">
                        <div class="logo-text d-flex align-items-center">
                            <i class="fas fa-glasses me-2" style="font-size: 28px;"></i>TIKI
                        </div>
                        <div class="logo-sub text-center">Tốt & Thời Trang</div>
                    </a>
                </div>
                
                <div class="col-lg-7 col-md-6">
                    <form action="${root}/search" method="GET">
                        <div class="search-box d-flex bg-white">
                            <span class="ps-3 pe-2 d-flex align-items-center text-muted">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" name="keyword" class="form-control py-2" 
                                   placeholder="Tìm gọng kính titanium, kính râm RayBan, kính chống tia UV..." 
                                   value="<c:out value='${param.keyword}'/>" autocomplete="off">
                            <button class="btn search-btn px-4" type="submit">Tìm kiếm</button>
                        </div>
                    </form>
                    <div class="search-tags mt-2">
                        <a href="#">kính râm nam</a>
                        <a href="#">gọng kính nữ</a>
                        <a href="#">kính chống ánh sáng xanh</a>
                        <a href="#">gọng titanium</a>
                        <a href="#">kính RayBan</a>
                        <a href="#">phụ kiện kính</a>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-3">
                    <div class="d-flex justify-content-end align-items-center gap-2">
                        <a href="${root}/home" class="header-action active">
                            <i class="fas fa-home fs-5"></i> Trang chủ
                        </a>
                        
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="dropdown">
                                    <a href="#" class="header-action" data-bs-toggle="dropdown">
                                        <i class="far fa-smile fs-5"></i>
                                        <span class="text-truncate" style="max-width: 100px;">${sessionScope.user.fullName}</span>
                                    </a>
                                    <ul class="dropdown-menu shadow border-0">
                                        <c:if test="${'admin' eq sessionScope.user.role}">
                                            <li><a class="dropdown-item text-danger" href="${root}/admin/products"><i class="fas fa-crown me-2"></i>Quản trị</a></li>
                                        </c:if>
                                        <li><a class="dropdown-item" href="${root}/profile">Tài khoản của tôi</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${root}/logout">Đăng xuất</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${root}/login" class="header-action">
                                    <i class="far fa-smile fs-5"></i> Tài khoản
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <div class="vr mx-1 text-muted" style="height: 24px; opacity: 0.2;"></div>

                        <a href="${root}/cart" class="header-action position-relative">
                            <i class="fas fa-shopping-cart text-tiki fs-5"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-count" style="margin-left: -10px; font-size: 10px;">
                                0
                            </span>
                        </a>
                    </div>
                    
                    <div class="text-end mt-2">
                        <span class="text-muted" style="font-size: 13px;"><i class="fas fa-map-marker-alt me-1"></i>Giao đến:</span>
                        <span class="location-text fw-medium">Q. 1, P. Bến Nghé, Hồ Chí Minh</span>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="commitment-bar d-flex flex-wrap align-items-center">
                        <span class="fw-bold text-dark me-3">Cam kết của shop</span>
                        <div class="commitment-item"><i class="fas fa-check-circle text-primary me-1"></i> 100% Kính chính hãng</div>
                        <div class="commitment-item"><i class="fas fa-tools text-primary me-1"></i> Bảo hành gọng 12 tháng</div>
                        <div class="commitment-item"><i class="fas fa-eye text-primary me-1"></i> Đo mắt & Tư vấn miễn phí</div>
                        <div class="commitment-item"><i class="fas fa-box-open text-primary me-1"></i> 7 ngày đổi trả</div>
                        <div class="commitment-item"><i class="fas fa-shipping-fast text-primary me-1"></i> Giao siêu tốc 2h</div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="container-fluid px-4 py-4">
        <div class="row g-4">
            <div class="col-lg-2 d-none d-lg-block">
                <div class="sidebar-menu shadow-sm">
                    <h3 class="menu-title">Danh mục Kính</h3>
                    <a href="#" class="menu-item">
                        <i class="fas fa-glasses text-info fs-5"></i> Gọng Kính Thời Trang
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-sun text-warning fs-5"></i> Kính Râm / Kính Mát
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-desktop text-primary fs-5"></i> Kính Chống Ánh Sáng Xanh
                    </a>
                    <a href="#" class="menu-item">
                        <i class="far fa-eye text-success fs-5"></i> Kính Cận / Viễn / Loạn
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-biking text-danger fs-5"></i> Kính Thể Thao / Đi Đường
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-child text-pink fs-5" style="color: hotpink;"></i> Kính Mắt Trẻ Em
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-circle-notch text-secondary fs-5"></i> Tròng Kính Các Loại
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-spray-can text-dark fs-5"></i> Phụ Kiện & Vệ Sinh
                    </a>
                </div>
            </div>

            <div class="col-lg-10">
                <div class="row g-3 mb-4 bg-white p-3 rounded-3 shadow-sm">
                    <div class="col-md-7">
                        <a href="#">
                            <img src="https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=800&h=350&q=80" alt="Bộ sưu tập Kính Mát Hè" class="banner-img">
                        </a>
                    </div>
                    <div class="col-md-5">
                        <a href="#">
                            <img src="https://images.unsplash.com/photo-1577803645773-f96470509666?auto=format&fit=crop&w=600&h=350&q=80" alt="Gọng Kính Sinh Viên" class="banner-img">
                        </a>
                    </div>
                </div>

                <div class="bg-white p-3 rounded-3 shadow-sm mb-4">
                    <div class="d-flex flex-wrap justify-content-between">
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/FFEbee/d32f2f?text=MỚI" alt="Icon">
                            <span>Hàng Mới Về</span>
                        </a>
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/E3F2FD/1976D2?text=NAM" alt="Icon">
                            <span>Kính Nam</span>
                        </a>
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/FCE4EC/C2185B?text=NỮ" alt="Icon">
                            <span>Kính Nữ</span>
                        </a>
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/FFF8E1/FBC02D?text=SALE" alt="Icon">
                            <span>Xả Kho Giảm Giá</span>
                        </a>
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/E8F5E9/388E3C?text=Ti" alt="Icon">
                            <span>Gọng Titanium</span>
                        </a>
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/F3E5F5/7B1FA2?text=RB" alt="Icon">
                            <span>Kính Ray-Ban</span>
                        </a>
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/EFEBE9/5D4037?text=BOX" alt="Icon">
                            <span>Phụ Kiện Kính</span>
                        </a>
                        <a href="#" class="quick-link-item">
                            <img src="https://via.placeholder.com/64/E0F7FA/0097A7?text=LENS" alt="Icon">
                            <span>Đổi Tròng Kính</span>
                        </a>
                    </div>
                </div>

                <div class="bg-white p-3 rounded-3 shadow-sm">
                    <h4 class="mb-4 text-dark fw-bold px-2 py-2 border-bottom">Xu Hướng Kính Mắt Dành Cho Bạn</h4>
                    <c:choose>
                        <c:when test="${not empty products}">
                            <div class="row g-3">
                                <c:forEach var="product" items="${products}">
                                    <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
                                        <div class="card h-100 product-card overflow-hidden">
                                            <a href="${root}/product?id=${product.id}" class="text-decoration-none text-dark">
                                                <img src="${not empty product.image ? (root += product.image) : ('https://via.placeholder.com/300x300?text=' += product.brand)}" 
                                                     class="card-img-top img-fluid" alt="${product.name}" style="aspect-ratio: 1; object-fit: cover;">
                                                <div class="card-body p-2">
                                                    <p class="card-title mb-1 text-truncate" style="font-size: 13px;">
                                                        <c:if test="${product.isFeatured}">
                                                            <span class="badge bg-danger p-1 me-1">Hot</span>
                                                        </c:if>
                                                        ${product.name}
                                                    </p>
                                                    <div class="d-flex align-items-center mb-1">
                                                        <span class="text-warning small me-1"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></span>
                                                        <span class="text-muted" style="font-size: 11px;">| Đã bán 250+</span>
                                                    </div>
                                                    <div class="price fw-bold text-danger fs-6">
                                                        <fmt:formatNumber value="${product.salePrice}" pattern="#,###"/> ₫
                                                        <c:if test="${product.price gt product.salePrice}">
                                                            <span class="badge bg-light text-danger border ms-1">-20%</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="mt-2 text-muted" style="font-size: 11px;">
                                                        <i class="fas fa-gift me-1"></i> Tặng kèm hộp & khăn lau
                                                    </div>
                                                </div>
                                            </a>
                                            <c:if test="${product.stock > 0}">
                                                <div class="px-2 pb-2">
                                                    <button class="btn btn-outline-primary btn-sm w-100 add-to-cart-btn" onclick="addToCart(event, ${product.id}, 1)">
                                                        Thêm giỏ hàng
                                                    </button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5 text-muted">
                                <i class="fas fa-glasses fa-3x mb-3"></i>
                                <h5>Chưa có mẫu kính nào trong mục này</h5>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <div class="floating-widget">
        <a href="#" class="floating-btn">
            <i class="fas fa-eye"></i>
            <span>Tư vấn</span>
        </a>
        <div style="height: 1px; background: rgba(255,255,255,0.2); width: 80%; margin: 0 auto;"></div>
        <a href="#" class="floating-btn">
            <i class="far fa-comment-dots"></i>
            <span>Hỗ trợ</span>
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addToCart(event, productId, quantity = 1) {
            event.preventDefault(); 
            const btn = event.currentTarget;
            const originalContent = btn.innerHTML;
            
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            btn.disabled = true;
            
            fetch(`${root}/cart/add`, {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: `productId=${productId}&quantity=${quantity}`
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    document.querySelector('.cart-count').textContent = data.cartCount;
                    btn.innerHTML = '<i class="fas fa-check"></i>';
                    btn.classList.replace("btn-outline-primary", "btn-success");
                    btn.classList.add("text-white");
                    setTimeout(() => {
                        btn.innerHTML = originalContent;
                        btn.classList.replace("btn-success", "btn-outline-primary");
                        btn.classList.remove("text-white");
                        btn.disabled = false;
                    }, 1500);
                }
            })
            .catch(() => {
                alert('Lỗi kết nối!');
                btn.innerHTML = originalContent;
                btn.disabled = false;
            });
        }
    </script>
</body>
</html>