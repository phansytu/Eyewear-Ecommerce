<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Cửa hàng kính thời trang</title>
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
        .login-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 400px;
            padding: 40px;
        }
        .login-container h2 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 500; }
        .form-group input {
            width: 100%; padding: 12px; border: 1px solid #ddd;
            border-radius: 5px; font-size: 16px;
        }
        .form-group input:focus { outline: none; border-color: #667eea; }
        .btn-login {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; border-radius: 5px;
            font-size: 16px; font-weight: bold; cursor: pointer;
        }
        .btn-login:hover { transform: translateY(-2px); }
        .error-message {
            background: #fee; color: #c33; padding: 10px;
            border-radius: 5px; margin-bottom: 20px;
            border-left: 4px solid #c33;
        }
        .register-link, .forgot-link {
            text-align: center; margin-top: 15px;
        }
        .register-link a, .forgot-link a { color: #667eea; text-decoration: none; }
        .register-link a:hover, .forgot-link a:hover { text-decoration: underline; }
        
        /* Modal styles */
        .modal {
            display: none; position: fixed; z-index: 1000; left: 0; top: 0;
            width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: white; margin: 15% auto; padding: 30px;
            border-radius: 10px; width: 400px; position: relative;
        }
        .close { position: absolute; right: 20px; top: 10px; font-size: 28px; cursor: pointer; }
        .otp-input { text-align: center; font-size: 24px; letter-spacing: 10px; }
        .loading { display: none; text-align: center; margin-top: 10px; color: #667eea; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>🔐 Đăng nhập</h2>
        <div id="errorMsg" class="error-message" style="display: none;"></div>
        
        <form id="loginForm">
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input type="text" id="username" name="username" required placeholder="Nhập tên đăng nhập">
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
            </div>
            <button type="submit" class="btn-login">Đăng nhập</button>
        </form>
        
        <div class="forgot-link">
            <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
        </div>
        <div class="register-link">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </div>
    </div>
    
    <!-- Modal Unlock Account -->
    <div id="unlockModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>🔓 Mở khóa tài khoản</h3>
            <p>Tài khoản của bạn đã bị khóa do đăng nhập sai quá 5 lần.</p>
            <div id="step1">
                <div class="form-group">
                    <label>Email đăng ký:</label>
                    <input type="email" id="unlockEmail" placeholder="Nhập email đăng ký">
                </div>
                <button onclick="sendOTP()" class="btn-login">Gửi mã OTP</button>
            </div>
            <div id="step2" style="display: none;">
                <div class="form-group">
                    <label>Mã OTP:</label>
                    <input type="text" id="otpCode" class="otp-input" maxlength="6" placeholder="______">
                </div>
                <button onclick="verifyOTP()" class="btn-login">Xác nhận mở khóa</button>
            </div>
            <div id="loading" class="loading">Đang xử lý...</div>
        </div>
    </div>
    
    <script>
    let currentUserId = null;
    const modal = document.getElementById('unlockModal');
    const errorDiv = document.getElementById('errorMsg');
    
    document.getElementById("loginForm").addEventListener("submit", function(event) {
        event.preventDefault(); // Ngăn form reload lại trang
        hideError();

        const formData = new URLSearchParams(new FormData(this));
        const btn = document.querySelector(".btn-login");
        const originalText = btn.innerHTML;
        
        // Đổi trạng thái nút thành loading
        btn.innerHTML = 'Đang xử lý...';
        btn.disabled = true;

        fetch('${pageContext.request.contextPath}/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest' 
            },
            body: formData.toString()
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Thành công: Chuyển hướng theo JSON trả về
                window.location.href = data.redirect;
            } else {
                // Thất bại
                if (data.locked) {
                    showError(data.message);
                    modal.style.display = 'block';
                } else {
                    showError(data.message);
                }
                // Trả lại trạng thái ban đầu cho nút bấm
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showError('Lỗi kết nối tới máy chủ!');
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    });
    
    // ... (Giữ nguyên các hàm sendOTP, verifyOTP, showError, hideError, showLoading, hideLoading của bạn ở đây) ...

    function showError(msg) {
        errorDiv.textContent = msg;
        errorDiv.style.display = 'block';
        setTimeout(() => { errorDiv.style.display = 'none'; }, 5000);
    }
    function hideError() { errorDiv.style.display = 'none'; }
    function showLoading() { document.getElementById('loading').style.display = 'block'; }
    function hideLoading() { document.getElementById('loading').style.display = 'none'; }
    
    document.querySelector('.close').onclick = () => { modal.style.display = 'none'; };
    window.onclick = (e) => { if (e.target == modal) modal.style.display = 'none'; };
</script>
</body>
</html>