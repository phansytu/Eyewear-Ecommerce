<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>

<!-- Admin Panel Container (hiển thị dạng modal hoặc cố định) -->
<div class="admin-chatbot-container" id="adminChatbotPanel">
    <div class="admin-panel-header">
        <h3>⚙️ Admin Chatbot Manager</h3>
        <button id="minimizePanel" class="minimize-btn">−</button>
    </div>
    
    <div class="admin-panel-body" id="adminPanelBody">
        <!-- Thống kê -->
        <div class="admin-stat-card">
            <h4>📊 Câu hỏi chưa xử lý</h4>
            <div class="stat-number" id="unresolvedCount">0</div>
            <button class="refresh-stats-btn" onclick="loadUnresolved()">🔄 Làm mới</button>
        </div>
        
        <!-- Danh sách câu hỏi cần xử lý -->
        <div class="admin-section">
            <h4>❓ Câu hỏi cần bổ sung</h4>
            <div class="unresolved-list" id="unresolvedList">
                <div class="empty-state">Chưa có câu hỏi nào</div>
            </div>
        </div>
        
        <!-- Form thêm Q&A -->
        <div class="admin-section">
            <h4>➕ Thêm kiến thức cho AI</h4>
            <div class="qa-form">
                <input type="text" id="questionInput" placeholder="Câu hỏi của khách hàng..." />
                <textarea id="answerInput" placeholder="Câu trả lời chuẩn của shop..." rows="3"></textarea>
                <select id="topicSelect">
                    <option value="Tư vấn sản phẩm">📦 Tư vấn sản phẩm</option>
                    <option value="Giá cả">💰 Giá cả</option>
                    <option value="Chính sách">📜 Chính sách</option>
                    <option value="Tính năng">🔧 Tính năng</option>
                </select>
                <button onclick="addQA()" class="submit-qa-btn">💾 Lưu & Huấn luyện</button>
                <div id="formMessage" class="form-message"></div>
            </div>
        </div>
        
        <!-- Nút xem logs -->
        <div class="admin-section">
            <h4>📋 Logs hội thoại</h4>
            <button onclick="viewLogs()" class="view-logs-btn">Xem lịch sử chat</button>
        </div>
        
        <!-- Nút logout admin -->
        <button onclick="adminLogout()" class="logout-admin-btn">🚪 Đăng xuất Admin</button>
    </div>
</div>

<script>
    window.API_BASE_URL = '${root}/api';
    window.USER_ROLE = 'ADMIN';
</script>
<script src="${root}/js/chatbot-admin.js"></script>