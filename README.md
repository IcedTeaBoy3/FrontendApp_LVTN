## 📁 Project Structure

│
├── assets/                   # Chứa các tài nguyên tĩnh như hình ảnh, biểu tượng, dữ liệu JSON,...

├── lib/

│   ├── configs/               # Chứa các tệp cấu hình hệ thống (API base URL, keys, routes,…)

│   ├── models/                # Định nghĩa các lớp mô hình dữ liệu (User, Doctor, Appointment, Service,…)

│   ├── providers/             # Quản lý trạng thái ứng dụng sử dụng Provider

│   ├── routes/                # Định nghĩa và quản lý điều hướng (Routing) giữa các màn hình

│   ├── screens/               # Các màn hình chính của ứng dụng (Trang chủ, Đặt lịch, Hồ sơ, Chatbot,…)

│   ├── services/              # Xử lý giao tiếp với backend thông qua API (Node.js/Express)

│   ├── themes/                # Cấu hình giao diện chung: màu sắc, font chữ, kích thước, phong cách hiển thị

│   ├── utils/                 # Các hàm tiện ích dùng chung (định dạng ngày giờ, xử lý chuỗi, chuyển đổi dữ liệu,…)

│   ├── widgets/               # Các widget tái sử dụng (nút, thẻ thông tin, dialog, toast,…)

│   └── main.dart              # Điểm khởi đầu của ứng dụng (khởi tạo Provider, MaterialApp, và routes chính)

└── pubspec.yaml               # Tệp cấu hình quản lý package, asset và thông tin dự án
