function toggleChat() {
    let box = document.getElementById("chatBox");
    box.style.display = box.style.display === "flex" ? "none" : "flex";
}

function sendMsg() {
    let input = document.getElementById("chatInput");
    let chat = document.getElementById("chatBody");

    let text = input.value.trim();
    if (!text) return;

    chat.innerHTML += `<div class="msg user">${text}</div>`;

    let reply = getReply(text);
    chat.innerHTML += `<div class="msg bot">${reply}</div>`;

    input.value = "";
    chat.scrollTop = chat.scrollHeight;
}

function quickMsg(text) {
    document.getElementById("chatInput").value = text;
    sendMsg();
}

/* Bot logic */
function getReply(msg) {
    msg = msg.toLowerCase();

    if (msg.includes("sản phẩm")) return "Bạn có thể xem tại menu phía trên 👆";
    if (msg.includes("giá")) return "Giá sản phẩm hiển thị tại trang chi tiết";
    if (msg.includes("liên hệ")) return "Hotline: 1900 1234 ☎";

    return "Xin lỗi, tôi chưa hiểu 😅";
}