<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đơn Mua | Shopee Clone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f5f5f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .top-navbar { background: white; padding: 15px 0; border-bottom: 1px solid rgba(0,0,0,.05); margin-bottom: 30px; }
        .top-navbar a { text-decoration: none; color: #ee4d2d; font-size: 20px; font-weight: 500; }
        
        /* Sidebar (Giống Profile) */
        .sidebar-item { padding: 8px 0; cursor: pointer; color: rgba(0,0,0,.65); text-decoration: none; display: block; font-weight: 500; transition: 0.2s;}
        .sidebar-item:hover, .sidebar-item.active { color: #ee4d2d; }
        .sidebar-icon { width: 24px; text-align: center; margin-right: 8px; color: #1a9cb7;}
        
        /* Order Tabs */
        .order-tabs { background: white; display: flex; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); border-radius: 2px; margin-bottom: 12px;}
        .order-tab-item { flex: 1; text-align: center; padding: 15px 0; cursor: pointer; color: rgba(0,0,0,.8); text-decoration: none; border-bottom: 2px solid transparent;}
        .order-tab-item:hover { color: #ee4d2d; }
        .order-tab-item.active { color: #ee4d2d; border-bottom: 2px solid #ee4d2d; }
        
        /* Order Card */
        .order-card { background: white; border-radius: 2px; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); margin-bottom: 15px; padding: 24px; }
        .shop-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #efefef; padding-bottom: 12px; margin-bottom: 12px;}
        .shop-name { font-weight: 600; color: #333; text-decoration: none; display: flex; align-items: center;}
        .order-status { color: #ee4d2d; text-transform: uppercase; font-size: 14px;}
        .product-item { display: flex; align-items: center; padding: 10px 0;}
        .product-img { width: 80px; height: 80px; object-fit: cover; border: 1px solid #e1e1e1; margin-right: 15px;}
        .product-info { flex: 1; }
        .product-name { font-size: 16px; color: rgba(0,0,0,.87); margin-bottom: 5px; }
        .product-variant { font-size: 14px; color: rgba(0,0,0,.54); }
        .product-price { text-align: right; }
        .original-price { text-decoration: line-through; color: rgba(0,0,0,.26); font-size: 14px; margin-right: 5px;}
        .current-price { color: #ee4d2d; font-size: 16px;}
        
        /* Order Footer */
        .order-footer { border-top: 1px solid #efefef; padding-top: 20px; margin-top: 10px; display: flex; flex-direction: column; align-items: flex-end;}
        .total-amount-section { font-size: 14px; color: rgba(0,0,0,.8); margin-bottom: 15px;}
        .total-price { color: #ee4d2d; font-size: 24px; font-weight: 500; margin-left: 10px;}
        .btn-buy-again { background-color: #ee4d2d; color: white; border: none; padding: 10px 30px; border-radius: 2px; text-decoration: none;}
        .btn-buy-again:hover { background-color: #d73211; color: white;}
        .btn-contact { background-color: white; border: 1px solid rgba(0,0,0,.09); color: rgba(0,0,0,.8); padding: 10px 30px; border-radius: 2px; text-decoration: none; margin-right: 10px;}
        .btn-contact:hover { background: rgba(0,0,0,.02); color: rgba(0,0,0,.8);}
    </style>
</head>
<body>
    <div class="top-navbar shadow-sm">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="home.jsp"><i class="fa-solid fa-bag-shopping me-2"></i>Shopee Clone</a>
            <a href="home.jsp" style="font-size: 15px; color: #333;"><i class="fa-solid fa-house me-1"></i> Về Trang chủ</a>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row">
            <div class="col-md-2">
                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                    <img src="${not empty sessionScope.user.avatar ? sessionScope.user.avatar : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'}" 
                         class="rounded-circle me-2" width="50" height="50" style="object-fit: cover; border: 1px solid #efefef;">
                    <div>
                        <div class="fw-bold text-truncate" style="max-width: 100px;">${sessionScope.user.username}</div>
                        <div class="text-muted" style="font-size: 13px;"><i class="fa-solid fa-pen text-secondary me-1"></i>Sửa hồ sơ</div>
                    </div>
                </div>
                <div class="list-group list-group-flush">
                    <a href="profile" class="sidebar-item"><i class="fa-regular fa-user sidebar-icon" style="color: #0b5edd;"></i> Tài khoản của tôi</a>
                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <a href="jsp/admin/dashboard.jsp" class="sidebar-item"><i class="fa-solid fa-gauge sidebar-icon" style="color: #ee4d2d;"></i> Quản trị hệ thống</a>
                    </c:if>
                    <a href="orders" class="sidebar-item active"><i class="fa-solid fa-clipboard-list sidebar-icon" style="color: #ee4d2d;"></i> Đơn mua</a>
                    <a href="logout" class="sidebar-item mt-3"><i class="fa-solid fa-right-from-bracket sidebar-icon" style="color: gray;"></i> Đăng xuất</a>
                </div>
            </div>

            <div class="col-md-10">
                <div class="order-tabs">
                    <a href="orders?type=all" class="order-tab-item ${activeTab == 'all' ? 'active' : ''}">Tất cả</a>
                    <a href="orders?type=wait_pay" class="order-tab-item ${activeTab == 'wait_pay' ? 'active' : ''}">Chờ thanh toán</a>
                    <a href="orders?type=shipping" class="order-tab-item ${activeTab == 'shipping' ? 'active' : ''}">Vận chuyển</a>
                    <a href="orders?type=delivering" class="order-tab-item ${activeTab == 'delivering' ? 'active' : ''}">Đang giao</a>
                    <a href="orders?type=completed" class="order-tab-item ${activeTab == 'completed' ? 'active' : ''}">Hoàn thành</a>
                    <a href="orders?type=cancelled" class="order-tab-item ${activeTab == 'cancelled' ? 'active' : ''}">Đã hủy</a>
                </div>

                <div class="order-card">
                    <div class="shop-header">
                        <a href="#" class="shop-name">
                            <span class="badge bg-danger me-2">Yêu thích</span>
                            ${mockShopName} <i class="fa-solid fa-message ms-2 text-primary" style="font-size: 14px;"></i>
                        </a>
                        <div class="order-status"><i class="fa-solid fa-truck-fast me-2"></i>GIAO HÀNG THÀNH CÔNG</div>
                    </div>
                    
                    <div class="product-item">
                        <img src="https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lexx76euh7yvd7" class="product-img">
                        <div class="product-info">
                            <div class="product-name">Kính Mát Thời Trang Nam Nữ Chống Tia UV400 Khung Vuông Cao Cấp</div>
                            <div class="product-variant">Phân loại hàng: Gọng Đen, Mắt Đen</div>
                            <div class="mt-1">x1</div>
                        </div>
                        <div class="product-price">
                            <span class="original-price">₫150.000</span>
                            <span class="current-price">₫89.000</span>
                        </div>
                    </div>
                    
                    <div class="order-footer">
                        <div class="total-amount-section">
                            Thành tiền: <span class="total-price">₫89.000</span>
                        </div>
                        <div class="d-flex">
                            <a href="#" class="btn-contact">Liên hệ Người bán</a>
                            <a href="#" class="btn-buy-again">Mua lại</a>
                        </div>
                    </div>
                </div>

                <div class="order-card">
                    <div class="shop-header">
                        <a href="#" class="shop-name">
                            <span class="badge bg-danger me-2">Yêu thích</span>
                            ${mockShopName} <i class="fa-solid fa-message ms-2 text-primary" style="font-size: 14px;"></i>
                        </a>
                        <div class="order-status text-secondary">ĐÃ HỦY</div>
                    </div>
                    
                    <div class="product-item">
                        <img src="https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lf7o1q1m15cr7b" class="product-img">
                        <div class="product-info">
                            <div class="product-name">Kính Giả Cận Thời Trang Gọng Tròn Kiểu Dáng Hàn Quốc</div>
                            <div class="product-variant">Phân loại hàng: Gọng Trong Suốt</div>
                            <div class="mt-1">x2</div>
                        </div>
                        <div class="product-price">
                            <span class="original-price">₫100.000</span>
                            <span class="current-price">₫45.000</span>
                        </div>
                    </div>
                    
                    <div class="order-footer">
                        <div class="total-amount-section">
                            Thành tiền: <span class="total-price">₫90.000</span>
                        </div>
                        <div class="d-flex">
                            <a href="#" class="btn-buy-again">Mua lại</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>