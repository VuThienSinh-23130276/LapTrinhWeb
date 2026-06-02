<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Thông tin tài khoản</title>
<style>
.box {
	max-width: 600px;
	margin: 30px auto;
	padding: 20px;
	border: 1px solid #eee;
	border-radius: 12px;
}

.row {
	display: flex;
	justify-content: space-between;
	padding: 10px 0;
	border-bottom: 1px solid #f2f2f2;
}

.row b {
	color: #666;
}

/* Style bổ sung cho khu vực RSA */
.rsa-section {
	margin-top: 25px;
	padding: 15px;
	background-color: #f9f9f9;
	border-radius: 8px;
	border: 1px dashed #ccc;
}

.btn-rsa {
	background-color: #ff4d4f;
	color: white;
	border: none;
	padding: 10px 15px;
	border-radius: 6px;
	cursor: pointer;
	font-weight: bold;
	width: 100%;
	margin-top: 10px;
}

.btn-rsa:hover {
	background-color: #ff7875;
}

.status-msg {
	margin-top: 10px;
	font-size: 14px;
	font-weight: bold;
	text-align: center;
}
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jsencrypt/3.3.2/jsencrypt.min.js"></script>
</head>
<body>
<jsp:include page="layout/LayoutHeader.jsp"/>


	<c:if test="${sessionScope.user == null}">
		<c:redirect url="login.jsp" />
	</c:if>

	<div class="box">
		<h2>Thông tin tài khoản</h2>

		<div class="row">
			<b>ID</b><span>${sessionScope.user.id}</span>
		</div>
		<div class="row">
			<b>Username</b><span>${sessionScope.user.username}</span>
		</div>
		<div class="row">
			<b>Fullname</b><span>${sessionScope.user.fullname}</span>
		</div>

		<div class="row">
			<b>Password</b><span>********</span>
		</div>

		<div class="rsa-section">
			<h3>Quản lý Chữ ký điện tử (RSA)</h3>
			<p style="font-size: 13px; color: #888; margin: 5px 0;">
				* Nếu bạn bị mất Khóa bí mật (Private Key) hoặc đổi thiết bị, hãy nhấn nút bên dưới để hủy khóa cũ và nhận lại cặp khóa bảo mật mới.
			</p>
			
			<button type="button" class="btn-rsa" onclick="handleReissueKey()">
				⚠️ Cấp lại Khóa ký mới
			</button>
			
			<div id="statusMessage" class="status-msg"></div>
		</div>
		<br /> 
		<a href="${pageContext.request.contextPath}/orders">Xem lịch sử mua hàng</a>
	</div>
	
	<jsp:include page="layout/LayoutFooter.jsp"/>

<script>
function handleReissueKey() {
    const confirmAction = confirm("Bạn có chắc chắn muốn hủy khóa cũ và cấp lại cặp khóa RSA mới không? Khóa cũ sẽ không thể sử dụng để đặt hàng nữa.");
    if (!confirmAction) return;

    const statusDiv = document.getElementById("statusMessage");
    statusDiv.style.color = "#333";
    statusDiv.innerText = "Đang khởi tạo cặp khóa 2048-bit (Vui lòng đợi)...";

    // Sử dụng setTimeout để giao diện kịp cập nhật dòng chữ thông báo trước khi trình duyệt chạy tác vụ nặng
    setTimeout(() => {
        try {
            // 1. Khởi tạo thuật toán RSA độ dài khóa 2048-bit
            const crypt = new JSEncrypt({ default_key_size: 2048 });
            
            // Tiến hành sinh Key
            const privateKey = crypt.getPrivateKey();
            const publicKey = crypt.getPublicKey();

            // 2. Tự động tải file Private Key (.pem) về máy tính cá nhân của User
            const blob = new Blob([privateKey], { type: "text/plain;charset=utf-8" });
            const downloadLink = document.createElement("a");
            downloadLink.href = URL.createObjectURL(blob);
            downloadLink.download = "private_key_user_${sessionScope.user.id}.pem";
            downloadLink.click();

            // 3. Sử dụng Ajax (Fetch API) để gửi Public Key mới lên Servlet xử lý dữ liệu
            fetch('${pageContext.request.contextPath}/KeyController?action=reissue', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'publicKey=' + encodeURIComponent(publicKey)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    statusDiv.style.color = "#52c41a";
                    statusDiv.innerText = "🎉 Cấp khóa mới thành công! Hãy kiểm tra file thư mục Download của bạn.";
                    alert("Cấp lại khóa thành công!\n\nHệ thống đã tải xuống file 'private_key_user_${sessionScope.user.id}.pem'. Hãy lưu trữ thật kỹ file này để thực hiện ký khi mua hàng.");
                } else {
                    statusDiv.style.color = "#ff4d4f";
                    statusDiv.innerText = "Lỗi từ hệ thống: " + data.message;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                statusDiv.style.color = "#ff4d4f";
                statusDiv.innerText = "Lỗi kết nối đến Server!";
            });

        } catch (err) {
            console.error(err);
            statusDiv.style.color = "#ff4d4f";
            statusDiv.innerText = "Có lỗi xảy ra trong quá trình sinh khóa.";
        }
    }, 200);
}
</script>
</body>
</html>