<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - Cửa hàng kính thời trang</title>
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
        .register-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 450px;
            padding: 40px;
        }
        .register-container h2 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; color: #555; font-weight: 500; }
        .form-group input {
            width: 100%; padding: 10px; border: 1px solid #ddd;
            border-radius: 5px; font-size: 14px;
        }
        .form-group input:focus { outline: none; border-color: #667eea; }
        .btn-register {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; border-radius: 5px;
            font-size: 16px; font-weight: bold; cursor: pointer;
        }
        .login-link { text-align: center; margin-top: 20px; }
        .login-link a { color: #667eea; text-decoration: none; }
        .error-msg { color: #c33; font-size: 12px; margin-top: 5px; display: none; }
        .success-msg { background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px; display: none; }
        .password-hint { font-size: 11px; color: #999; margin-top: 3px; }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>📝 Đăng ký tài khoản</h2>
        <div id="successMsg" class="success-msg"></div>
        <div id="errorMsg" class="error-msg"></div>
        
        <form id="registerForm">
            <div class="form-group">
                <label>Tên đăng nhập *</label>
                <input type="text" id="username" required>
                <div class="error-msg" id="usernameError"></div>
            </div>
            <div class="form-group">
                <label>Họ và tên</label>
                <input type="text" id="fullname">
            </div>
            <div class="form-group">
                <label>Email *</label>
                <input type="email" id="email" required>
                <div class="error-msg" id="emailError"></div>
            </div>
            <div class="form-group">
                <label>Mật khẩu *</label>
                <input type="password" id="password" required>
                <div class="password-hint">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt</div>
                <div class="error-msg" id="passwordError"></div>
            </div>
            <div class="form-group">
                <label>Xác nhận mật khẩu *</label>
                <input type="password" id="confirmPassword" required>
                <div class="error-msg" id="confirmError"></div>
            </div>
            <button type="submit" class="btn-register">Đăng ký</button>
        </form>
        
        <div class="login-link">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
    </div>
    
    <script>
        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            clearErrors();
            
            const formData = new URLSearchParams();
            formData.append('username', document.getElementById('username').value);
            formData.append('fullname', document.getElementById('fullname').value);
            formData.append('email', document.getElementById('email').value);
            formData.append('password', document.getElementById('password').value);
            formData.append('confirmPassword', document.getElementById('confirmPassword').value);
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                });
                const data = await response.json();
                
                if (data.success) {
                    document.getElementById('successMsg').textContent = data.message;
                    document.getElementById('successMsg').style.display = 'block';
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }, 2000);
                } else {
                    showError(data.message);
                }
            } catch (error) {
                showError('Có lỗi xảy ra, vui lòng thử lại!');
            }
        });
        
        function showError(msg) {
            if (msg.includes('tên đăng nhập')) {
                document.getElementById('usernameError').textContent = msg;
                document.getElementById('usernameError').style.display = 'block';
            } else if (msg.includes('Email')) {
                document.getElementById('emailError').textContent = msg;
                document.getElementById('emailError').style.display = 'block';
            } else if (msg.includes('Mật khẩu')) {
                document.getElementById('passwordError').textContent = msg;
                document.getElementById('passwordError').style.display = 'block';
            } else {
                document.getElementById('errorMsg').textContent = msg;
                document.getElementById('errorMsg').style.display = 'block';
            }
        }
        
        function clearErrors() {
            document.querySelectorAll('.error-msg').forEach(el => {
                el.textContent = '';
                el.style.display = 'none';
            });
            document.getElementById('successMsg').style.display = 'none';
        }
    </script>
</body>
</html>