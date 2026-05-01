<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

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
                    Xin chào! Tôi là trợ lý ảo AI của TuKhanhHuy.
                    <div class="quick-actions">
                        <button class="quick-btn" data-msg="sản phẩm">🛍️ Xem sản phẩm</button>
                        <button class="quick-btn" data-msg="giá rẻ">💰 Tìm giá rẻ</button>
                        <button class="quick-btn" data-msg="kính râm">🕶️ Kính râm</button>
                        <button class="quick-btn" data-msg="chính sách">📜 Chính sách</button>
                        <button class="quick-btn" data-msg="liên hệ">📞 Liên hệ</button>
                    </div>
                    <span class="message-time">Vừa xong</span>
                </div>
            </div>
        </div>
        
        <div class="chatbot-input-wrapper">
            <textarea id="chatbotInput" placeholder="Hỏi về sản phẩm, giá cả... (Enter để gửi)" rows="1" maxlength="500"></textarea>
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
    // Khai báo API URL
    window.CHATBOT_API_URL = 'http://localhost:5000/api/chat';
</script>
<script src="${root}/js/chatbot.js"></script>