# HƯỚNG DẪN TEST CHỨC NĂNG GỬI EMAIL

## 1. CẤU HÌNH SMTP

### Bước 1: Tạo App Password cho Gmail (nếu dùng Gmail)

1. Đăng nhập vào Gmail của bạn
2. Vào **Google Account** → **Security** (Bảo mật)
3. Bật **2-Step Verification** (Xác minh 2 bước) nếu chưa bật
4. Vào **App passwords** (Mật khẩu ứng dụng)
5. Chọn **Mail** và **Other (Custom name)** → đặt tên: "Do An Web"
6. Copy mật khẩu 16 ký tự được tạo (ví dụ: `abcd efgh ijkl mnop`)

### Bước 2: Cấu hình file mail.properties

Mở file: `src/main/webapp/WEB-INF/mail.properties`

Điền thông tin SMTP của bạn:

```properties
# SMTP Configuration
mail.host=smtp.gmail.com
mail.port=587
mail.username=your_email@gmail.com
mail.password=your_app_password_16_chars
mail.from=your_email@gmail.com
mail.tls=true
```

**Lưu ý:**
- `mail.username`: Email Gmail của bạn (ví dụ: `yourname@gmail.com`)
- `mail.password`: App Password 16 ký tự (bỏ khoảng trắng, ví dụ: `abcdefghijklmnop`)
- `mail.from`: Email người gửi (thường giống username)

### Bước 3: Thêm thư viện JavaMail

1. Tải file JAR: `javax.mail-1.6.2.jar` (hoặc phiên bản tương thích)
2. Copy vào thư mục: `src/main/webapp/WEB-INF/lib/`
3. Rebuild project

**Link tải:** https://mvnrepository.com/artifact/com.sun.mail/javax.mail

## 2. TEST CHỨC NĂNG GỬI EMAIL

### Cách 1: Test qua đặt hàng (Checkout)

1. **Đăng nhập** với tài khoản user (username phải là email hợp lệ)
   - Ví dụ: `test@example.com` / `123456`

2. **Thêm sản phẩm vào giỏ hàng**
   - Vào trang sản phẩm → Click "Thêm vào giỏ"

3. **Checkout**
   - Vào giỏ hàng → Click "Thanh toán"
   - Điền thông tin:
     - Họ tên: Người nhận
     - Địa chỉ: Địa chỉ giao hàng
   - Click "Xác nhận đặt hàng"

4. **Kiểm tra email**
   - Mở hộp thư của `test@example.com`
   - Kiểm tra email xác nhận đơn hàng
   - Nếu không thấy, kiểm tra thư mục **Spam**

### Cách 2: Kiểm tra log trong Console

Sau khi checkout, kiểm tra console của Tomcat/IDE:

- ✅ **Thành công:** `✅ Đã gửi email đơn hàng tới test@example.com`
- ❌ **Lỗi:** `❌ Không gửi được email: [chi tiết lỗi]`
- ⚠️ **Chưa cấu hình:** `⚠️ Mail config chưa đầy đủ. Bỏ qua gửi mail.`

## 3. XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi: "Authentication failed"

**Nguyên nhân:** App Password sai hoặc chưa bật 2-Step Verification

**Giải pháp:**
- Kiểm tra lại App Password (không có khoảng trắng)
- Đảm bảo đã bật 2-Step Verification

### Lỗi: "Could not connect to SMTP host"

**Nguyên nhân:** Cấu hình host/port sai hoặc firewall chặn

**Giải pháp:**
- Kiểm tra `mail.host` và `mail.port`
- Với Gmail: `smtp.gmail.com` / `587`
- Kiểm tra firewall/antivirus

### Lỗi: "javax.mail classes not found"

**Nguyên nhân:** Thiếu thư viện JavaMail

**Giải pháp:**
- Thêm `javax.mail.jar` vào `WEB-INF/lib`
- Rebuild project

### Không nhận được email

**Kiểm tra:**
1. Email có trong thư mục **Spam** không?
2. Username trong DB có đúng định dạng email không?
3. Console có báo lỗi gì không?
4. File `mail.properties` có đúng đường dẫn không?

## 4. TEST VỚI SMTP KHÁC (KHÔNG PHẢI GMAIL)

Nếu bạn dùng SMTP khác (Outlook, Yahoo, SMTP riêng...), cấu hình như sau:

### Outlook/Hotmail:
```properties
mail.host=smtp-mail.outlook.com
mail.port=587
mail.username=your_email@outlook.com
mail.password=your_password
mail.from=your_email@outlook.com
mail.tls=true
```

### Yahoo:
```properties
mail.host=smtp.mail.yahoo.com
mail.port=587
mail.username=your_email@yahoo.com
mail.password=your_app_password
mail.from=your_email@yahoo.com
mail.tls=true
```

## 5. LƯU Ý

- ⚠️ **Không commit file `mail.properties`** lên Git (chứa mật khẩu)
- ✅ Username trong bảng Users nên là email hợp lệ để nhận mail
- ✅ Nếu không cấu hình email, hệ thống vẫn hoạt động bình thường (chỉ không gửi mail)
- ✅ Email được gửi tự động sau khi checkout thành công

## 6. TEST NHANH

Để test nhanh mà không cần đặt hàng thật:

1. Mở file `src/main/java/util/MailUtil.java`
2. Thêm method test tạm thời (sau khi test xong thì xóa):

```java
public static void testEmail(ServletContext ctx) {
    Order testOrder = new Order();
    testOrder.setOrderCode("TEST-001");
    testOrder.setFullname("Test User");
    testOrder.setTotal(100000);
    testOrder.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
    
    List<CartItem> testItems = new ArrayList<>();
    // Thêm test items nếu cần
    
    sendOrderEmail(ctx, "your_test_email@gmail.com", testOrder, testItems, "Test address");
}
```

3. Gọi method này từ một servlet tạm thời để test.
