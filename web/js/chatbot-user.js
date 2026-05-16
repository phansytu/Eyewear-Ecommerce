// chatbot-user.js
(function() {
    'use strict';
    
    // ⭐ SỬA LẠI API URL - Gọi trực tiếp sang Python server
    const API_URL = 'https://chatbotkinhmat.onrender.com/api/chat';
    let sessionId = null;
    let isOpen = false;
    
    // DOM elements
    const chatbotBtn = document.getElementById('chatbotBtn');
    const chatbotWrapper = document.getElementById('chatbotWrapper');
    const chatbotClose = document.getElementById('chatbotClose');
    const chatbotInput = document.getElementById('chatbotInput');
    const chatbotSendBtn = document.getElementById('chatbotSendBtn');
    const chatbotMessages = document.getElementById('chatbotMessages');
    
    // State cho phân trang sản phẩm
    let currentSearchSession = null;
    let currentProducts = [];
    let currentOffset = 0;
    let currentTotal = 0;
    
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
        if (chatbotInput) chatbotInput.focus();
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
    
    function formatMoney(n) {
        try {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0
            }).format(n);
        } catch(e) {
            return n;
        }
    }
    
    function getCurrentTime() {
        return new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
    }
    
    function addMessage(sender, content, isHtml = false, recommendQuestions = null, products = null, hasMore = false) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}`;
        
        let innerContent = isHtml ? content : escapeHtml(content);
        
        // Hiển thị sản phẩm nếu có
        if (products && products.length > 0) {
            innerContent += '<div class="prod-grid">';
            products.forEach(p => {
                const price = p.effective_price || p.sale_price || p.price || 0;
                const disc = p.discount_pct || 0;
                const orig = p.price || 0;
                const origTxt = disc > 0 ? `<span class="orig">${formatMoney(orig)}</span>` : '';
                const discBadge = disc > 0 ? `<span class="badge">-${Math.round(disc)}%</span>` : '';
                
                innerContent += `
                    <div class="prod-card" onclick="window.location.href='${window.contextPath || ''}/product?id=${p.id}'">
                        <div class="pname">🕶️ ${escapeHtml(p.name || '')}</div>
                        <div class="pprice">${formatMoney(price)}${origTxt}${discBadge}</div>
                        <div class="pmeta">${p.frame_material ? `🔧 ${escapeHtml(p.frame_material)}` : ''}</div>
                    </div>
                `;
            });
            innerContent += '</div>';
            
            if (hasMore && currentTotal > products.length) {
                innerContent += `<button class="load-more-btn" onclick="loadMoreProducts()">📦 Xem thêm ${Math.min(3, currentTotal - products.length)} sản phẩm (còn ${currentTotal - products.length})</button>`;
            }
        }
        
        // Hiển thị câu hỏi gợi ý
        if (recommendQuestions && recommendQuestions.length > 0) {
            innerContent += '<div class="quick-actions" style="margin-top: 10px;">';
            recommendQuestions.forEach(q => {
                innerContent += `<button class="quick-btn" onclick="sendQuickMessage('${escapeHtml(q).replace(/'/g, "\\'")}')">${escapeHtml(q)}</button>`;
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
    
    window.loadMoreProducts = async function() {
        if (!currentSearchSession || currentOffset >= currentTotal) return;
        
        showTyping();
        try {
            const response = await fetch(API_URL + '/more', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    search_session_id: currentSearchSession,
                    offset: currentOffset,
                    limit: 3
                })
            });
            const data = await response.json();
            hideTyping();
            
            if (data.products && data.products.length > 0) {
                currentProducts = [...currentProducts, ...data.products];
                currentOffset = data.next_offset;
                
                // Thêm sản phẩm mới vào tin nhắn bot cuối cùng
                const lastBotMessage = document.querySelector('.message.bot:last-child');
                if (lastBotMessage) {
                    const prodGrid = lastBotMessage.querySelector('.prod-grid');
                    if (prodGrid) {
                        data.products.forEach(p => {
                            const price = p.effective_price || p.sale_price || p.price || 0;
                            const prodCard = document.createElement('div');
                            prodCard.className = 'prod-card';
                            prodCard.innerHTML = `
                                <div class="pname">🕶️ ${escapeHtml(p.name || '')}</div>
                                <div class="pprice">${formatMoney(price)}</div>
                            `;
                            prodCard.onclick = () => window.location.href = `${window.contextPath || ''}/product?id=${p.id}`;
                            prodGrid.appendChild(prodCard);
                        });
                    }
                }
                
                // Cập nhật hoặc xóa nút load more
                const loadMoreBtn = document.querySelector('.message.bot:last-child .load-more-btn');
                if (currentOffset < currentTotal) {
                    if (loadMoreBtn) {
                        loadMoreBtn.innerHTML = `📦 Xem thêm ${Math.min(3, currentTotal - currentOffset)} sản phẩm (còn ${currentTotal - currentOffset})`;
                    }
                } else if (loadMoreBtn) {
                    loadMoreBtn.remove();
                }
            }
        } catch (e) {
            hideTyping();
            console.error(e);
        }
    };
    
    window.sendQuickMessage = function(msg) {
        if (chatbotInput) {
            chatbotInput.value = msg;
            sendMessage();
        }
    };
    
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
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            hideTyping();
            
            if (data && data.success === true) {
                const reply = data.reply || data.response || 'Xin lỗi, tôi chưa hiểu câu hỏi.';
                
                // Lưu thông tin phân trang nếu có
                if (data.products && data.products.length > 0) {
                    currentSearchSession = data.search_session_id;
                    currentProducts = data.products;
                    currentOffset = data.offset || 3;
                    currentTotal = data.total_products || data.products.length;
                }
                
                addMessage('bot', reply, true, data.recommend_questions, data.products, data.has_more);
            } else if (data && data.reply) {
                addMessage('bot', data.reply, true, data.recommend_questions);
            } else {
                addMessage('bot', 'Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau!');
            }
            
        } catch (error) {
            console.error('API Error:', error);
            hideTyping();
            addMessage('bot', '❌ Không thể kết nối đến server chatbot. Vui lòng kiểm tra lại server Python đang chạy tại http://localhost:5000!');
        }
        
        if (chatbotInput) chatbotInput.style.height = 'auto';
    }
    
    function autoResizeTextarea() {
        if (!chatbotInput) return;
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
            if (isOpen && chatbotWrapper && !chatbotWrapper.contains(e.target) && chatbotBtn && !chatbotBtn.contains(e.target)) {
                closeChatbot();
            }
        });
        
        // Xử lý quick buttons
        document.querySelectorAll('.quick-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const msg = btn.getAttribute('data-msg') || btn.textContent;
                if (chatbotInput) {
                    chatbotInput.value = msg;
                    sendMessage();
                }
            });
        });
    }
    
    document.addEventListener('DOMContentLoaded', () => {
        initSession();
        bindEvents();
        console.log('✅ User Chatbot initialized, API URL:', API_URL);
    });
})();