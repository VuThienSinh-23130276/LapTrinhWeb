# ĐỒ ÁN WEB - SHOP QUẦN ÁO

## MÔ TẢ

Website bán quần áo với các chức năng:
- Đăng ký/Đăng nhập
- Xem sản phẩm (mới, hot, có thể bạn thích)
- Thêm vào giỏ hàng
- Đặt hàng và thanh toán
- Xem lịch sử đơn hàng
- **Admin:** Quản lý sản phẩm (thêm/sửa/xóa)
- **Admin:** Quản lý đơn hàng
- Gửi email xác nhận đơn hàng

## YÊU CẦU HỆ THỐNG

- **Java:** JDK 8 trở lên
- **Server:** Apache Tomcat 9.0 trở lên
- **Database:** SQL Server 2012 trở lên
- **IDE:** Eclipse/NetBeans/IntelliJ IDEA (tùy chọn)

## CÀI ĐẶT

### Bước 1: Tạo Database

1. Mở **SQL Server Management Studio (SSMS)**
2. Mở file `schema.sql` trong project
3. Chạy toàn bộ script SQL
4. Kiểm tra database `ShopQuanAo` đã được tạo

**Lưu ý:** Nếu SQL Server của bạn dùng password khác, sửa lại trong file `schema.sql`:
```sql
CREATE LOGIN app_user WITH PASSWORD = 'YourPasswordHere';
```

Và cập nhật trong file `src/main/java/connect/DBConnect.java`:
```java
String user = "app_user";
String pass = "YourPasswordHere";
```

### Bước 2: Cấu hình Database Connection

Mở file: `src/main/java/connect/DBConnect.java`

Kiểm tra và sửa nếu cần:
```java
String url = "jdbc:sqlserver://localhost:1433;databaseName=ShopQuanAo;encrypt=false;";
String user = "app_user";
String pass = "App@123"; // Hoặc password bạn đã đặt
```

**Nếu dùng SQL Server Express:**
```java
String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=ShopQuanAo;encrypt=false;";
```

### Bước 3: Thêm Thư Viện (Nếu thiếu)

Đảm bảo các file JAR sau có trong `src/main/webapp/WEB-INF/lib/`:
- `mssql-jdbc-13.2.1.jre11.jar` (hoặc phiên bản tương thích)
- `jstl.jar`
- `standard.jar`
- `javax.mail-1.6.2.jar` (cho chức năng gửi email)

**Tải JavaMail:** https://mvnrepository.com/artifact/com.sun.mail/javax.mail

### Bước 4: Cấu hình Email (Tùy chọn)

Xem file `HUONG_DAN_TEST_EMAIL.md` để cấu hình SMTP.

Nếu không cấu hình email, hệ thống vẫn hoạt động bình thường (chỉ không gửi email xác nhận).

### Bước 5: Deploy và Chạy

#### Cách 1: Deploy lên Tomcat thủ công

1. Build project thành file WAR
2. Copy WAR vào thư mục `webapps` của Tomcat
3. Khởi động Tomcat
4. Truy cập: `http://localhost:8080/Do_An_Web/`

#### Cách 2: Chạy từ IDE

1. Import project vào Eclipse/NetBeans/IntelliJ
2. Cấu hình Tomcat server
3. Run on Server

## TÀI KHOẢN MẪU

Sau khi chạy `schema.sql`, bạn có các tài khoản:

### Admin:
- **Username:** `admin`
- **Password:** `admin123`
- **Quyền:** Quản lý sản phẩm và đơn hàng

### User:
- **Username:** `test@example.com`
- **Password:** `123456`
- **Quyền:** Mua hàng thông thường

## CẤU TRÚC PROJECT

```
Do_An_Web/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── connect/          # Kết nối database
│   │   │   ├── controller/        # Các servlet
│   │   │   ├── DAO/              # Data Access Object
│   │   │   ├── model/            # Các model class
│   │   │   └── util/             # Utilities (MailUtil)
│   │   └── webapp/
│   │       ├── admin/            # Trang admin
│   │       ├── assets/           # CSS, JS, images
│   │       ├── layout/           # Layout chung
│   │       └── *.jsp             # Các trang JSP
├── schema.sql                    # Script tạo database
├── HUONG_DAN_TEST_EMAIL.md      # Hướng dẫn test email
└── README.md                     # File này
```

## CÁC TÍNH NĂNG CHÍNH

### User:
- ✅ Đăng ký/Đăng nhập
- ✅ Xem danh sách sản phẩm
- ✅ Xem chi tiết sản phẩm
- ✅ Thêm vào giỏ hàng
- ✅ Xem giỏ hàng
- ✅ Đặt hàng
- ✅ Xem lịch sử đơn hàng
- ✅ Upload sản phẩm (nếu là admin)

### Admin:
- ✅ Quản lý sản phẩm (thêm/sửa/xóa)
- ✅ Quản lý đơn hàng (xem danh sách, chi tiết)
- ✅ Xem thông tin người đặt hàng

## TROUBLESHOOTING

### Lỗi kết nối database:
- Kiểm tra SQL Server đã chạy chưa
- Kiểm tra username/password trong `DBConnect.java`
- Kiểm tra port 1433 có mở không

### Lỗi không hiển thị sản phẩm:
- Kiểm tra database có dữ liệu chưa (chạy lại `schema.sql`)
- Kiểm tra đường dẫn ảnh trong bảng Products

### Lỗi gửi email:
- Xem file `HUONG_DAN_TEST_EMAIL.md`
- Kiểm tra file `mail.properties` đã cấu hình đúng chưa
- Kiểm tra thư mục Spam

## LIÊN HỆ

Nếu có vấn đề, vui lòng kiểm tra:
1. Console log của Tomcat
2. File log trong thư mục `logs` của Tomcat
3. Database connection string

## LICENSE

Đồ án học tập - Không sử dụng thương mại.
