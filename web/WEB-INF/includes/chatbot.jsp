<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<link rel="stylesheet" href="${root}/css/chatbot.css">
<!-- Chatbot Floating Button -->
<div class="chatbot-float" id="chatbotFloat">
    <button class="chatbot-button" id="chatbotBtn">
        <span class="chatbot-tooltip">TuKhanhHuy AI</span>
        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 2C6.48 2 2 6.48 2 12c0 1.82.5 3.5 1.38 4.97L2 22l5.03-1.38C8.5 21.5 10.18 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" fill="currentColor"/>
            <path d="M8 12h.01M12 12h.01M16 12h.01" stroke="white" stroke-width="2" stroke-linecap="round"/>
        </svg>
        <span class="chatbot-badge" id="chatbotBadge" style="display: none;">1</span>
    </button>
</div>

<!-- Chatbot Modal/Wrapper -->
<div class="chatbot-wrapper" id="chatbotWrapper">
    <div class="chatbot-container">
        <div class="chatbot-header">
            <div class="chatbot-header-info">
                <div class="chatbot-avatar">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                        <path d="M12 2C6.48 2 2 6.48 2 12c0 1.82.5 3.5 1.38 4.97L2 22l5.03-1.38C8.5 21.5 10.18 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" fill="white"/>
                        <path d="M8 12h.01M12 12h.01M16 12h.01" stroke="#1A94FF" stroke-width="2" stroke-linecap="round"/>
                    </svg>
                </div>
                <div>
                    <h4>TuKhanhHuy AI</h4>
                    <p>Hỗ trợ 24/7</p>
                </div>
            </div>
            <button class="chatbot-close" id="chatbotClose">×</button>
        </div>
        
        <div class="chatbot-messages" id="chatbotMessages">
            <div class="message bot">
                <div class="message-avatar">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
                        <path d="M12 2C6.48 2 2 6.48 2 12c0 1.82.5 3.5 1.38 4.97L2 22l5.03-1.38C8.5 21.5 10.18 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" fill="white"/>
                    </svg>
                </div>
                <div class="message-content">
                    Xin chào! Tôi là trợ lý ảo của TuKhanhHuy. Tôi có thể giúp gì cho bạn hôm nay?
                    <div class="quick-actions">
                        <button class="quick-btn" data-msg="Xem sản phẩm">🛍️ Xem sản phẩm</button>
                        <button class="quick-btn" data-msg="Bảng giá">💰 Bảng giá</button>
                        <button class="quick-btn" data-msg="Chính sách">📜 Chính sách</button>
                        <button class="quick-btn" data-msg="Liên hệ">📞 Liên hệ</button>
                    </div>
                    <span class="message-time">Vừa xong</span>
                </div>
            </div>
        </div>
        
        <div class="chatbot-input-wrapper">
            <textarea id="chatbotInput" placeholder="Hỏi về kính... (Enter để gửi)" rows="1" maxlength="500"></textarea>
            <button id="chatbotSendBtn" class="send-btn">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                    <path d="M22 2L11 13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M22 2L15 22L11 13L2 9L22 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </button>
        </div>
    </div>
</div>

<script>
(function() {
    const chatbotBtn = document.getElementById('chatbotBtn');
    const chatbotWrapper = document.getElementById('chatbotWrapper');
    const chatbotClose = document.getElementById('chatbotClose');
    const chatbotInput = document.getElementById('chatbotInput');
    const chatbotSendBtn = document.getElementById('chatbotSendBtn');
    const chatbotMessages = document.getElementById('chatbotMessages');
    
    let isOpen = false;
    
    function openChatbot() {
        chatbotWrapper.classList.add('open');
        isOpen = true;
        chatbotInput.focus();
    }
    
    function closeChatbot() {
        chatbotWrapper.classList.remove('open');
        isOpen = false;
    }
    
    function addMessage(sender, text, isHtml = false) {
        const time = new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}`;
        
        messageDiv.innerHTML = `
            <div class="message-avatar">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
                    <path d="M12 2C6.48 2 2 6.48 2 12c0 1.82.5 3.5 1.38 4.97L2 22l5.03-1.38C8.5 21.5 10.18 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" fill="${sender == 'bot' ? 'white' : '#6c757d'}"/>
                </svg>
            </div>
            <div class="message-content">
                <c:choose>
    <c:when test="${isHtml}">
        ${text}
    </c:when>
    <c:otherwise>
        <c:out value="${text}" />
    </c:otherwise>
</c:choose>
                <span class="message-time">${time}</span>
            </div>
        `;
        
        chatbotMessages.appendChild(messageDiv);
        chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
    }
    
    function showTyping() {
        const typingDiv = document.createElement('div');
        typingDiv.className = 'typing-indicator';
        typingDiv.id = 'typingIndicator';
        typingDiv.innerHTML = '<span></span><span></span><span></span>';
        chatbotMessages.appendChild(typingDiv);
        chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
    }
    
    function hideTyping() {
        const indicator = document.getElementById('typingIndicator');
        if (indicator) indicator.remove();
    }
    
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    async function getBotResponse(message) {
        const lowerMsg = message.toLowerCase();
        
        if (lowerMsg.includes('sản phẩm') || lowerMsg.includes('kính')) {
            return '🕶️ <strong>Các dòng sản phẩm tại TuKhanhHuy:</strong><br>• Gọng kính: 200.000đ - 1.500.000đ<br>• Kính râm: 500.000đ - 3.000.000đ<br>• Kính chống ánh sáng xanh: 300.000đ - 800.000đ<br><br>👉 <a href="${root}/home">Xem ngay</a>';
        }
        
        if (lowerMsg.includes('giá') || lowerMsg.includes('bao nhiêu')) {
            return '💰 <strong>Bảng giá tham khảo:</strong><br>• Gọng kính: 200.000đ - 1.500.000đ<br>• Kính râm: 500.000đ - 3.000.000đ<br>• Kính chống ánh sáng xanh: 300.000đ - 800.000đ<br><br>🎁 Hiện đang có nhiều ưu đãi hấp dẫn!';
        }
        
        if (lowerMsg.includes('chính sách') || lowerMsg.includes('bảo hành')) {
            return '📋 <strong>Chính sách của TuKhanhHuy:</strong><br>✅ Bảo hành gọng 12 tháng<br>✅ Đổi trả trong 30 ngày<br>✅ 100% kính chính hãng<br>✅ Hỗ trợ tư vấn miễn phí';
        }
        
        if (lowerMsg.includes('vận chuyển') || lowerMsg.includes('giao hàng')) {
            return '🚚 <strong>Thông tin vận chuyển:</strong><br>• Giao siêu tốc: 2h (nội thành)<br>• Giao tiêu chuẩn: 1-3 ngày<br>• Miễn phí ship đơn từ 150.000đ';
        }
        
        if (lowerMsg.includes('liên hệ') || lowerMsg.includes('hotline')) {
            return '📞 <strong>Thông tin liên hệ:</strong><br>• Hotline: 1900 1234<br>• Email: cskh@tukhanhhuy.com<br>• Facebook: fb.com/tukhanhhuy';
        }
        
        if (lowerMsg.includes('chào') || lowerMsg.includes('hi')) {
            return '👋 Xin chào! Rất vui được hỗ trợ bạn. Bạn cần tư vấn về sản phẩm hay chính sách nào không?';
        }
        
        return '🤔 Cảm ơn bạn đã quan tâm! Tôi có thể giúp bạn:<br><br>📦 Xem sản phẩm<br>💰 Bảng giá<br>📜 Chính sách bảo hành<br>🚚 Vận chuyển<br>📞 Liên hệ';
    }
    
    async function sendMessage() {
        const message = chatbotInput.value.trim();
        if (!message) return;
        
        chatbotInput.value = '';
        addMessage('user', message);
        
        showTyping();
        
        setTimeout(async () => {
            const response = await getBotResponse(message);
            hideTyping();
            addMessage('bot', response, true);
        }, 500);
        
        chatbotInput.style.height = 'auto';
    }
    
    // Auto resize textarea
    chatbotInput.addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = Math.min(this.scrollHeight, 100) + 'px';
    });
    
    // Enter to send, Shift+Enter for new line
    chatbotInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });
    
    // Event listeners
    chatbotBtn.addEventListener('click', openChatbot);
    chatbotClose.addEventListener('click', closeChatbot);
    chatbotSendBtn.addEventListener('click', sendMessage);
    
    // Quick reply buttons
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('quick-btn')) {
            const msg = e.target.getAttribute('data-msg');
            if (msg) {
                chatbotInput.value = msg;
                sendMessage();
            }
        }
    });
    
    // Close on outside click
    document.addEventListener('click', function(e) {
        if (isOpen && !chatbotWrapper.contains(e.target) && !chatbotBtn.contains(e.target)) {
            closeChatbot();
        }
    });
})();
</script>