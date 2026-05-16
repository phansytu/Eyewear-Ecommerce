// chatbot-admin.js
// ⭐ SỬA LẠI API URL - Gọi trực tiếp sang Python server
const API_BASE_URL = 'https://chatbotkinhmat.onrender.com/api';  // Thay vì gọi qua Java backend

let unresolvedInterval = null;

async function loadUnresolved() {
    try {
        // ⭐ Gọi trực tiếp sang Python Flask
        const response = await fetch(API_BASE_URL + '/feedback/list?limit=10');
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        
        const countEl = document.getElementById('unresolvedCount');
        const listEl = document.getElementById('unresolvedList');
        
        if (countEl) countEl.textContent = data.total_unresolved || 0;
        
        if (!listEl) return;
        
        if (!data.unresolved || data.unresolved.length === 0) {
            listEl.innerHTML = '<div class="empty-state">🎉 Không có câu hỏi nào cần xử lý!</div>';
            return;
        }
        
        listEl.innerHTML = data.unresolved.map(u => `
            <div class="unresolved-item">
                <div class="question">❓ ${escapeHtml(u.question || '')}</div>
                <div class="timestamp">${u.timestamp || ''}</div>
                <button class="use-btn" onclick="fillQuestion('${escapeHtml(u.question).replace(/'/g, "\\'")}')">📝 Dùng câu này</button>
            </div>
        `).join('');
    } catch (e) {
        console.error('Load unresolved error:', e);
        // Hiển thị lỗi kết nối cho admin biết
        const listEl = document.getElementById('unresolvedList');
        if (listEl) {
            listEl.innerHTML = '<div class="empty-state" style="color: red;">⚠️ Không thể kết nối đến server chatbot Python!<br>Vui lòng kiểm tra server đang chạy tại http://localhost:5000</div>';
        }
    }
}

function fillQuestion(question) {
    document.getElementById('questionInput').value = question;
    document.getElementById('answerInput').focus();
    showMessage('👆 Điền câu trả lời đúng rồi lưu!', 'success');
}

function showMessage(msg, type) {
    const msgDiv = document.getElementById('formMessage');
    if (msgDiv) {
        msgDiv.textContent = msg;
        msgDiv.className = `form-message ${type}`;
        setTimeout(() => {
            msgDiv.textContent = '';
            msgDiv.className = 'form-message';
        }, 3000);
    }
}

async function addQA() {
    const question = document.getElementById('questionInput').value.trim();
    const answer = document.getElementById('answerInput').value.trim();
    const topic = document.getElementById('topicSelect').value;
    const btn = document.querySelector('.submit-qa-btn');
    
    if (!question || !answer) {
        showMessage('⚠️ Vui lòng điền đủ câu hỏi và câu trả lời!', 'error');
        return;
    }
    
    btn.disabled = true;
    btn.textContent = '⏳ Đang lưu...';
    
    try {
        // ⭐ Gọi trực tiếp sang Python Flask
        const response = await fetch(API_BASE_URL + '/feedback/add-qa', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                question: question,
                answer: answer,
                topic: topic,
                retrain: true
            })
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            showMessage('✅ Đã lưu và huấn luyện lại thành công!', 'success');
            document.getElementById('questionInput').value = '';
            document.getElementById('answerInput').value = '';
            loadUnresolved();
        } else {
            showMessage('❌ ' + (data.error || 'Lỗi không xác định'), 'error');
        }
    } catch (e) {
        showMessage('❌ Không thể kết nối đến server Python! Vui lòng kiểm tra server đang chạy.', 'error');
        console.error(e);
    } finally {
        btn.disabled = false;
        btn.textContent = '💾 Lưu & Huấn luyện';
    }
}

async function viewLogs() {
    try {
        const response = await fetch(API_BASE_URL + '/feedback/logs');
        const data = await response.json();
        console.log('Chat logs:', data);
        alert('Logs đã được mở trong console (F12)');
    } catch (e) {
        console.error(e);
        alert('Không thể lấy logs!');
    }
}

async function adminLogout() {
    try {
        // Gọi logout API nếu có, không thì chuyển trang
        await fetch(window.contextPath + '/logout', { method: 'POST' });
    } catch(e) {
        // ignore
    }
    window.location.href = window.contextPath + '/login';
}

// Minimize panel functionality
const panel = document.getElementById('adminChatbotPanel');
const minimizeBtn = document.getElementById('minimizePanel');

if (minimizeBtn && panel) {
    minimizeBtn.addEventListener('click', () => {
        panel.classList.toggle('minimized');
        minimizeBtn.textContent = panel.classList.contains('minimized') ? '+' : '−';
    });
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Auto refresh every 30 seconds
loadUnresolved();
if (unresolvedInterval) clearInterval(unresolvedInterval);
unresolvedInterval = setInterval(loadUnresolved, 30000);