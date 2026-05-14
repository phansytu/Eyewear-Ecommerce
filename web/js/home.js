// home.js - Xử lý bộ lọc (chỉ submit khi ấn nút Áp dụng)

(function() {
    'use strict';
    
    // ==================== BIẾN TOÀN CỤC ====================
    let activeFilters = {
        minPrice: '',
        maxPrice: '',
        gender: '',
        frameMaterial: '',
        brand: ''
    };
    
    // ==================== KHỞI TẠO ====================
    document.addEventListener('DOMContentLoaded', function() {
        loadStoredFilters();
        initSort();
        initPagination();
        initFilterDropdowns();
        initPricePresets();
        bindFilterChangeEvents();
        renderSelectedBadges();
        syncInputsWithFilters();
        
        // Gắn sự kiện cho nút Áp dụng bộ lọc
        const applyBtn = document.getElementById('applyFilterBtn');
        if (applyBtn) {
            // Xóa sự kiện cũ nếu có
            const newBtn = applyBtn.cloneNode(true);
            applyBtn.parentNode.replaceChild(newBtn, applyBtn);
            newBtn.addEventListener('click', function(e) {
                e.preventDefault();
                applyFilters();
            });
        }
        const clearAllBtn = document.getElementById('clearAllFiltersBtn');
if (clearAllBtn) {
    // Xóa sự kiện cũ để tránh trùng lặp
    const newClearBtn = clearAllBtn.cloneNode(true);
    clearAllBtn.parentNode.replaceChild(newClearBtn, clearAllBtn);
    newClearBtn.addEventListener('click', function(e) {
        e.preventDefault();
        clearAllFiltersAndSubmit();
    });
}
    });
    
    // ==================== LƯU & ĐỌC FILTER TỪ STORAGE ====================
    function loadStoredFilters() {
        const stored = localStorage.getItem('productFilters');
        if (stored) {
            try {
                const parsed = JSON.parse(stored);
                activeFilters = { ...activeFilters, ...parsed };
            } catch(e) {
                console.error('Error loading filters:', e);
            }
        }
    }
    
    function saveFilters() {
        localStorage.setItem('productFilters', JSON.stringify(activeFilters));
    }
    
    function syncInputsWithFilters() {
        // Đồng bộ radio buttons
        Object.entries(activeFilters).forEach(([name, value]) => {
            if (value && typeof value === 'string') {
                const inputs = document.querySelectorAll(`input[name="${name}"]`);
                inputs.forEach(input => {
                    if (input.type === 'radio' && input.value === value) {
                        input.checked = true;
                    }
                });
            }
        });
        
        // Đồng bộ price inputs
        const minInput = document.querySelector('input[name="minPrice"]');
        const maxInput = document.querySelector('input[name="maxPrice"]');
        if (minInput && activeFilters.minPrice) minInput.value = activeFilters.minPrice;
        if (maxInput && activeFilters.maxPrice) maxInput.value = activeFilters.maxPrice;
    }
    
    // ==================== FILTER DROPDOWNS ====================
    function initFilterDropdowns() {
    // Selector phải đúng
    const filterGroups = document.querySelectorAll('.filter-group.has-header');
    
    console.log('Found filter groups:', filterGroups.length); // Debug: kiểm tra số lượng
    
    filterGroups.forEach(group => {
        const header = group.querySelector('.filter-header');
        const content = group.querySelector('.filter-content');
        
        if (header && content) {
            // Xóa sự kiện cũ để tránh trùng
            const newHeader = header.cloneNode(true);
            header.parentNode.replaceChild(newHeader, header);
            
            newHeader.addEventListener('click', (e) => {
                e.stopPropagation();
                content.classList.toggle('open');
                newHeader.classList.toggle('open');
                console.log('Toggled:', content.classList.contains('open')); // Debug
            });
        }
    });
}
    
    // ==================== PRICE PRESETS ====================
    function initPricePresets() {
        const presetButtons = document.querySelectorAll('.price-preset');
        
        presetButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const minPrice = this.dataset.min;
                const maxPrice = this.dataset.max;
                
                const minInput = document.querySelector('input[name="minPrice"]');
                const maxInput = document.querySelector('input[name="maxPrice"]');
                
                if (minInput) minInput.value = minPrice || '';
                if (maxInput) maxInput.value = (maxPrice === '0' || maxPrice === '') ? '' : maxPrice;
                
                activeFilters.minPrice = minPrice || '';
                activeFilters.maxPrice = (maxPrice === '0' || maxPrice === '') ? '' : maxPrice;
                
                renderSelectedBadges();
                saveFilters();
            });
        });
    }
    
    // ==================== CẬP NHẬT FILTER KHI CHỌN ====================
    function updateFilterValue(name, value) {
        if (!value || value === '') {
            delete activeFilters[name];
        } else {
            activeFilters[name] = value;
        }
        renderSelectedBadges();
        saveFilters();
    }
    
    function updatePriceFilter() {
        const minInput = document.querySelector('input[name="minPrice"]');
        const maxInput = document.querySelector('input[name="maxPrice"]');
        
        activeFilters.minPrice = minInput?.value || '';
        activeFilters.maxPrice = maxInput?.value || '';
        
        renderSelectedBadges();
        saveFilters();
    }
    
    // ==================== RENDER SELECTED BADGES ====================
    function renderSelectedBadges() {
        let container = document.querySelector('.selected-filters');
        if (!container) {
            container = document.createElement('div');
            container.className = 'selected-filters';
            const filterSidebar = document.querySelector('.filter-sidebar');
            if (filterSidebar) {
                const title = filterSidebar.querySelector('.filter-title');
                if (title) {
                    filterSidebar.insertBefore(container, title.nextSibling);
                }
            }
        }
        
        let html = '';
        let hasFilters = false;
        
        // Giá
        if (activeFilters.minPrice || activeFilters.maxPrice) {
            const minText = activeFilters.minPrice ? formatPrice(activeFilters.minPrice) + 'đ' : '';
            const maxText = activeFilters.maxPrice ? formatPrice(activeFilters.maxPrice) + 'đ' : '';
            const text = minText && maxText ? `${minText} - ${maxText}` : (minText || maxText);
            html += `
                <div class="selected-badge" data-filter="price">
                    <i class="fas fa-tag"></i>
                    <span>💰 Giá: ${text}</span>
                    <button class="remove-badge" data-filter="price">×</button>
                </div>
            `;
            hasFilters = true;
        }
        
        // Giới tính
        if (activeFilters.gender) {
            html += `
                <div class="selected-badge" data-filter="gender">
                    <i class="fas fa-venus-mars"></i>
                    <span>👤 ${activeFilters.gender}</span>
                    <button class="remove-badge" data-filter="gender">×</button>
                </div>
            `;
            hasFilters = true;
        }
        
        // Chất liệu
        if (activeFilters.frameMaterial) {
            html += `
                <div class="selected-badge" data-filter="frameMaterial">
                    <i class="fas fa-microscope"></i>
                    <span>🔧 ${activeFilters.frameMaterial}</span>
                    <button class="remove-badge" data-filter="frameMaterial">×</button>
                </div>
            `;
            hasFilters = true;
        }
        
        // Thương hiệu
        if (activeFilters.brand) {
            html += `
                <div class="selected-badge" data-filter="brand">
                    <i class="fas fa-trademark"></i>
                    <span>🏷️ ${activeFilters.brand}</span>
                    <button class="remove-badge" data-filter="brand">×</button>
                </div>
            `;
            hasFilters = true;
        }
        
       
        
        container.innerHTML = html;
        container.style.display = hasFilters ? 'flex' : 'none';
        
        // Gắn sự kiện xóa badge
        document.querySelectorAll('.remove-badge').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                const filterName = this.dataset.filter;
                removeFilterValue(filterName);
            });
        });
        
        // Gắn sự kiện xóa tất cả
        const clearAllBtn = container.querySelector('.clear-all');
        if (clearAllBtn) {
            clearAllBtn.addEventListener('click', function() {
                clearAllFilters();
            });
        }
    }
    
    // ==================== XÓA FILTER ====================
    function removeFilterValue(filterName) {
        delete activeFilters[filterName];
        
        if (filterName === 'price') {
            const minInput = document.querySelector('input[name="minPrice"]');
            const maxInput = document.querySelector('input[name="maxPrice"]');
            if (minInput) minInput.value = '';
            if (maxInput) maxInput.value = '';
        } else {
            const inputs = document.querySelectorAll(`input[name="${filterName}"]`);
            inputs.forEach(input => {
                if (input.type === 'radio') {
                    input.checked = false;
                    const allOption = document.querySelector(`input[name="${filterName}"][value=""]`);
                    if (allOption) allOption.checked = true;
                }
            });
        }
        
        renderSelectedBadges();
        saveFilters();
    }
    
    // XÓA TẤT CẢ FILTER VÀ SUBMIT NGAY
function clearAllFiltersAndSubmit() {
    // Reset activeFilters
    activeFilters = {
        minPrice: '',
        maxPrice: '',
        gender: '',
        frameMaterial: '',
        brand: ''
    };
    
    // Reset tất cả input trên form
    document.querySelectorAll('.filter-option input[type="radio"]').forEach(input => {
        input.checked = (input.value === '');
    });
    
    document.querySelectorAll('.price-inputs input').forEach(input => {
        input.value = '';
    });
    
    // Xóa badge hiển thị
    renderSelectedBadges();
    saveFilters();
    
    // Submit form ngay lập tức
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        // Xóa các input filter cũ
        const existingInputs = filterForm.querySelectorAll('input.filter-data');
        existingInputs.forEach(input => input.remove());
        filterForm.submit();
    }
}
    
    // ==================== ÁP DỤNG FILTER (SUBMIT FORM) ====================
    function applyFilters() {
        const filterForm = document.getElementById('filterForm');
        if (!filterForm) {
            console.error('Filter form not found');
            return;
        }
        
        // Xóa các input filter cũ
        const existingInputs = filterForm.querySelectorAll('input.filter-data');
        existingInputs.forEach(input => input.remove());
        
        // Thêm các filter mới
        Object.entries(activeFilters).forEach(([key, value]) => {
            if (value && value !== '') {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = value;
                input.className = 'filter-data';
                filterForm.appendChild(input);
            }
        });
        
        console.log('Applying filters:', activeFilters);
        filterForm.submit();
    }
    
    // ==================== SẮP XẾP ====================
    function initSort() {
        const sortSelect = document.getElementById('sortSelect');
        const filterForm = document.getElementById('filterForm');
        
        if (sortSelect && filterForm) {
            let sortInput = document.getElementById('sortInput');
            if (!sortInput) {
                sortInput = document.createElement('input');
                sortInput.type = 'hidden';
                sortInput.name = 'sort';
                sortInput.id = 'sortInput';
                filterForm.appendChild(sortInput);
            }
            
            sortSelect.addEventListener('change', function() {
                sortInput.value = this.value;
                localStorage.setItem('selectedSort', this.value);
                filterForm.submit();
            });
            
            const savedSort = localStorage.getItem('selectedSort');
            if (savedSort && sortSelect.querySelector(`option[value="${savedSort}"]`)) {
                sortSelect.value = savedSort;
                sortInput.value = savedSort;
            }
        }
    }
    
    // ==================== PHÂN TRANG ====================
    function initPagination() {
        const filterForm = document.getElementById('filterForm');
        if (!filterForm) return;
        
        document.querySelectorAll('.page-link').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const page = this.dataset.page;
                if (page && !this.parentElement.classList.contains('disabled')) {
                    let pageInput = document.getElementById('pageInput');
                    if (!pageInput) {
                        pageInput = document.createElement('input');
                        pageInput.type = 'hidden';
                        pageInput.name = 'page';
                        pageInput.id = 'pageInput';
                        filterForm.appendChild(pageInput);
                    }
                    pageInput.value = page;
                    filterForm.submit();
                }
            });
        });
    }
    
    // ==================== GẮN SỰ KIỆN CHO RADIO ====================
    function bindFilterChangeEvents() {
        // Radio buttons
        document.querySelectorAll('.filter-content input[type="radio"]').forEach(radio => {
            // Xóa sự kiện cũ để tránh trùng lặp
            const newRadio = radio.cloneNode(true);
            radio.parentNode.replaceChild(newRadio, radio);
            
            newRadio.addEventListener('change', function() {
                if (this.checked) {
                    updateFilterValue(this.name, this.value);
                }
            });
        });
        
        // Price inputs
        const priceInputs = document.querySelectorAll('.price-inputs input');
        let priceTimeout;
        priceInputs.forEach(input => {
            // Xóa sự kiện cũ
            const newInput = input.cloneNode(true);
            input.parentNode.replaceChild(newInput, input);
            
            newInput.addEventListener('input', function() {
                clearTimeout(priceTimeout);
                priceTimeout = setTimeout(() => {
                    updatePriceFilter();
                }, 500);
            });
        });
    }
    
    // ==================== UTILITY FUNCTIONS ====================
    function formatPrice(price) {
        return parseInt(price).toLocaleString('vi-VN');
    }
    
    // ==================== EXPORT GLOBAL FUNCTIONS ====================
    // Export functions
window.applyFilters = applyFilters;
window.clearAllFiltersAndSubmit = clearAllFiltersAndSubmit;
    
})();