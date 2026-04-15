<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu - Cửa hàng kính thời trang</title>
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
        .hint { font-size: 11px; color: #999; margin-top: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔄 Đặt lại mật khẩu</h2>
        <div id="message" class="message"></div>
        <form id="resetForm">
            <input type="hidden" id="token" value="${param.token}">
            <div class="form-group">
                <label>Mật khẩu mới:</label>
                <input type="password" id="newPassword" required>
                <div class="hint">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt</div>
            </div>
            <div class="form-group">
                <label>Xác nhận mật khẩu:</label>
                <input type="password" id="confirmPassword" required>
            </div>
            <button type="submit">Đặt lại mật khẩu</button>
        </form>
    </div>
    
    <script>
        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const token = document.getElementById('token').value;
            
            if (newPassword !== confirmPassword) {
                showMessage('Mật khẩu xác nhận không khớp!', 'error');
                return;
            }
            
            const formData = new URLSearchParams();
            formData.append('token', token);
            formData.append('newPassword', newPassword);
            formData.append('confirmPassword', confirmPassword);
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/resetpassword', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                });
                const data = await response.json();
                
                if (data.success) {
                    showMessage(data.message, 'success');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }, 2000);
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                showMessage('Có lỗi xảy ra, vui lòng thử lại!', 'error');
            }
        });
        
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