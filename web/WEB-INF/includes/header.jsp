<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<link rel="stylesheet" href="css/style.css">

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
            <li><a href="${root}/search?categoryId=18">Gọng kính</a></li>
            <li><a href="${root}/search?categoryId=19">Kính râm</a></li>
            <li><a href="${root}/search?categoryId=20">Kính chống ánh sáng xanh</a></li>
            <li><a href="${root}/search?categoryId=21">Tròng kính</a></li>
            <li><a href="${root}/search?categoryId=22">Kính áp tròng</a></li>
            <li><a href="${root}/search?categoryId=23">Phụ kiện</a></li>
        </ul>
    </div>
</div>