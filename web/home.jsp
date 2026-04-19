<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TuKhanhHuy x Kính Mắt - Kính râm, gọng kính chính hãng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f5f5fa; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; }
        .text-tiki { color: #1A94FF; }
        
        /* Header */
        .tiki-header { background-color: #fff; border-bottom: 1px solid #e1e1e1; padding-bottom: 8px;}
        .top-promo { background-color: #f2fdf6; color: #00ab56; font-size: 13px; font-weight: 500; }
        .logo-text { color: #1A94FF; font-weight: 800; font-size: 32px; letter-spacing: -1px; line-height: 1; }
        .logo-sub { color: #1A94FF; font-size: 12px; font-weight: 600; }
        .search-box { border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .search-box input { border: none; box-shadow: none !important; font-size: 14px; }
        .search-btn { border-left: 1px solid #ddd; color: #1A94FF; font-weight: 500; border-radius: 0; width: 100px; }
        .search-btn:hover { background-color: #f5f5f5; }
        .search-tags a { color: #808089; font-size: 12px; text-decoration: none; margin-right: 10px; }
        .header-action { color: #808089; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 6px; padding: 8px; border-radius: 8px;}
        .header-action:hover { background-color: #f5f5fa; }
        
        /* Cam kết */
        .commitment-bar { font-size: 12px; color: #808089; border-top: 1px solid #f0f0f0; padding-top: 8px; margin-top: 8px; }
        
        /* Menu Sidebar */
        .sidebar-menu { border-radius: 8px; }
        .hover-bg-light:hover { background-color: #f5f5fa; }
        .hover-text-primary:hover { color: #1A94FF !important; }
        
        /* Banners & Quick Links */
        .banner-img { width: 100%; border-radius: 8px; object-fit: cover; height: 100%; transition: opacity 0.2s;}
        .banner-img:hover { opacity: 0.9; }
        .quick-link-item { text-align: center; width: 85px; text-decoration: none; color: #38383d; }
        .quick-link-item span { font-size: 12px; display: block; line-height: 1.4; margin-top: 4px;}
        .icon-circle { width: 44px; height: 44px; border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto; font-size: 20px; transition: transform 0.2s;}
        .quick-link-item:hover .icon-circle { transform: translateY(-3px); }
        .bg-1 { background: #FDE8E8; color: #E02424; }
        .bg-2 { background: #E1EFFE; color: #1C64F2; }
        .bg-3 { background: #FDF6B2; color: #C27803; }
        .bg-4 { background: #DEF7EC; color: #03543F; }
        .bg-5 { background: #E5EDFF; color: #3F83F8; }
        .bg-6 { background: #FCE8F3; color: #C81E1E; }

        /* Floating Widget */
        .floating-widget { position: fixed; right: 20px; bottom: 80px; background: #1A94FF; border-radius: 24px; padding: 10px 4px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 1000;}
        .floating-btn { width: 48px; height: 48px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; text-decoration: none; font-size: 10px; margin: 4px 0;}
        .floating-btn i { font-size: 20px; margin-bottom: 2px; }

        /* Product Card */
        .product-card { border: 1px solid transparent; border-radius: 8px; transition: box-shadow 0.2s; }
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
                            <i class="fas fa-glasses me-2" style="font-size: 26px;"></i>TuKhanhHuy
                        </div>
                        <div class="logo-sub text-center">Tốt & Thời Trang</div>
                    </a>
                </div>
                
                <div class="col-lg-7 col-md-6">
                    <form action="${root}/search" method="GET">
                        <div class="search-box d-flex bg-white">
                            <span class="ps-3 pe-2 d-flex align-items-center text-muted"><i class="fas fa-search"></i></span>
                            <input type="text" name="keyword" class="form-control py-2" placeholder="Tìm gọng kính titanium, kính râm RayBan..." value="<c:out value='${param.keyword}'/>">
                            <button class="btn search-btn px-4" type="submit">Tìm kiếm</button>
                        </div>
                    </form>
                    <div class="search-tags mt-2">
    <a href="${root}/category?id=18">gọng kính thời trang</a>
    <a href="${root}/category?id=19">kính râm / kính mát</a>
    <a href="${root}/category?id=20">kính chống ánh sáng xanh</a>
    <a href="${root}/category?id=21">tròng kính</a>
    <a href="${root}/category?id=22">kính áp tròng</a>
    <a href="${root}/category?id=23">phụ kiện kính</a>
</div>
                </div>
                
                <div class="col-lg-3 col-md-3">
                    <div class="d-flex justify-content-end align-items-center gap-2">
                        <a href="${root}/home" class="header-action"><i class="fas fa-home fs-5 text-tiki"></i> Trang chủ</a>
                        <a href="${root}/login" class="header-action"><i class="far fa-smile fs-5"></i> Tài khoản</a>
                        <div class="vr mx-1 text-muted" style="height: 24px; opacity: 0.2;"></div>
                        <a href="${root}/cart" class="header-action position-relative">
                            <i class="fas fa-shopping-cart text-tiki fs-5"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="margin-left:-10px; font-size:10px;">0</span>
                        </a>
                    </div>
                    <div class="text-end mt-2">
                        <span class="text-muted" style="font-size: 13px;"><i class="fas fa-map-marker-alt me-1"></i>Giao đến:</span>
                        <span class="fw-medium" style="font-size: 13px;">Q. 1, P. Bến Nghé, Hồ Chí Minh</span>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="commitment-bar d-flex flex-wrap align-items-center gap-3">
                        <span class="fw-bold text-dark">Cam kết của shop</span>
                        <span><i class="fas fa-check-circle text-primary"></i> 100% Kính chính hãng</span>
                        <span><i class="fas fa-tools text-primary"></i> Bảo hành gọng 12 tháng</span>
                        <span><i class="fas fa-eye text-primary"></i> Đo mắt & Tư vấn miễn phí</span>
                        <span><i class="fas fa-shipping-fast text-primary"></i> Giao siêu tốc 2h</span>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="container-fluid px-4 py-4">
        <div class="row g-3">
            
            <div class="col-xl-2 col-lg-3 d-none d-lg-block">
                <div class="sidebar-menu bg-white p-3 shadow-sm sticky-top" style="top: 80px; z-index: 1;">
                    <h6 class="fw-bold text-dark mb-3">Danh mục Kính</h6>
                    <div class="nav flex-column">
                        <c:forEach var="cat" items="${categories}">
                            <c:if test="${cat.parent}">
                                <div class="menu-parent mb-1">
                                    <a href="${root}/category?id=${cat.id}" class="d-flex align-items-center py-2 px-2 text-dark text-decoration-none rounded hover-bg-light fw-medium">
                                        <img src="${root}/${cat.image}" onerror="this.onerror=null; this.src='https://salt.tikicdn.com/cache/100x100/ts/category/13/64/43/226301adcc7660ffcf44a61bb6df99b7.png'" alt="icon" class="me-3" style="width: 24px; height: 24px; object-fit: cover;">
                                        <span style="font-size: 13px;"><c:out value="${cat.name}"/></span>
                                    </a>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${empty categories}">
                            <p class="text-muted small mt-2">Chưa có danh mục nào.</p>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="col-xl-10 col-lg-9">
                
                <div class="row g-3 mb-4 bg-white p-2 rounded-3 shadow-sm mx-0">
                    <div class="col-md-7 px-1">
                        <img src="https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=800&h=300&q=80" alt="Banner 1" class="banner-img">
                    </div>
                    <div class="col-md-5 px-1">
                        <img src="https://images.unsplash.com/photo-1577803645773-f96470509666?auto=format&fit=crop&w=600&h=300&q=80" alt="Banner 2" class="banner-img">
                    </div>
                </div>

                <div class="bg-white p-3 rounded-3 shadow-sm mb-4">
                    <div class="d-flex flex-wrap justify-content-between gap-2">
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-1"><i class="fas fa-fire"></i></div><span>Hàng Mới Về</span></a>
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-2"><i class="fas fa-mars"></i></div><span>Kính Nam</span></a>
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-6"><i class="fas fa-venus"></i></div><span>Kính Nữ</span></a>
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-3"><i class="fas fa-percentage"></i></div><span>Giảm Giá</span></a>
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-7"><i class="fas fa-gem"></i></div><span>Gọng Titanium</span></a>
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-4"><i class="fas fa-sun"></i></div><span>Kính Râm</span></a>
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-8"><i class="fas fa-box-open"></i></div><span>Phụ Kiện</span></a>
                        <a href="#" class="quick-link-item"><div class="icon-circle bg-5"><i class="fas fa-eye"></i></div><span>Tròng Kính</span></a>
                    </div>
                </div>

                <div class="bg-white p-3 rounded-3 shadow-sm">
                    <h5 class="mb-4 text-dark fw-bold px-2 py-2 border-bottom">Xu Hướng Kính Mắt Dành Cho Bạn</h5>
                    
                    <div class="row g-3">
                        <c:forEach var="p" items="${featured}">
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
                                <div class="card h-100 product-card overflow-hidden bg-white">
                                    <a href="${root}/product?id=${p.id}" class="text-decoration-none text-dark">
                                        <img src="${root}/${p.image}" class="card-img-top" alt="${p.name}" onerror="this.onerror=null; this.src='https://salt.tikicdn.com/cache/280x280/ts/product/4e/9e/d4/0d8b76c8c49e29fbd342207ff0132df7.jpg'">
                                        <div class="card-body p-2">
                                            <p class="card-title mb-1 text-truncate" style="font-size: 13px;"><c:out value="${p.name}"/></p>
                                            <div class="fw-bold text-danger fs-6">
                                                <fmt:formatNumber value="${p.salePrice}" pattern="#,###"/> ₫
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty featured}">
                            <div class="col-12 py-5 text-center text-muted">
                                <i class="fas fa-box-open fs-1 mb-3 text-light"></i>
                                <p>Chưa có sản phẩm nổi bật nào.</p>
                            </div>
                        </c:if>
                    </div>
                </div>

            </div> </div>
    </main>

    <div class="floating-widget">
        <a href="#" class="floating-btn"><i class="fas fa-eye"></i><span>Tư vấn</span></a>
        <div style="height: 1px; background: rgba(255,255,255,0.2); width: 80%; margin: 0 auto;"></div>
        <a href="#" class="floating-btn"><i class="far fa-comment-dots"></i><span>Hỗ trợ</span></a>
    </div>

    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {

            // Chức năng Toggle menu con
            document.querySelectorAll('.menu-toggle').forEach(toggle => {
                toggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    const parentId = this.dataset.id;
                    const childMenu = document.getElementById('child-' + parentId);
                    if (childMenu) childMenu.classList.toggle('show');
                });
            });

            // Load sản phẩm theo danh mục
            document.querySelectorAll('.menu-item').forEach(item => {
                if(item.dataset.id) {
                    item.addEventListener('click', function(e) {
                        e.preventDefault();
                        const catId = this.dataset.id;

                        document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));
                        this.classList.add('active');

                        fetch(`${root}/categoryProducts?id=` + catId)
                            .then(res => res.text())
                            .then(html => {
                                const container = document.getElementById('product-container');
                                if (container) {
                                    container.innerHTML = html;
                                    container.scrollIntoView({ behavior: 'smooth' });
                                }
                            })
                            .catch(err => console.error('Lỗi load sản phẩm:', err));
                    });
                }
            });
        });
    </script>
</body>
</html>