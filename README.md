<div align="center">

#  TuKhanhHuy — Website Thương Mại Điện Tử Bán Kính Mắt

**Nền tảng mua sắm kính mắt trực tuyến hiện đại, tích hợp Chatbot AI thông minh**

![Java](https://img.shields.io/badge/Java-JDK%2017-orange)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1-yellow)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB)
![Flask](https://img.shields.io/badge/Flask-2.3.3-black)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.2-purple)
![License](https://img.shields.io/badge/License-MIT-green)

</div>

---

## 📑 Mục lục

- [Tổng quan dự án](#-tổng-quan-dự-án)
- [Mục tiêu](#-mục-tiêu)
- [Công nghệ sử dụng](-công-nghệ-sử-dụng)
- [Chức năng chính](#-chức-năng-chính)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Cài đặt và chạy dự án](#-cài-đặt-và-chạy-dự-án)
- [Cấu hình PayOS](#-cấu-hình-payos)
- [API Endpoints](#-api-endpoints)
- [Database Schema](#-database-schema)
- [Đối tượng sử dụng](#-đối-tượng-sử-dụng)
- [Kết quả đạt được](#-kết-quả-đạt-được)
- [Screenshots](#-screenshots)
- [Đóng góp](#-đóng-góp)
- [Giấy phép](#-giấy-phép)
- [Liên hệ](#-liên-hệ)

---

## 📌 Tổng quan dự án

**TuKhanhHuy** là một website thương mại điện tử chuyên bán kính mắt chính hãng, được xây dựng nhằm mang đến trải nghiệm mua sắm trực tuyến hiện đại, tiện lợi và thông minh. Hệ thống tích hợp đầy đủ các tính năng từ quản lý sản phẩm, giỏ hàng, đơn hàng, thanh toán đến đánh giá và hỗ trợ khách hàng bằng **Chatbot AI**.

---

## 🎯 Mục tiêu

| Mục tiêu | Mô tả |
|---|---|
| **Kinh doanh** | Xây dựng nền tảng bán kính mắt trực tuyến, tiếp cận khách hàng toàn quốc |
| **Trải nghiệm** | Mang đến giao diện thân thiện, dễ sử dụng, trải nghiệm mua sắm mượt mà |
| **Tự động hóa** | Tự động quy trình đặt hàng, thanh toán, xác nhận trạng thái đơn hàng |
| **Hỗ trợ khách hàng** | Tích hợp Chatbot AI hỗ trợ 24/7, giải đáp thắc mắc tức thì |
| **Quản trị** | Cung cấp công cụ quản lý toàn diện cho admin |

---

##  Công nghệ sử dụng

### Backend

| Công nghệ | Phiên bản | Vai trò |
|---|---|---|
| Java (Servlet/JSP) | JDK 17 | Xử lý request/response, MVC |
| JDBC | - | Kết nối MySQL |
| BCrypt | - | Mã hóa mật khẩu |
| Gson | 2.10.1 | Xử lý JSON |
| Java Mail API | - | Gửi email OTP |
| Apache Tomcat | 10.1 | Web server |

### Frontend

| Công nghệ | Phiên bản | Vai trò |
|---|---|---|
| HTML5 / CSS3 | - | Cấu trúc và định dạng giao diện |
| Bootstrap | 5.3.2 | Framework CSS responsive |
| JavaScript (ES6) | - | Xử lý logic, tương tác người dùng |
| AJAX / Fetch API | - | Gọi API bất đồng bộ |
| Cropper.js | 1.5.13 | Cắt ảnh đại diện |
| Chart.js | - | Biểu đồ thống kê |

### Database

| Công nghệ | Phiên bản | Vai trò |
|---|---|---|
| MySQL | 8.0 | Hệ quản trị CSDL |
| MySQL Workbench | 8.0 | Công cụ quản lý |

### Chatbot AI (Python — Deploy trên Render)

| Công nghệ | Phiên bản | Vai trò |
|---|---|---|
| Python | 3.10+ | Ngôn ngữ lập trình |
| Flask | 2.3.3 | Framework REST API |
| Sentence-Transformers | 2.2.2 | NLP embeddings |
| Hugging Face | - | Model BERT đa ngôn ngữ |
| Model | `paraphrase-multilingual-MiniLM-L12-v2` | Embedding model (420MB) |
| RAG | - | Retrieval-Augmented Generation |
| ChromaDB | 0.4.22 | Vector database |
| Render.com | - | Triển khai API |

### Thanh toán

| Công nghệ | Vai trò |
|---|---|
| PayOS API | Tạo link thanh toán VietQR |
| Webhook | Tự động cập nhật trạng thái đơn hàng |

---

## Chức năng chính

### 👤 Khách hàng (User)

| STT | Chức năng | Mô tả |
|---|---|---|
| 1 | Đăng ký / Đăng nhập | Tạo tài khoản, đăng nhập hệ thống |
| 2 | Quên mật khẩu | Nhận OTP qua email để đặt lại mật khẩu |
| 3 | Quản lý hồ sơ | Cập nhật thông tin, avatar, đổi mật khẩu |
| 4 | Quản lý địa chỉ | Thêm, sửa, xóa, đặt địa chỉ mặc định |
| 5 | Xem sản phẩm | Danh sách, chi tiết, thông số kỹ thuật |
| 6 | Tìm kiếm | Theo tên, thương hiệu |
| 7 | Lọc sản phẩm | Theo giá, giới tính, chất liệu, thương hiệu |
| 8 | Sắp xếp | Mới nhất, giá tăng/giảm, bán chạy, đánh giá |
| 9 | Giỏ hàng | Thêm, sửa số lượng, xóa (AJAX) |
| 10 | Đặt hàng | Từ giỏ hàng hoặc mua ngay |
| 11 | Thanh toán | COD hoặc PayOS (VietQR) |
| 12 | Theo dõi đơn hàng | Xem trạng thái, chi tiết đơn hàng |
| 13 | Đánh giá sản phẩm | Sao, bình luận, upload ảnh |

### 🔧 Quản trị viên (Admin)

| STT | Chức năng | Mô tả |
|---|---|---|
| 1 | Dashboard | Thống kê doanh thu, đơn hàng, sản phẩm bán chạy |
| 2 | Quản lý sản phẩm | Thêm, sửa, xóa, ẩn/hiện, upload ảnh |
| 3 | Quản lý danh mục | Thêm, sửa, xóa danh mục |
| 4 | Quản lý đơn hàng | Xem, cập nhật trạng thái, xác nhận thanh toán |
| 5 | Quản lý người dùng | Xem, khóa/mở khóa, nâng cấp quyền admin |
| 6 | Quản lý đánh giá | Xem, trả lời, xóa đánh giá |
| 7 | Xuất báo cáo | Excel |

### 🤖 Chatbot AI

| STT | Chức năng | Mô tả |
|---|---|---|
| 1 | Hỗ trợ 24/7 | Trả lời tự động mọi lúc |
| 2 | Tìm kiếm sản phẩm | Bằng ngôn ngữ tự nhiên |
| 3 | Tư vấn sản phẩm | Theo khuôn mặt, giới tính, chất liệu |
| 4 | Tra cứu giá | Trả lời câu hỏi về giá |
| 5 | Chính sách | Bảo hành, đổi trả, vận chuyển |

---

## 📁 Cấu trúc dự án

```
BanKinhThoiTrang/
├── web/
│   ├── WEB-INF/
│   │   ├── includes/
│   │   │   ├── header.jsp          # Header chung
│   │   │   ├── footer.jsp          # Footer chung
│   │   │   └── chatbot.jsp         # Chatbot widget
│   │   ├── web.xml                 # Cấu hình servlet
│   │   └── lib/                    # JAR files
│   │       ├── payos-java-1.0.3.jar
│   │       ├── gson-2.10.1.jar
│   │       ├── jackson-databind-2.15.2.jar
│   │       └── ...
│   ├── css/
│   │   ├── style.css               # Style chính
│   │   ├── responsive.css          # Responsive
│   │   └── chatbot.css             # Chatbot style
│   ├── js/
│   │   ├── home.js                 # Trang chủ
│   │   ├── giohangcount.js         # Giỏ hàng
│   │   ├── chatbot.js              # Chatbot
│   │   └── responsive.js           # Responsive menu
│   ├── jsp/
│   │   ├── admin/
│   │   │   ├── dashboard.jsp       # Admin Dashboard
│   │   │   ├── products.jsp        # Quản lý sản phẩm
│   │   │   ├── orders.jsp          # Quản lý đơn hàng
│   │   │   └── users.jsp           # Quản lý người dùng
│   │   └── public/
│   │       ├── home.jsp            # Trang chủ
│   │       ├── product-detail.jsp  # Chi tiết sản phẩm
│   │       ├── cart.jsp            # Giỏ hàng
│   │       ├── checkout.jsp        # Thanh toán
│   │       ├── orders.jsp          # Đơn hàng của tôi
│   │       ├── profile.jsp         # Hồ sơ cá nhân
│   │       ├── login.jsp           # Đăng nhập
│   │       └── register.jsp        # Đăng ký
│   └── image/
│       └── anhdanhmuc/             # Ảnh sản phẩm
│           ├── no-image.png
│           └── ...
└── src/
    └── java/
        ├── config/
        │   └── PayOSConfig.java    # Cấu hình PayOS
        ├── servlet/
        │   ├── HomeServlet.java
        │   ├── ProductServlet.java
        │   ├── CartServlet.java
        │   ├── CheckoutServlet.java
        │   ├── OrderServlet.java
        │   ├── ProfileServlet.java
        │   ├── ReviewServlet.java
        │   ├── PaymentServlet.java
        │   ├── PayOSWebhookServlet.java
        │   └── admin/
        │       ├── AdminProductServlet.java
        │       ├── AdminOrderServlet.java
        │       └── AdminUserServlet.java
        ├── model/
        │   ├── User.java
        │   ├── Product.java
        │   ├── Order.java
        │   ├── Cart.java
        │   └── Review.java
        └── DAO/
            ├── UserDAO.java
            ├── ProductDAO.java
            ├── OrderDAO.java
            ├── CartDAO.java
            └── ReviewDAO.java
```

**Chatbot API (Python — dự án riêng biệt):**

```
chatbot-api/
├── app.py                         # Flask app
├── requirements.txt               # Thư viện Python
├── vector_store.py                # Vector database
├── knowledge_base.py              # Knowledge base
├── data/
│   └── knowledge.txt              # Kiến thức chatbot
└── chroma_db/                     # ChromaDB storage
```

---

##  Cài đặt và chạy dự án

### Yêu cầu hệ thống

| Thành phần | Yêu cầu tối thiểu |
|---|---|
| Java | JDK 17+ |
| Tomcat | 10.1+ |
| MySQL | 8.0+ |
| Python | 3.10+ (cho chatbot) |
| RAM | 4GB+ |
| OS | Windows / Linux / macOS |

### 1. Cài đặt Web Application

```bash
# Clone dự án
git clone https://github.com/your-username/BanKinhThoiTrang.git
cd BanKinhThoiTrang

# 2. Import vào IDE (NetBeans/IntelliJ/Eclipse)

# 3. Tạo database
mysql -u root -p < database.sql

# 4. Cấu hình kết nối database
# Sửa file: src/java/util/DBConnect.java
# Cập nhật URL, username, password

# 5. Build và Deploy lên Tomcat
# Copy file WAR vào webapps/ hoặc deploy qua IDE
```

### 2. Cài đặt Chatbot AI

```bash
# 1. Di chuyển vào thư mục chatbot-api
cd chatbot-api

# 2. Tạo môi trường ảo
python -m venv venv

# 3. Kích hoạt môi trường
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# 4. Cài đặt thư viện
pip install -r requirements.txt

# 5. Cấu hình database trong .env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=BanKinhThoiTrang

# 6. Chạy Chatbot API
python app.py
```

---

## 💳 Cấu hình PayOS

Tạo file `src/main/resources/payos.properties`:

```properties
PAYOS_CLIENT_ID=your-client-id
PAYOS_API_KEY=your-api-key
PAYOS_CHECKSUM_KEY=your-checksum-key
```

> Đăng ký tại [payos.vn](https://payos.vn) để lấy thông tin.

---

## 🔗 API Endpoints

### Web Application (Java)

| Endpoint | Method | Mô tả |
|---|---|---|
| `/home` | GET | Trang chủ |
| `/product?id={id}` | GET | Chi tiết sản phẩm |
| `/search` | GET | Tìm kiếm |
| `/cart` | GET/POST | Giỏ hàng |
| `/checkout` | GET/POST | Thanh toán |
| `/orders` | GET | Đơn hàng của tôi |
| `/profile` | GET/POST | Hồ sơ |
| `/review` | GET/POST | Đánh giá |
| `/payment` | POST | Tạo link PayOS |
| `/webhook/payos` | POST | Webhook thanh toán |
| `/admin/*` | GET/POST | Quản trị |

### Chatbot API (Python)

| Endpoint | Method | Mô tả |
|---|---|---|
| `/api/chat` | POST | Gửi tin nhắn, nhận phản hồi |
| `/api/health` | GET | Kiểm tra trạng thái |

---

## 📊 Database Schema

```sql
-- Bảng chính
users           -- Người dùng
addresses       -- Địa chỉ giao hàng
categories      -- Danh mục sản phẩm
products        -- Sản phẩm
carts           -- Giỏ hàng
cart_items      -- Chi tiết giỏ hàng
orders          -- Đơn hàng
order_details   -- Chi tiết đơn hàng
reviews         -- Đánh giá
review_replies  -- Phản hồi đánh giá
```

> Xem chi tiết đầy đủ tại: [`database.sql`](./database.sql)

---

## 👥 Đối tượng sử dụng

| Đối tượng | Mô tả |
|---|---|
| **Khách hàng (User)** | Người dùng cuối mua sắm sản phẩm |
| **Quản trị viên (Admin)** | Quản lý sản phẩm, đơn hàng, người dùng |
| **Khách vãng lai (Guest)** | Xem sản phẩm, đăng ký/đăng nhập để mua hàng |

---

## 🎯 Kết quả đạt được

- ✅ Website hoạt động ổn định, giao diện responsive
- ✅ Tích hợp Chatbot AI thông minh, hỗ trợ 24/7
- ✅ Thanh toán PayOS với webhook tự động *(cập nhật sau)*
- ✅ Phân quyền người dùng rõ ràng, bảo mật tốt
- ✅ Tối ưu trải nghiệm với AJAX, localStorage

---

## 📸 Screenshots

| Trang | Mô tả |
|---|---|
| Trang chủ | Banner, danh mục, sản phẩm nổi bật |
| Chi tiết sản phẩm | Ảnh, thông số, đánh giá |
| Giỏ hàng | Danh sách sản phẩm, cập nhật số lượng |
| Thanh toán | Chọn địa chỉ, phương thức thanh toán |
| Admin Dashboard | Thống kê doanh thu, đơn hàng |
| Chatbot | Giao diện chat AI hỗ trợ |
---

## 🤝 Đóng góp

Mọi đóng góp đều được hoan nghênh! Để đóng góp:

1. Fork dự án
2. Tạo nhánh tính năng mới (`git checkout -b feature/ten-tinh-nang`)
3. Commit thay đổi (`git commit -m 'Thêm tính năng ABC'`)
4. Push lên nhánh (`git push origin feature/ten-tinh-nang`)
5. Mở một Pull Request

---

<div align="center">

**⭐ Nếu thấy dự án hữu ích, hãy để lại một Star nhé! ⭐**

</div>
