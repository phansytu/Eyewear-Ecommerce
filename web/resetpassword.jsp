<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Kiểm tra session
    Integer userId = (Integer) session.getAttribute("resetUserId");
    Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
    if (userId == null || otpVerified == null || !otpVerified) {
        response.sendRedirect("forgot-password");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Cửa hàng kính thời trang</title>
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
        .password-wrapper {
            position: relative;
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
        .toggle-password {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            font-size: 18px;
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
        .hint { 
            font-size: 12px; 
            color: #888; 
            margin-top: 6px; 
        }
        .password-strength {
            height: 4px;
            background: #eee;
            border-radius: 2px;
            margin-top: 8px;
            overflow: hidden;
        }
        .strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.3s, background 0.3s;
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
        <h2>🔄 Đặt lại mật khẩu</h2>
        <p class="subtitle">Tạo mật khẩu mới cho tài khoản của bạn</p>
        
        <div id="message" class="message"></div>
        
        <form id="resetForm">
            <div class="form-group">
                <label for="newPassword">🔒 Mật khẩu mới</label>
                <div class="password-wrapper">
                    <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required autofocus>
                    <span class="toggle-password" onclick="togglePassword('newPassword')">👁️</span>
                </div>
                <div class="password-strength">
                    <div id="strengthBar" class="strength-bar"></div>
                </div>
                <div class="hint" id="strengthText">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt</div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">✅ Xác nhận mật khẩu</label>
                <div class="password-wrapper">
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                    <span class="toggle-password" onclick="togglePassword('confirmPassword')">👁️</span>
                </div>
                <div id="matchHint" class="hint"></div>
            </div>
            
            <button type="submit" id="submitBtn">
                <span id="btnText">Đặt lại mật khẩu</span>
                <span id="btnSpinner" class="spinner" style="display: none;"></span>
            </button>
        </form>
    </div>
    
    <script>
        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const matchHint = document.getElementById('matchHint');
        const messageDiv = document.getElementById('message');
        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');
        const btnSpinner = document.getElementById('btnSpinner');
        
        // Kiểm tra độ mạnh mật khẩu
        newPasswordInput.addEventListener('input', checkPasswordStrength);
        confirmPasswordInput.addEventListener('input', checkPasswordMatch);
        
        function checkPasswordStrength() {
            const password = newPasswordInput.value;
            let strength = 0;
            
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[@#$%^&+=!]/.test(password)) strength++;
            
            const percent = (strength / 5) * 100;
            strengthBar.style.width = percent + '%';
            
            if (strength <= 2) {
                strengthBar.style.background = '#dc3545';
                strengthText.innerHTML = '⚠️ Mật khẩu yếu. ' + getMissingRequirements(password);
            } else if (strength <= 3) {
                strengthBar.style.background = '#ffc107';
                strengthText.innerHTML = '📊 Mật khẩu trung bình. ' + getMissingRequirements(password);
            } else if (strength <= 4) {
                strengthBar.style.background = '#17a2b8';
                strengthText.innerHTML = '👍 Mật khẩu khá tốt!';
            } else {
                strengthBar.style.background = '#28a745';
                strengthText.innerHTML = '💪 Mật khẩu mạnh!';
            }
        }
        
        function getMissingRequirements(password) {
            const missing = [];
            if (password.length < 8) missing.push('8 ký tự');
            if (!/[a-z]/.test(password)) missing.push('chữ thường');
            if (!/[A-Z]/.test(password)) missing.push('chữ hoa');
            if (!/[0-9]/.test(password)) missing.push('số');
            if (!/[@#$%^&+=!]/.test(password)) missing.push('ký tự đặc biệt');
            return missing.length > 0 ? 'Thiếu: ' + missing.join(', ') : '';
        }
        
        function checkPasswordMatch() {
            if (confirmPasswordInput.value === '') {
                matchHint.innerHTML = '';
                return;
            }
            
            if (newPasswordInput.value === confirmPasswordInput.value) {
                matchHint.innerHTML = '✅ Mật khẩu khớp';
                matchHint.style.color = '#28a745';
            } else {
                matchHint.innerHTML = '❌ Mật khẩu không khớp';
                matchHint.style.color = '#dc3545';
            }
        }
        
        function togglePassword(fieldId) {
            const input = document.getElementById(fieldId);
            input.type = input.type === 'password' ? 'text' : 'password';
        }
        
        // Submit form
        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const newPassword = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            
            // Validate
            if (!isValidPassword(newPassword)) {
                showMessage('Mật khẩu không đủ mạnh! Vui lòng kiểm tra yêu cầu.', 'error');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showMessage('Mật khẩu xác nhận không khớp!', 'error');
                return;
            }
            
            setLoading(true);
            hideMessage();
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/reset-password', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ newPassword, confirmPassword })
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
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra, vui lòng thử lại!', 'error');
            } finally {
                setLoading(false);
            }
        });
        
        function isValidPassword(password) {
            const pattern = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\S+$).{8,}$/;
            return pattern.test(password);
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