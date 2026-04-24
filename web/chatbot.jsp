<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Floating Widgets: Chatbot & News - KHÔNG XUNG ĐỘT -->
<div class="chatbot-news-floating">
    
    <!-- Chatbot Widget -->
    <div class="chatbot-news-widget cn-chatbot" id="chatbotWidget">
        <div class="cn-deal-badge">✨ AI</div>
        <div class="cn-header">
            <i class="fas fa-robot"></i>
            <div>
                <div class="cn-title">Trợ lý AI</div>
                <div class="cn-subtitle">Hỗ trợ 24/7</div>
            </div>
        </div>
        <div class="cn-content">
            <div class="cn-quick-replies">
                <button class="cn-quick-reply-btn" data-msg="Xem sản phẩm">🛍️ Xem sản phẩm</button>
                <button class="cn-quick-reply-btn" data-msg="Bảng giá">💰 Bảng giá</button>
                <button class="cn-quick-reply-btn" data-msg="Chính sách">📜 Chính sách</button>
                <button class="cn-quick-reply-btn" data-msg="Liên hệ">📞 Liên hệ</button>
            </div>
            <div class="cn-chat-input-area">
                <input type="text" class="cn-chat-input" id="chatInput" placeholder="Nhập tin nhắn...">
                <button class="cn-chat-send" id="chatSend">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>
    
    <!-- News Widget -->
    <div class="chatbot-news-widget cn-news" id="newsWidget">
        <div class="cn-deal-badge">🔥 HOT</div>
        <div class="cn-header">
            <i class="fas fa-bullhorn"></i>
            <div>
                <div class="cn-title">Tin mới & Khuyến mãi</div>
                <div class="cn-subtitle">Cập nhật liên tục</div>
            </div>
        </div>
        <div class="cn-content">
            <div class="cn-news-item" data-url="/promotion/deal-wow">
                <div class="cn-news-icon">
                    <i class="fas fa-gift"></i>
                </div>
                <div class="cn-news-content">
                    <div class="cn-news-title">
                        Deal siêu wow! 
                        <span class="cn-news-badge">Mới</span>
                    </div>
                    <div class="cn-news-desc">Coupon đến 30% - Sức khỏe dồi dào</div>
                </div>
            </div>
            <div class="cn-news-item" data-url="/promotion/top-deal">
                <div class="cn-news-icon">
                    <i class="fas fa-tag"></i>
                </div>
                <div class="cn-news-content">
                    <div class="cn-news-title">Top deal - Siêu rẻ</div>
                    <div class="cn-news-desc">Giảm giá sốc hàng ngàn sản phẩm</div>
                </div>
            </div>
            <div class="cn-news-item" data-url="/promotion/book-sale">
                <div class="cn-news-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="cn-news-content">
                    <div class="cn-news-title">Top sách đáng đọc</div>
                    <div class="cn-news-desc">Ưu đãi lên đến 50%</div>
                </div>
            </div>
            <a href="/promotions" class="cn-view-all">Xem tất cả <i class="fas fa-chevron-right"></i></a>
        </div>
    </div>
    
</div>

<!-- JavaScript cho Widget -->
<script>
    (function() {
        // Đợi DOM load xong
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initWidgets);
        } else {
            initWidgets();
        }
        
        function initWidgets() {
            // Toggle widget khi click vào header
            const widgets = document.querySelectorAll('.chatbot-news-widget');
            widgets.forEach(widget => {
                const header = widget.querySelector('.cn-header');
                if (header) {
                    header.addEventListener('click', function(e) {
                        e.stopPropagation();
                        widget.classList.toggle('cn-expanded');
                    });
                }
            });
            
            // Mở widget mặc định (chatbot mở, news đóng)
            const chatbot = document.getElementById('chatbotWidget');
            const newsWidget = document.getElementById('newsWidget');
            if (chatbot && !chatbot.classList.contains('cn-expanded')) {
                chatbot.classList.add('cn-expanded');
            }
            
            // Chatbot functionality
            const chatInput = document.getElementById('chatInput');
            const chatSend = document.getElementById('chatSend');
            
            if (chatSend && chatInput) {
                const sendMessage = function() {
                    const message = chatInput.value.trim();
                    if (message) {
                        alert('🤖 Bot: Cảm ơn bạn đã nhắn tin!\nTin nhắn: ' + message + '\n\nNhân viên sẽ phản hồi sớm!');
                        chatInput.value = '';
                    } else {
                        alert('Vui lòng nhập tin nhắn');
                    }
                };
                
                chatSend.addEventListener('click', sendMessage);
                chatInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        sendMessage();
                    }
                });
            }
            
            // Quick reply buttons
            const quickReplyBtns = document.querySelectorAll('.cn-quick-reply-btn');
            quickReplyBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const msg = this.getAttribute('data-msg');
                    alert('🤖 Bot: Bạn đã chọn "' + msg + '"\n\nChúng tôi sẽ hỗ trợ bạn ngay!');
                });
            });
            
            // News items click
            const newsItems = document.querySelectorAll('.cn-news-item');
            newsItems.forEach(item => {
                item.addEventListener('click', function() {
                    const url = this.getAttribute('data-url') || '#';
                    window.location.href = '${root}' + url;
                });
            });
        }
    })();
</script>