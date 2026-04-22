<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Kiểm tra session, nếu không có thì redirect về forgot-password
    Integer userId = (Integer) session.getAttribute("resetUserId");
    if (userId == null) {
        response.sendRedirect("forgot-password");
        return;
    }
    String maskedEmail = (String) request.getAttribute("maskedEmail");
    if (maskedEmail == null) maskedEmail = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP - Cửa hàng kính thời trang</title>
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
        .email-info {
            background: #f0f4ff;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 25px;
            text-align: center;
            font-size: 14px;
            color: #555;
        }
        .email-info strong {
            color: #667eea;
        }
        .otp-container {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 25px;
        }
        .otp-input {
            width: 50px;
            height: 60px;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            border: 2px solid #ddd;
            border-radius: 10px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .otp-input:focus {
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
        .resend-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }
        .resend-link a {
            color: #667eea;
            text-decoration: none;
            cursor: pointer;
        }
        .resend-link a:hover {
            text-decoration: underline;
        }
        .resend-link .disabled {
            color: #999;
            pointer-events: none;
        }
        .timer {
            font-weight: bold;
            color: #764ba2;
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
        @media (max-width: 480px) {
            .otp-input {
                width: 40px;
                height: 50px;
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔢 Xác thực OTP</h2>
        <p class="subtitle">Nhập mã OTP 6 số đã được gửi đến email</p>
        
        <div class="email-info">
            📧 Mã OTP đã được gửi đến <strong><%= maskedEmail %></strong>
        </div>
        
        <div id="message" class="message"></div>
        
        <form id="otpForm">
            <div class="otp-container" id="otpContainer">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="off">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="off">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="off">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="off">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="off">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="off">
            </div>
            <input type="hidden" id="fullOtp" name="otp">
            
            <button type="submit" id="submitBtn">
                <span id="btnText">Xác thực</span>
                <span id="btnSpinner" class="spinner" style="display: none;"></span>
            </button>
        </form>
        
        <div class="resend-link">
            <span id="resendText">Chưa nhận được mã? </span>
            <a id="resendLink" onclick="resendOTP()">Gửi lại mã</a>
            <span id="timerDisplay" class="timer"></span>
        </div>
    </div>
    
    <script>
        const inputs = document.querySelectorAll('.otp-input');
        const fullOtpInput = document.getElementById('fullOtp');
        const messageDiv = document.getElementById('message');
        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');
        const btnSpinner = document.getElementById('btnSpinner');
        const resendLink = document.getElementById('resendLink');
        const timerDisplay = document.getElementById('timerDisplay');
        
        let countdown = 60;
        let timerInterval;
        
        // Auto focus và xử lý input OTP
        inputs.forEach((input, index) => {
            input.addEventListener('input', (e) => {
                const value = e.target.value;
                if (value && index < inputs.length - 1) {
                    inputs[index + 1].focus();
                }
                updateFullOtp();
            });
            
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !e.target.value && index > 0) {
                    inputs[index - 1].focus();
                }
            });
            
            input.addEventListener('paste', (e) => {
                e.preventDefault();
                const pasteData = e.clipboardData.getData('text').trim();
                if (/^\d{6}$/.test(pasteData)) {
                    pasteData.split('').forEach((char, i) => {
                        if (inputs[i]) inputs[i].value = char;
                    });
                    inputs[5].focus();
                    updateFullOtp();
                }
            });
        });
        
        function updateFullOtp() {
            fullOtpInput.value = Array.from(inputs).map(i => i.value).join('');
        }
        
        // Countdown timer cho resend
        function startTimer() {
            resendLink.classList.add('disabled');
            countdown = 60;
            timerDisplay.textContent = '(' + countdown + 's)';
            
            timerInterval = setInterval(() => {
                countdown--;
                timerDisplay.textContent = '(' + countdown + 's)';
                
                if (countdown <= 0) {
                    clearInterval(timerInterval);
                    resendLink.classList.remove('disabled');
                    timerDisplay.textContent = '';
                }
            }, 1000);
        }
        
        startTimer();
        
        // Gửi lại OTP
        async function resendOTP() {
            if (resendLink.classList.contains('disabled')) return;
            
            setLoading(true);
            hideMessage();
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/resend-otp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                });
                
                const data = await response.json();
                
                if (data.success) {
                    showMessage('Mã OTP mới đã được gửi!', 'success');
                    inputs.forEach(i => i.value = '');
                    inputs[0].focus();
                    startTimer();
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                showMessage('Có lỗi xảy ra, vui lòng thử lại!', 'error');
            } finally {
                setLoading(false);
            }
        }
        
        // Submit form
        document.getElementById('otpForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const otp = fullOtpInput.value;
            if (otp.length !== 6) {
                showMessage('Vui lòng nhập đầy đủ 6 số!', 'error');
                return;
            }
            
            setLoading(true);
            hideMessage();
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/verify-otp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ otp })
                });
                
                const data = await response.json();
                
                if (data.success) {
                    showMessage(data.message, 'success');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/reset-password';
                    }, 1500);
                } else {
                    showMessage(data.message, 'error');
                }
            } catch (error) {
                showMessage('Có lỗi xảy ra, vui lòng thử lại!', 'error');
            } finally {
                setLoading(false);
            }
        });
        
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