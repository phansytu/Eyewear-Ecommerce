<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Cửa hàng kính thời trang</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 420px;
            padding: 40px;
        }
        h2 { 
            text-align: center; 
            color: #333; 
            margin-bottom: 10px; 
            font-size: 24px;
        }
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
            font-size: 14px;
        }
        .form-group { margin-bottom: 20px; }
        label { 
            display: block; 
            margin-bottom: 8px; 
            color: #555; 
            font-weight: 500;
            font-size: 14px;
        }
        input {
            width: 100%; 
            padding: 14px; 
            border: 1px solid #ddd;
            border-radius: 8px; 
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        button {
            width: 100%; 
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            border: none; 
            border-radius: 8px;
            font-size: 16px; 
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        button:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }
        .message { 
            padding: 12px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
            display: none; 
            font-size: 14px;
        }
        .success { 
            background: #d4edda; 
            color: #155724; 
            border-left: 4px solid #28a745; 
        }
        .error { 
            background: #f8d7da; 
            color: #721c24; 
            border-left: 4px solid #dc3545; 
        }
        .info {
            background: #e7f3ff;
            color: #004085;
            border-left: 4px solid #007bff;
        }
        .back-link { 
            text-align: center; 
            margin-top: 20px; 
        }
        .back-link a { 
            color: #667eea; 
            text-decoration: none; 
            font-size: 14px;
            transition: color 0.2s;
        }
        .back-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        .spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid white;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔐 Quên mật khẩu</h2>
        <p class="subtitle">Nhập tên đăng nhập và email để nhận mã OTP</p>
        
        <div id="message" class="message"></div>
        
        <form id="forgotForm">
            <div class="form-group">
                <label for="username">👤 Tên đăng nhập</label>
                <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required autofocus>
            </div>
            
            <div class="form-group">
                <label for="email">📧 Email đăng ký</label>
                <input type="email" id="email" name="email" placeholder="Nhập email của bạn" required>
            </div>
            
            <button type="submit" id="submitBtn">
                <span id="btnText">Gửi mã OTP</span>
                <span id="btnSpinner" class="spinner" style="display: none;"></span>
            </button>
        </form>
        
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/login">← Quay lại đăng nhập</a>
        </div>
    </div>
    
    <script>
        const form = document.getElementById('forgotForm');
        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');
        const btnSpinner = document.getElementById('btnSpinner');
        const messageDiv = document.getElementById('message');
        
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            
            // Validate
            if (!username) {
                showMessage('Vui lòng nhập tên đăng nhập!', 'error');
                document.getElementById('username').focus();
                return;
            }
            
            if (!email) {
                showMessage('Vui lòng nhập email!', 'error');
                document.getElementById('email').focus();
                return;
            }
            
            if (!isValidEmail(email)) {
                showMessage('Email không đúng định dạng!', 'error');
                document.getElementById('email').focus();
                return;
            }
            
            // Show loading
            setLoading(true);
            hideMessage();
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/forgot-password', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ username, email })
                });
                
                const data = await response.json();
                
                if (data.success) {
                    showMessage(data.message, 'success');
                    form.reset();
                    
                    // Chuyển sang trang xác thực OTP sau 2 giây
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/verify-otp';
                    }, 2000);
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra, vui lòng thử lại!', 'error');
            } finally {
                setLoading(false);
            }
        });
        
        function isValidEmail(email) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        }
        
        function setLoading(loading) {
            submitBtn.disabled = loading;
            btnText.style.display = loading ? 'none' : 'inline';
            btnSpinner.style.display = loading ? 'inline-block' : 'none';
        }
        
        function showMessage(msg, type) {
            messageDiv.textContent = msg;
            messageDiv.className = `message ${type}`;
            messageDiv.style.display = 'block';
        }
        
        function hideMessage() {
            messageDiv.style.display = 'none';
        }
    </script>
</body>
</html>