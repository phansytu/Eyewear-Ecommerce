<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ - TuKhanhHuy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f5f5f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .contact-wrapper { max-width: 600px; margin: 50px auto; }
        .contact-card { background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); overflow: hidden; }
        .contact-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center; color: white; }
        .contact-header .icon-circle { width: 80px; height: 80px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; font-size: 36px; }
        .contact-header h4 { margin: 0; font-weight: 700; }
        .contact-body { padding: 30px; }
        .contact-info { background: #f8f9fa; border-radius: 10px; padding: 20px; margin-bottom: 20px; text-align: center; }
        .contact-info .hotline { font-size: 28px; font-weight: 700; color: #667eea; }
        .contact-info .time { color: #888; font-size: 14px; }
        .btn-submit { padding: 14px 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; width: 100%; cursor: pointer; transition: all 0.3s; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102,126,234,0.3); }
        .form-control { border-radius: 8px; padding: 12px; border: 1px solid #ddd; }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/includes/header.jsp" />

<div class="contact-wrapper">
    <div class="contact-card">
        <div class="contact-header">
            <div class="icon-circle">
                <i class="fas fa-headset"></i>
            </div>
            <h4>Liên hệ hỗ trợ</h4>
            <c:if test="${not empty orderId}">
                <p class="mb-0 opacity-75">Đơn hàng #${orderId}</p>
            </c:if>
        </div>
        <div class="contact-body">
            <div class="contact-info">
                <i class="fas fa-phone-volume text-primary mb-3" style="font-size: 40px;"></i>
                <p class="mb-2">Hotline hỗ trợ</p>
                <div class="hotline">1900 1234</div>
                <p class="time mt-2">(8:00 - 22:00, cả thứ 7 & CN)</p>
            </div>
            
            <form id="contactForm">
    <input type="hidden" name="orderId" value="${orderId}">
    <div class="mb-3">
        <label class="form-label fw-600">Họ và tên</label>
        <input type="text" name="name" class="form-control" value="${sessionScope.user.full_name}">
    </div>
    <div class="mb-3">
        <label class="form-label fw-600">Email</label>
        <input type="email" name="email" class="form-control" value="${sessionScope.user.email}">
    </div>
    <div class="mb-3">
        <label class="form-label fw-600">Số điện thoại</label>
        <input type="tel" name="phone" class="form-control" value="${sessionScope.user.phone}">
    </div>
    <div class="mb-3">
        <label class="form-label fw-600">Tiêu đề</label>
        <input type="text" name="subject" class="form-control" placeholder="Tiêu đề yêu cầu hỗ trợ">
    </div>
    <div class="mb-3">
        <label class="form-label fw-600">Nội dung cần hỗ trợ <span class="text-danger">*</span></label>
        <textarea name="message" class="form-control" rows="4" placeholder="Mô tả vấn đề của bạn..." required></textarea>
    </div>
    <button type="button" class="btn-submit" onclick="submitContact()">
        <i class="fas fa-paper-plane me-2"></i>Gửi yêu cầu hỗ trợ
    </button>
    <div id="contactMsg" class="mt-3" style="display:none;"></div>
</form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
function submitContact() {
    var message = document.querySelector('[name="message"]').value.trim();
    if (!message) { alert('Vui lòng nhập nội dung!'); return; }
    
    var fd = new URLSearchParams();
    fd.append('name', document.querySelector('[name="name"]').value);
    fd.append('email', document.querySelector('[name="email"]').value);
    fd.append('phone', document.querySelector('[name="phone"]').value);
    fd.append('subject', document.querySelector('[name="subject"]').value);
    fd.append('message', message);
    fd.append('orderId', '${orderId}');
    
    fetch('${pageContext.request.contextPath}/contact', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: fd
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        var msg = document.getElementById('contactMsg');
        msg.style.display = 'block';
        if (data.success) {
            msg.innerHTML = '<div class="alert alert-success">✅ ' + data.message + '</div>';
            document.getElementById('contactForm').reset();
        } else {
            msg.innerHTML = '<div class="alert alert-danger">❌ ' + data.message + '</div>';
        }
    });
}
</script>
</body>
</html>