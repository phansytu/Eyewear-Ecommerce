// giohangcount.js
// Cập nhật subtotal cho một dòng sản phẩm
function updateItemSubtotal(itemId) {
    const qtyInput = document.getElementById('qty-' + itemId);
    const priceElement = document.querySelector(`.cart-item[data-item-id="${itemId}"] .product-price`);
    const subtotalElement = document.querySelector(`.cart-item[data-item-id="${itemId}"] .subtotal`);
    
    if (priceElement && subtotalElement && qtyInput) {
        let priceText = priceElement.textContent;
        let price = parseFloat(priceText.replace(/[^\d]/g, '')) || 0;
        let quantity = parseInt(qtyInput.value) || 0;
        let subtotal = price * quantity;
        subtotalElement.textContent = subtotal.toLocaleString('vi-VN') + '₫';
    }
}

// Cập nhật tổng tiền và tổng số lượng
function updateCartTotal() {
    let total = 0;
    let totalQuantity = 0;
    
    // Tính tổng tiền từ subtotal
    document.querySelectorAll('.subtotal').forEach(el => {
        let value = el.textContent.replace(/[^0-9]/g, '');
        total += parseFloat(value) || 0;
    });
    
    // Tính tổng số lượng từ các input
    document.querySelectorAll('.quantity-input').forEach(input => {
        totalQuantity += parseInt(input.value) || 0;
    });
    
    // Cập nhật tổng tiền (dùng id)
    const totalElement = document.getElementById('totalPriceSpan');
    if (totalElement) {
        totalElement.textContent = total.toLocaleString('vi-VN') + '₫';
    }
    
    // Cập nhật tổng số lượng (dùng id)
    const quantityElement = document.getElementById('totalQuantitySpan');
    if (quantityElement) {
        quantityElement.textContent = totalQuantity;
    }
}

async function updateQuantity(itemId, change) {
    const input = document.getElementById('qty-' + itemId);
    let newQuantity = parseInt(input.value) + change;
    if (newQuantity < 1) newQuantity = 1;
    input.value = newQuantity;
    await setQuantity(itemId, newQuantity);
}

// Cập nhật số lượng khi thêm/xóa sản phẩm
async function setQuantity(itemId, quantity) {
    if (quantity < 1) quantity = 1;
    
    const input = document.getElementById('qty-' + itemId);
    if (input) input.value = quantity;
    
    try {
        const response = await fetch(contextPath + '/cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ action: 'update', itemId: itemId, quantity: quantity })
        });
        
        const data = await response.json();
        if (data.success) {
            updateItemSubtotal(itemId);
            updateCartTotal();
            // KHÔNG cập nhật icon vì không có data.count
        } else {
            showMessage(data.message, 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showMessage('Có lỗi xảy ra!', 'error');
    }
}

// Xóa sản phẩm - cập nhật icon (có data.count)
async function removeItem(itemId) {
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;
    
    try {
        const response = await fetch(contextPath + '/cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ action: 'remove', itemId: itemId })
        });
        
        const data = await response.json();
        if (data.success) {
            const itemRow = document.querySelector(`.cart-item[data-item-id="${itemId}"]`);
            if (itemRow) itemRow.remove();
            
            updateCartTotal();
            
            // Cập nhật icon nếu có count
            if (data.count !== undefined) {
                const badge = document.getElementById('cartCount');
                if (badge) {
                    badge.textContent = data.count;
                    badge.style.display = data.count > 0 ? 'inline-block' : 'none';
                }
            }
            
            const remainingItems = document.querySelectorAll('.cart-item').length;
            if (remainingItems === 0) {
                location.reload();
            } else {
                showMessage('Đã xóa sản phẩm!', 'success');
            }
        } else {
            showMessage(data.message, 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showMessage('Có lỗi xảy ra!', 'error');
    }
}

async function clearCart() {
    if (!confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')) return;
    
    try {
        const response = await fetch(contextPath + '/cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ action: 'clear' })
        });
        
        const data = await response.json();
        if (data.success) {
            updateCartCount();
            location.reload();
        } else {
            showMessage(data.message, 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showMessage('Có lỗi xảy ra!', 'error');
    }
}

function checkout() {
    window.location.href = contextPath + '/checkout';
}

function showMessage(msg, type) {
    const msgDiv = document.getElementById('message');
    if (msgDiv) {
        msgDiv.textContent = msg;
        msgDiv.className = 'message ' + type;
        msgDiv.style.display = 'block';
        setTimeout(() => msgDiv.style.display = 'none', 3000);
    } else {
        alert(msg);
    }
}

// DOMContentLoaded
document.addEventListener('DOMContentLoaded', function() {
    updateCartCount();
});