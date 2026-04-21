<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty categoryName ? categoryName : 'Danh mục sản phẩm'} - TuKhanhHuy x Kính Mắt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f5f5fa; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; }
        .text-tiki { color: #1A94FF; }
        .bg-tiki { background-color: #1A94FF; }
        
        /* Header */
        .tiki-header { background-color: #fff; border-bottom: 1px solid #e1e1e1; padding-bottom: 8px;}
        .top-promo { background-color: #f2fdf6; color: #00ab56; font-size: 13px; font-weight: 500; }
        .logo-text { color: #1A94FF; font-weight: 800; font-size: 32px; letter-spacing: -1px; line-height: 1; }
        .logo-sub { color: #1A94FF; font-size: 12px; font-weight: 600; }
        .search-box { border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .search-box input { border: none; box-shadow: none !important; font-size: 14px; }
        .search-btn { border-left: 1px solid #ddd; background: transparent; color: #1A94FF; font-weight: 500; border-radius: 0; width: 100px; }
        .search-tags a { color: #808089; font-size: 12px; text-decoration: none; margin-right: 10px; }
        .header-action { color: #808089; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 6px; padding: 8px; border-radius: 8px;}
        
        /* Breadcrumb */
        .tiki-breadcrumb { font-size: 13px; padding: 12px 0; }
        .tiki-breadcrumb a { color: #808089; text-decoration: none; }
        .tiki-breadcrumb a:hover { text-decoration: underline; }
        
        /* Layout & Sidebar */
        .sidebar-section { background: #fff; border-radius: 8px; padding: 16px; margin-bottom: 16px; }
        .sidebar-title { font-size: 14px; font-weight: 600; color: #38383d; margin-bottom: 12px; text-transform: uppercase;}
        .sidebar-list { list-style: none; padding: 0; margin: 0; }
        .sidebar-list li { margin-bottom: 10px; }
        .sidebar-list a { color: #38383d; font-size: 13px; text-decoration: none; display: flex; align-items: center; }
        .sidebar-list a:hover { color: #1A94FF; }
        
        /* Filters */
        .filter-bar { background: #fff; border-radius: 8px; padding: 16px; margin-bottom: 16px; }
        .filter-title { font-size: 18px; font-weight: 600; margin-bottom: 16px; color: #38383d; }
        .filter-group { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; margin-bottom: 12px;}
        .filter-label { font-size: 13px; color: #38383d; font-weight: 500; min-width: 80px;}
        .filter-btn { border: 1px solid #ddd; background: #fff; border-radius: 4px; padding: 6px 12px; font-size: 13px; color: #38383d; cursor: pointer; text-decoration: none;}
        .filter-btn:hover, .filter-btn.active { border-color: #1A94FF; color: #1A94FF; background: #f0f8ff; }
        
        /* Product Card */
        .product-card { border: 1px solid transparent; border-radius: 8px; background: #fff; transition: box-shadow 0.2s; position: relative; }
        .product-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-color: #ddd;}
        .badge-chinh-hang { position: absolute; top: 10px; left: 10px; z-index: 2; height: 20px; }
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
                        <div class="logo-text d-flex align-items-center"><i class="fas fa-glasses me-2" style="font-size: 28px;"></i>TIKI</div>
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
                        <a href="${root}/category?id=18">kính râm nam</a>
                        <a href="${root}/category?id=19">gọng kính nữ</a>
                        <a href="${root}/category?id=20">kính chống ánh sáng xanh</a>
                        <a href="${root}/category?id=21">gọng titanium</a>
                        <a href="${root}/category?id=22">kính RayBan</a>
                        <a href="${root}/category?id=23">phụ kiện kính</a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-3">
                    <div class="d-flex justify-content-end align-items-center gap-2">
                        <a href="${root}/home" class="header-action"><i class="fas fa-home fs-5"></i> Trang chủ</a>
                        <a href="${root}/profile" class="header-action"><i class="far fa-smile fs-5"></i> Tài khoản</a>
                        <div class="vr mx-1 text-muted" style="height: 24px; opacity: 0.2;"></div>
                        <a href="${root}/cart" class="header-action position-relative">
                            <i class="fas fa-shopping-cart text-tiki fs-5"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="margin-left: -10px; font-size: 10px;">2</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="container-fluid px-4 pb-5">
        <div class="tiki-breadcrumb">
            <a href="${root}/home">Trang chủ</a> <i class="fas fa-chevron-right mx-2 text-muted" style="font-size: 10px;"></i>
            <span class="text-dark">${not empty categoryName ? categoryName : 'Tất cả sản phẩm'}</span>
        </div>

        <div class="row g-3">
            <div class="col-lg-2 d-none d-lg-block">
                <div class="sidebar-section shadow-sm">
                    <h3 class="sidebar-title">Khám phá theo danh mục</h3>
                    <ul class="sidebar-list">
                        
                        <%-- Nút "Tất cả" để xem toàn bộ sản phẩm của Danh Mục Cha hiện tại --%>
                        <li>
                            <a href="${root}/category?id=${param.id}" class="${empty param.sub_id ? 'text-tiki fw-bold' : ''}">
                                <i class="fas fa-angle-right me-2 text-muted" style="font-size: 10px;"></i> Tất cả ${categoryName}
                            </a>
                        </li>

                        <%-- Vòng lặp hiển thị các Danh Mục Con --%>
                        <c:choose>
                            <c:when test="${not empty subCategories}">
                                <c:forEach var="subCat" items="${subCategories}">
                                    <li>
                                        <a href="${root}/category?id=${param.id}&sub_id=${subCat.id}" 
                                           class="${param.sub_id == subCat.id ? 'text-tiki fw-bold' : ''}">
                                            ${subCat.name}
                                        </a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            
                            <%-- Trường hợp bạn chưa load được subCategories từ DB, mình để sẵn vài dòng code tĩnh làm mẫu --%>
                            <c:otherwise>
                                <c:if test="${param.id == '18'}">
                                    <li><a href="${root}/category?id=18&sub_id=1" class="${param.sub_id == '1' ? 'text-tiki fw-bold' : ''}">Gọng Kim Loại</a></li>
                                    <li><a href="${root}/category?id=18&sub_id=2" class="${param.sub_id == '2' ? 'text-tiki fw-bold' : ''}">Gọng Nhựa Ultem</a></li>
                                </c:if>
                                <c:if test="${param.id == '19'}">
                                    <li><a href="${root}/category?id=19&sub_id=3" class="${param.sub_id == '3' ? 'text-tiki fw-bold' : ''}">Kính Râm Phân Cực (Polarized)</a></li>
                                    <li><a href="${root}/category?id=19&sub_id=4" class="${param.sub_id == '4' ? 'text-tiki fw-bold' : ''}">Kính Râm Tráng Gương</a></li>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div> <div class="col-lg-10">
                <div class="filter-bar shadow-sm">
                    <h1 class="filter-title">${not empty categoryName ? categoryName : 'Sản phẩm nổi bật'}</h1>
                    
                    <div class="filter-group">
                        <span class="filter-label text-muted">Thương hiệu</span>
                        <a href="#" class="filter-btn active">Tất cả</a>
                        <a href="#" class="filter-btn">RayBan</a>
                        <a href="#" class="filter-btn">Oakley</a>
                        <a href="#" class="filter-btn">Gucci</a>
                        <a href="#" class="filter-btn">Gentle Monster</a>
                    </div>
                </div>

                <div class="row g-3">
                    <c:choose>
                        <%-- TRƯỜNG HỢP CÓ SẢN PHẨM TRONG DANH MỤC --%>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
                                    <div class="card h-100 product-card overflow-hidden">
                                        <a href="${root}/product?id=${product.id}" class="text-decoration-none text-dark">
                                            <img src="https://salt.tikicdn.com/ts/upload/41/28/7d/4713aa0d2855c5c770799f248692f0c5.png" class="badge-chinh-hang" alt="Chính hãng">
                                            
                                            <img src="${not empty product.image ? (root += '/' += product.image) : ('https://images.unsplash.com/photo-1577803645773-f96470509666?w=300&q=80')}" 
                                                 class="card-img-top img-fluid" alt="${product.name}" style="aspect-ratio: 1; object-fit: cover;">
                                            
                                            <div class="card-body p-2">
                                                <div class="mb-1">
                                                    <img src="https://via.placeholder.com/50x15?text=Tiki+Trading" alt="Tiki" height="15">
                                                </div>
                                                
                                                <p class="card-title mb-1" style="font-size: 13px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 38px;">
                                                    ${product.name}
                                                </p>
                                                
                                                <div class="d-flex align-items-center mb-1">
                                                    <span class="text-warning small me-1"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></span>
                                                    <span class="text-muted" style="font-size: 11px;">| Đã bán 120</span>
                                                </div>
                                                
                                                <div class="d-flex align-items-center mt-2 mb-1">
                                                    <span class="price fw-bold text-danger fs-6 me-2">
                                                        <fmt:formatNumber value="${product.salePrice}" pattern="#,###"/> ₫
                                                    </span>
                                                    <c:if test="${product.price gt product.salePrice}">
                                                        <span class="badge bg-light text-dark border">-<fmt:formatNumber value="${(product.price - product.salePrice) / product.price * 100}" maxFractionDigits="0"/>%</span>
                                                    </c:if>
                                                </div>
                                                
                                                <div class="mt-2">
                                                    <img src="https://salt.tikicdn.com/ts/upload/f9/ad/0e/a8a97f5ac7661d637942b42796893662.png" alt="Giao siêu tốc 2h" height="16">
                                                    <span class="text-muted ms-1" style="font-size: 11px;">Giao siêu tốc 2h</span>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <div class="col-12 mt-4">
                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item disabled"><a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a></li>
                                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                                        <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a></li>
                                    </ul>
                                </nav>
                            </div>
                        </c:when>
                        
                        <%-- TRƯỜNG HỢP KHÔNG CÓ SẢN PHẨM NÀO --%>
                        <c:otherwise>
                            <div class="col-12 text-center py-5 bg-white rounded shadow-sm">
                                <img src="https://salt.tikicdn.com/desktop/img/mascot@2x.png" alt="Không tìm thấy sản phẩm" width="150" class="mb-3">
                                <h5>Rất tiếc, danh mục này hiện chưa có sản phẩm nào!</h5>
                                <p class="text-muted">Bạn hãy thử chọn danh mục khác hoặc quay lại sau nhé.</p>
                                <a href="${root}/home" class="btn btn-outline-primary mt-2">Tiếp tục mua sắm</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>