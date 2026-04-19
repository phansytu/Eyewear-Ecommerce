<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <link rel="stylesheet" href="${root}/css/heared.css">
</head>

<nav class="navbar">
    <div class="logo"><a href="home">KÍNH TH?I TRANG</a></div>
    
    <div class="menu-right">
        <c:if test="${empty sessionScope.user}">
            <a href="login.jsp" class="nav-link">??ng nh?p</a>
            <a href="register.jsp" class="nav-link btn-reg">??ng ký</a>
        </c:if>

        <c:if test="${not empty sessionScope.user}">
            <div class="user-dropdown">
                <button class="dropbtn" onclick="toggleMenu()">
                    ? Chào, ${sessionScope.user.full_name} ?
                </button>
                <div id="myDropdown" class="dropdown-content">
                    <a href="profile">Thông tin cá nhân</a>
                    <a href="my-orders">??n hàng c?a tôi</a>
                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <a href="/jsp/admin/dashboard" style="color: blue;">Trang qu?n tr?</a>
                    </c:if>
                        <c:if test="${sessionScope.user.role == 'user'}">
                        <a href="/jsp/user/dashboard" style="color: blue;">Trang qu?n tr?</a>
                    </c:if>
                    <hr>
                    <a href="logout" class="logout-link">??ng xu?t</a>
                </div>
            </div>
        </c:if>
    </div>
</nav>