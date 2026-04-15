<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - ShopeeVN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body class="bg-gradient">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8 text-center py-5 my-5">
                <!-- Error Icon -->
                <div class="error-icon mb-4">
                    <i class="fas fa-exclamation-triangle fa-5x text-warning"></i>
                </div>
                
                <!-- Error Title -->
                <h1 class="display-1 fw-bold text-white mb-3">${pageContext.errorData.statusCode}</h1>
                <h2 class="h3 text-white-50 mb-4">${pageContext.exception.message}</h2>
                
                <!-- Error Message -->
                <c:choose>
                    <c:when test="${pageContext.errorData.statusCode == 404}">
                        <p class="lead text-white-50 mb-5">Trang bạn tìm không tồn tại!</p>
                    </c:when>
                    <c:when test="${pageContext.errorData.statusCode == 500}">
                        <p class="lead text-white-50 mb-5">Có lỗi xảy ra. Vui lòng thử lại!</p>
                    </c:when>
                    <c:otherwise>
                        <p class="lead text-white-50 mb-5">Đã xảy ra lỗi không mong muốn!</p>
                    </c:otherwise>
                </c:choose>
                
                <!-- Action Buttons -->
                <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-danger btn-lg px-4">
                        <i class="fas fa-home me-2"></i>Trang chủ
                    </a>
                    <a href="javascript:history.back()" class="btn btn-outline-light btn-lg px-4">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
                
                <!-- Debug Info (Development only) -->
                <c:if test="${pageContext.request.getParameter('debug') != null}">
                    <details class="mt-5 text-white-50">
                        <summary class="mb-2 cursor-pointer">Chi tiết lỗi (Dev)</summary>
                        <pre class="bg-dark p-3 rounded text-left small overflow-auto" style="max-height: 300px;">
${pageContext.exception}
                        </pre>
                    </details>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>