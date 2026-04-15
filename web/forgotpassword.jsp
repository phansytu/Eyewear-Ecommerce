<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - Cửa hàng kính thời trang</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 400px;
            padding: 40px;
        }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; color: #555; }
        input {
            width: 100%; padding: 12px; border: 1px solid #ddd;
            border-radius: 5px; font-size: 16px;
        }
        button {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; border-radius: 5px;
            font-size: 16px; cursor: pointer;
        }
        .message { padding: 10px; border-radius: 5px; margin-bottom: 20px; display: none; }
        .success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .error { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        .back-link { text-align: center; margin-top: 20px; }
        .back-link a { color: #667eea; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔑 Quên mật khẩu</h2>
        <div id="message" class="message"></div>
        <div class="form-group">
            <label>Email đăng ký:</label>
            <input type="email" id="email" placeholder="Nhập email của bạn">
        </div>
        <button onclick="sendResetLink()">Gửi link đặt lại mật khẩu</button>
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/login">← Quay lại đăng nhập</a>
        </div>
    </div>
    
    <script>
        async function sendResetLink() {
            const email = document.getElementById('email').value;
            if (!email) {
                showMessage('Vui lòng nhập email!', 'error');
                return;
            }
            
            const messageDiv = document.getElementById('message');
            messageDiv.style.display = 'block';
            messageDiv.textContent = 'Đang gửi...';
            messageDiv.className = 'message';
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/forgot-password', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ email: email })
                });
                const data = await response.json();
                
                if (data.success) {
                    showMessage(data.message, 'success');
                    document.getElementById('email').value = '';
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                showMessage('Có lỗi xảy ra, vui lòng thử lại!', 'error');
            }
        }
        
        function showMessage(msg, type) {
            const messageDiv = document.getElementById('message');
            messageDiv.textContent = msg;
            messageDiv.className = `message ${type}`;
            messageDiv.style.display = 'block';
            setTimeout(() => {
                messageDiv.style.display = 'none';
            }, 5000);
        }
    </script>
</body>
</html>