// home.js - Xử lý tất cả chức năng trên trang chủ

(function() {
    'use strict';
    
    // ==================== KHỞI TẠO ====================
    document.addEventListener('DOMContentLoaded', function() {
        initSort();
        initPagination();
        initRadioFilters();
        initPriceFilters();
        initQuickLinks();
    });
    
    // ==================== SẮP XẾP ====================
    function initSort() {
        const sortSelect = document.getElementById('sortSelect');
        const filterForm = document.getElementById('filterForm');
        
        if (sortSelect && filterForm) {
            // Đảm bảo có input sort trong form
            let sortInput = document.getElementById('sortInput');
            if (!sortInput) {
                sortInput = document.createElement('input');
                sortInput.type = 'hidden';
                sortInput.name = 'sort';
                sortInput.id = 'sortInput';
                filterForm.appendChild(sortInput);
            }
            
            // Cập nhật giá trị sort khi select thay đổi
            sortSelect.addEventListener('change', function() {
                sortInput.value = this.value;
                filterForm.submit();
            });
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
    
    // ==================== BỘ LỌC RADIO ====================
    function initRadioFilters() {
        const filterForm = document.getElementById('filterForm');
        if (!filterForm) return;
        
        document.querySelectorAll('input[type="radio"]').forEach(radio => {
            radio.addEventListener('change', function() {
                filterForm.submit();
            });
        });
    }
    
    // ==================== BỘ LỌC GIÁ ====================
    function initPriceFilters() {
        const priceInputs = document.querySelectorAll('.price-inputs input');
        let timeout;
        
        priceInputs.forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    clearTimeout(timeout);
                    submitFilterForm();
                }
            });
            
            input.addEventListener('blur', function() {
                clearTimeout(timeout);
                timeout = setTimeout(() => submitFilterForm(), 500);
            });
        });
    }
    
    // ==================== QUICK LINKS ====================
    function initQuickLinks() {
        const quickLinks = document.querySelectorAll('.quick-link-item');
        const filterForm = document.getElementById('filterForm');
        
        quickLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const href = this.getAttribute('href');
                if (href && href !== '#') {
                    window.location.href = href;
                }
            });
        });
    }
    
    // ==================== XÓA BỘ LỌC ====================
    function clearFilters() {
        const filterForm = document.getElementById('filterForm');
        if (filterForm) {
            // Xóa tất cả input không phải submit
            const inputs = filterForm.querySelectorAll('input:not([type="submit"]), select');
            inputs.forEach(input => {
                if (input.type === 'radio' || input.type === 'checkbox') {
                    input.checked = false;
                } else if (input.tagName === 'SELECT') {
                    input.value = '';
                } else if (input.type === 'number' || input.type === 'text') {
                    input.value = '';
                }
            });
            
            // Thêm reset flag
            let resetInput = document.getElementById('resetFilter');
            if (!resetInput) {
                resetInput = document.createElement('input');
                resetInput.type = 'hidden';
                resetInput.name = 'reset';
                resetInput.id = 'resetFilter';
                resetInput.value = 'true';
                filterForm.appendChild(resetInput);
            } else {
                resetInput.value = 'true';
            }
            
            filterForm.submit();
        }
    }
    
    // ==================== SUBMIT FORM ====================
    function submitFilterForm() {
        const filterForm = document.getElementById('filterForm');
        if (filterForm) {
            filterForm.submit();
        }
    }
    
    // ==================== XEM THÊM SẢN PHẨM ====================
    function loadMoreProducts() {
        const currentPage = parseInt(document.getElementById('currentPage')?.value || 1);
        const totalPages = parseInt(document.getElementById('totalPages')?.value || 1);
        
        if (currentPage < totalPages) {
            const nextPage = currentPage + 1;
            const filterForm = document.getElementById('filterForm');
            
            let pageInput = document.getElementById('pageInput');
            if (!pageInput) {
                pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                pageInput.id = 'pageInput';
                filterForm.appendChild(pageInput);
            }
            pageInput.value = nextPage;
            filterForm.submit();
        }
    }
    
    // ==================== EXPORT GLOBAL FUNCTIONS ====================
    window.clearFilters = clearFilters;
    window.loadMoreProducts = loadMoreProducts;
    window.submitFilterForm = submitFilterForm;
    
})();