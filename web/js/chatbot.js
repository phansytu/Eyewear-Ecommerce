// js/chatbot.js
(function() {
    'use strict';
    
    const chatbotBtn = document.getElementById('chatbotBtn');
    const chatbotWrapper = document.getElementById('chatbotWrapper');
    const chatbotClose = document.getElementById('chatbotClose');
    const chatbotInput = document.getElementById('chatbotInput');
    const chatbotSendBtn = document.getElementById('chatbotSendBtn');
    const chatbotMessages = document.getElementById('chatbotMessages');
    
    const API_URL = window.CHATBOT_API_URL || 'http://localhost:5000/api/chat';
    let sessionId = null;
    let isOpen = false;
    
    function initSession() {
        sessionId = localStorage.getItem('chatbot_session_id');
        if (!sessionId) {
            sessionId = 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
            localStorage.setItem('chatbot_session_id', sessionId);
        }
    }
    
    function openChatbot() {
        chatbotWrapper.classList.add('open');
        isOpen = true;
        chatbotInput.focus();
    }
    
    function closeChatbot() {
        chatbotWrapper.classList.remove('open');
        isOpen = false;
    }
    
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    function getCurrentTime() {
        return new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
    }
    
    function addMessage(sender, content, isHtml = false, recommendQuestions = null) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}`;
        
        let innerContent = isHtml ? content : escapeHtml(content);
        
        if (recommendQuestions && recommendQuestions.length > 0) {
            innerContent += '<div class="recommend-questions" style="margin-top: 10px; display: flex; flex-wrap: wrap; gap: 8px;">';
            recommendQuestions.forEach(q => {
                innerContent += `<button class="recommend-btn" style="background: #f0f0f0; border: none; padding: 5px 12px; border-radius: 20px; font-size: 12px; cursor: pointer;">${escapeHtml(q)}</button>`;
            });
            innerContent += '</div>';
        }
        
        messageDiv.innerHTML = `
            <div class="message-avatar">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
                    <path d="M12 2C6.48 2 2 6.48 2 12c0 1.82.5 3.5 1.38 4.97L2 22l5.03-1.38C8.5 21.5 10.18 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" fill="${sender === 'bot' ? 'white' : '#6c757d'}"/>
                </svg>
            </div>
            <div class="message-content">
                ${innerContent}
                <span class="message-time">${getCurrentTime()}</span>
            </div>
        `;
        
        chatbotMessages.appendChild(messageDiv);
        chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
        
        messageDiv.querySelectorAll('.recommend-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                chatbotInput.value = btn.textContent;
                sendMessage();
            });
        });
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
    
    async function sendMessage() {
        const message = chatbotInput.value.trim();
        if (!message) return;
        
        chatbotInput.value = '';
        addMessage('user', message);
        showTyping();
        
        try {
            const response = await fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: message, session_id: sessionId })
            });
            
            const data = await response.json();
            console.log('API Response:', data);
            hideTyping();
            
            // Kiểm tra response và lấy reply
            if (data && data.success === true) {
                const reply = data.reply || data.response || 'Xin lỗi, tôi chưa hiểu câu hỏi.';
                addMessage('bot', reply, true, data.recommend_questions);
            } else if (data && data.reply) {
                addMessage('bot', data.reply, true, data.recommend_questions);
            } else if (data && data.response) {
                addMessage('bot', data.response, true, data.recommend_questions);
            } else {
                addMessage('bot', 'Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau!');
            }
            
        } catch (error) {
            console.error('API Error:', error);
            hideTyping();
            addMessage('bot', '❌ Không thể kết nối đến server chatbot. Vui lòng kiểm tra lại!');
        }
        
        chatbotInput.style.height = 'auto';
    }
    
    function autoResizeTextarea() {
        chatbotInput.style.height = 'auto';
        chatbotInput.style.height = Math.min(chatbotInput.scrollHeight, 100) + 'px';
    }
    
    function bindEvents() {
        if (chatbotBtn) chatbotBtn.addEventListener('click', openChatbot);
        if (chatbotClose) chatbotClose.addEventListener('click', closeChatbot);
        if (chatbotSendBtn) chatbotSendBtn.addEventListener('click', sendMessage);
        if (chatbotInput) {
            chatbotInput.addEventListener('input', autoResizeTextarea);
            chatbotInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
        }
        
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('quick-btn')) {
                const msg = e.target.getAttribute('data-msg');
                if (msg) {
                    chatbotInput.value = msg;
                    sendMessage();
                }
            }
        });
        
        document.addEventListener('click', (e) => {
            if (isOpen && !chatbotWrapper.contains(e.target) && !chatbotBtn.contains(e.target)) {
                closeChatbot();
            }
        });
    }
    
    document.addEventListener('DOMContentLoaded', () => {
        initSession();
        bindEvents();
        console.log('✅ Chatbot initialized, API URL:', API_URL);
    });
})();