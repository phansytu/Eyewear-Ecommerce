<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<%-- 
    Giả sử từ Servlet bạn truyền sang các biến:
    - categoryName: Tên danh mục (VD: "Kính Râm Nam", "Gọng Kính Nữ"...)
    - subCategories: Danh sách các danh mục con
    - products: Danh sách sản phẩm thuộc danh mục này
--%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty categoryName ? categoryName : 'Danh mục sản phẩm'} - Tiki x Kính Mắt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f5f5fa; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; }
        .text-tiki { color: #1A94FF; }
        .bg-tiki { background-color: #1A94FF; }
        
        /* Header (Giữ nguyên như trang chủ) */
        .tiki-header { background-color: #fff; border-bottom: 1px solid #e1e1e1; padding-bottom: 8px;}
        .top-promo { background-color: #f2fdf6; color: #00ab56; font-size: 13px; font-weight: 500; }
        .logo-text { color: #1A94FF; font-weight: 800; font-size: 32px; letter-spacing: -1px; line-height: 1; }
        .logo-sub { color: #1A94FF; font-size: 12px; font-weight: 600; }
        .search-box { border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        .search-box input { border: none; box-shadow: none !important; font-size: 14px; }
        .search-btn { border-left: 1px solid #ddd; background: transparent; color: #1A94FF; font-weight: 500; border-radius: 0; width: 100px; }
        .search-tags a { color: #808089; font-size: 12px; text-decoration: none; margin-right: 10px; }
        .header-action { color: #808089; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 6px; padding: 8px; border-radius: 8px;}
        .commitment-bar { font-size: 12px; color: #808089; border-top: 1px solid #f0f0f0; padding-top: 8px; margin-top: 8px; }
        
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
        .filter-btn:hover { border-color: #1A94FF; color: #1A94FF; }
        .filter-btn.active { border-color: #1A94FF; color: #1A94FF; background: #f0f8ff; }
        
        /* Checkbox & Sort */
        .filter-options { display: flex; align-items: center; justify-content: space-between; border-top: 1px solid #eee; padding-top: 12px; }
        .checkbox-group { display: flex; gap: 20px; font-size: 13px; }
        .sort-select { border: 1px solid #ddd; border-radius: 4px; padding: 6px 12px; font-size: 13px; color: #38383d; outline: none; }
        
        /* Product Card */
        .product-card { border: 1px solid transparent; border-radius: 8px; background: #fff; transition: box-shadow 0.2s; position: relative; }
        .product-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-color: #ddd;}
        .badge-tiki-now { max-width: 60px; margin-bottom: 4px; }
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
                        <a href="${root}/category?type=kinh-ram-nam">kính râm nam</a>
                        <a href="${root}/category?type=gong-kinh-nu">gọng kính nữ</a>
                        <a href="${root}/category?type=kinh-chong-anh-sang-xanh">kính chống ánh sáng xanh</a>
                        <a href="${root}/category?type=gong-titanium">gọng titanium</a>
                        <a href="${root}/category?type=kinh-rayban">kính RayBan</a>
                        <a href="${root}/category?type=phu-kien-kinh">phụ kiện kính</a>
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
                        <li><a href="#">Kính râm phi công (Aviator)</a></li>
                        <li><a href="#">Kính gọng vuông</a></li>
                        <li><a href="#">Kính gọng tròn</a></li>
                        <li><a href="#">Kính thể thao ôm sát</a></li>
                        <li><a href="#">Tròng kính râm cận</a></li>
                    </ul>
                </div>
                
                <div class="sidebar-section shadow-sm text-center p-0 overflow-hidden">
                    <span class="badge bg-light text-secondary position-absolute m-2 border">Tài trợ</span>
                    <a href="#">
                        <img src="https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&q=80" alt="Banner" class="img-fluid w-100">
                        <div class="p-2 text-start">
                            <img src="https://via.placeholder.com/60x20?text=TIKI+Trading" alt="Tiki Trading" class="mb-2">
                            <p class="small fw-bold mb-0">Bộ Sưu Tập Kính Râm RayBan Chính Hãng</p>
                            <span class="text-warning small"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></span>
                        </div>
                    </a>
                </div>
            </div>

            <div class="col-lg-10">
                <div class="filter-bar shadow-sm">
                    <h1 class="filter-title">${not empty categoryName ? categoryName : 'Tất cả sản phẩm'}</h1>
                    
                    <div class="filter-group">
                        <span class="filter-label text-muted">Thương hiệu</span>
                        <a href="#" class="filter-btn active">Tất cả</a>
                        <a href="#" class="filter-btn">RayBan</a>
                        <a href="#" class="filter-btn">Oakley</a>
                        <a href="#" class="filter-btn">Gucci</a>
                        <a href="#" class="filter-btn">Gentle Monster</a>
                        <a href="#" class="filter-btn text-muted"><i class="fas fa-chevron-down"></i></a>
                    </div>
                    
                    <div class="filter-group">
                        <span class="filter-label text-muted">Chất liệu</span>
                        <a href="#" class="filter-btn">Titanium</a>
                        <a href="#" class="filter-btn">Nhựa Ultem</a>
                        <a href="#" class="filter-btn">Hợp kim</a>
                        <a href="#" class="filter-btn">Acetate</a>
                    </div>

                    <div class="filter-options">
                        <div class="checkbox-group">
                            <label class="d-flex align-items-center gap-2 cursor-pointer">
                                <input type="checkbox"> <img src="https://salt.tikicdn.com/ts/upload/f9/ad/0e/a8a97f5ac7661d637942b42796893662.png" height="14" alt="now"> Giao siêu tốc 2H
                            </label>
                            <label class="d-flex align-items-center gap-2 cursor-pointer">
                                <input type="checkbox"> <span class="text-success fw-bold" style="font-style: italic;">FREESHIP XTRA</span>
                            </label>
                            <label class="d-flex align-items-center gap-2 cursor-pointer">
                                <input type="checkbox"> <span class="text-warning"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></span> từ 4 sao
                            </label>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-muted" style="font-size: 13px;">Sắp xếp</span>
                            <select class="sort-select">
                                <option>Phổ biến</option>
                                <option>Bán chạy</option>
                                <option>Hàng mới</option>
                                <option>Giá thấp đến cao</option>
                                <option>Giá cao đến thấp</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
                                    <div class="card h-100 product-card overflow-hidden">
                                        <a href="${root}/product?id=${product.id}" class="text-decoration-none text-dark">
                                            <img src="https://salt.tikicdn.com/ts/upload/41/28/7d/4713aa0d2855c5c770799f248692f0c5.png" class="badge-chinh-hang" alt="Chính hãng">
                                            
                                            <img src="${not empty product.image ? (root += product.image) : ('https://images.unsplash.com/photo-1577803645773-f96470509666?w=300&q=80')}" 
                                                 class="card-img-top img-fluid" alt="${product.name}" style="aspect-ratio: 1; object-fit: cover;">
                                            
                                            <div class="card-body p-2">
                                                <div class="mb-1">
                                                    <img src="https://via.placeholder.com/50x15?text=Tiki+Trading" alt="Tiki" height="15">
                                                </div>
                                                
                                                <p class="card-title mb-1" style="font-size: 13px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
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
                                                        <span class="badge bg-light text-dark border">-20%</span>
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
                        </c:when>
                        <c:otherwise>
                            <c:forEach begin="1" end="6" varStatus="loop">
                                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
                                    <div class="card h-100 product-card overflow-hidden">
                                        <a href="#" class="text-decoration-none text-dark">
                                            <img src="https://salt.tikicdn.com/ts/upload/41/28/7d/4713aa0d2855c5c770799f248692f0c5.png" class="badge-chinh-hang" alt="Chính hãng">
                                            <img src="https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=300&q=80" class="card-img-top img-fluid" style="aspect-ratio: 1; object-fit: cover;">
                                            <div class="card-body p-2">
                                                <div class="mb-1"><img src="https://via.placeholder.com/50x15?text=KinhMat" height="15"></div>
                                                <p class="card-title mb-1" style="font-size: 13px;">Kính Râm Nam Phân Cực Chống Tia UV - Mẫu ${loop.index}</p>
                                                <div class="d-flex align-items-center mb-1">
                                                    <span class="text-warning small me-1"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></span>
                                                    <span class="text-muted" style="font-size: 11px;">| Đã bán 50+</span>
                                                </div>
                                                <div class="d-flex align-items-center mt-2 mb-1">
                                                    <span class="price fw-bold text-danger fs-6 me-2">350.000 ₫</span>
                                                    <span class="badge bg-light text-dark border">-30%</span>
                                                </div>
                                                <div class="mt-2">
                                                    <img src="https://salt.tikicdn.com/ts/upload/f9/ad/0e/a8a97f5ac7661d637942b42796893662.png" height="16">
                                                    <span class="text-muted ms-1" style="font-size: 11px;">Giao siêu tốc 2h</span>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled"><a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>