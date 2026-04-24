// File: js/chatbot.js
document.addEventListener('DOMContentLoaded', function() {
    // Chatbot functionality
    const chatInput = document.getElementById('chatInput');
    const chatSend = document.getElementById('chatSend');
    
    if (chatSend && chatInput) {
        chatSend.addEventListener('click', function() {
            const message = chatInput.value.trim();
            if (message) {
                alert('🤖 Bot: Cảm ơn bạn đã nhắn tin! Chúng tôi sẽ phản hồi sớm.\nTin nhắn của bạn: ' + message);
                chatInput.value = '';
            } else {
                alert('Vui lòng nhập tin nhắn');
            }
        });
        
        chatInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                chatSend.click();
            }
        });
    }
    
    // Quick reply buttons
    const quickReplyBtns = document.querySelectorAll('.quick-reply-btn');
    quickReplyBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const msg = this.getAttribute('data-msg');
            alert('🤖 Bot: Bạn đã chọn "' + msg + '". Nhân viên sẽ hỗ trợ bạn ngay!');
        });
    });
});