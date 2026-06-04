<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="DAO.KeyDAO"%>
<%@ page import="model.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    KeyDAO keyDAO = new KeyDAO();
    String activePublicKey = keyDAO.getActivePublicKey(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Chữ ký số - RSA Key Management</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jsencrypt/3.3.2/jsencrypt.min.js"></script>
</head>
<body class="bg-light">

	<div class="container my-5">
		<div class="card shadow-sm">
			<div class="card-header bg-dark text-white text-center">
				<h3>🔑 TRUNG TÂM QUẢN LÝ CẶP KHÓA RSA 2048-BIT</h3>
				<p class="mb-0">
					Tài khoản: <strong><%= user.getFullname() %></strong>
				</p>
			</div>
			<div class="card-body">

				<%-- Thông báo phản hồi từ hệ thống --%>
				<% if (request.getAttribute("message") != null) { %>
				<div class="alert alert-success"><%= request.getAttribute("message") %></div>
				<% } %>
				<% if (request.getAttribute("error") != null) { %>
				<div class="alert alert-danger"><%= request.getAttribute("error") %></div>
				<% } %>

				<%-- TRẠNG THÁI KHÓA HIỆN TẠI --%>
				<div
					class="alert <%= (activePublicKey != null) ? "alert-info" : "alert-warning" %>">
					<h5>Trạng thái hệ thống:</h5>
					<% if (activePublicKey != null) { %>
					<p class="mb-0">
						🟢 Bạn đang có <strong>01 Khóa công khai</strong> đang ở trạng
						thái <strong>ACTIVE</strong>.
					</p>
					<% } else { %>
					<p class="mb-0">🔴 Tài khoản chưa cấu hình chữ ký số hoặc khóa
						đã bị thu hồi. Bạn không thể thanh toán đơn hàng.</p>
					<% } %>
				</div>

				<div class="row mt-4">
					<%-- CỘT BÊN TRÁI: SINH KHÓA MỚI --%>
					<div class="col-md-6 border-right">
						<h4 class="text-primary">🛠️ Sinh Cặp Khóa Mới</h4>
						<p class="text-muted small">Quá trình sinh cặp khóa diễn ra
							tại máy của bạn. Private Key không gửi lên Server.</p>

						<button type="button" class="btn btn-success btn-block my-3"
							id="btnGenerate"
							<%= (activePublicKey != null) ? "disabled" : "" %>>✨ Tạo
							Cặp Khóa RSA 2048-Bit</button>

						<div class="form-group">
							<label>Khóa bí mật (Private Key - Lưu file .pem):</label>
							<textarea id="txtPrivateKey" class="form-control" rows="5"
								readonly placeholder="Khóa mật của bạn sẽ xuất hiện ở đây..."></textarea>
							<button type="button"
								class="btn btn-outline-secondary btn-sm btn-block mt-2"
								id="btnDownload" disabled>📥 Tải file Private_Key.pem
								về máy</button>
						</div>

						<form action="KeyManagementServlet" method="POST" id="formSaveKey">
							<input type="hidden" name="action" value="add">
							<div class="form-group">
								<label>Khóa công khai (Public Key - Gửi lên Server):</label>
								<textarea id="txtPublicKey" name="publicKey"
									class="form-control" rows="4" readonly
									placeholder="Khóa công khai sẽ tự động trích xuất..."></textarea>
							</div>
							<button type="submit" class="btn btn-primary btn-block"
								id="btnSave" disabled>💾 Lưu và Kích hoạt Khóa công
								khai lên Server</button>
						</form>
					</div>

					<%-- CỘT BÊN PHẢI: THU HỒI / HUỶ KHÓA --%>
					<div class="col-md-6">
						<h4 class="text-danger">⚠️ Thu Hồi (Revoke) Khóa Hiện Tại</h4>
						<p class="text-muted small">Nếu bạn nghi ngờ lộ khóa mật hoặc
							muốn đổi khóa mới, hãy thực hiện thu hồi ngay lập tức.</p>

						<% if (activePublicKey != null) { %>
						<div class="form-group mt-3">
							<label>Chuỗi Khóa công khai đang hoạt động trên hệ thống:</label>
							<textarea class="form-control" rows="8" readonly class="bg-white"><%= activePublicKey %></textarea>
						</div>
						<form action="KeyManagementServlet" method="POST"
							onsubmit="return confirm('CẢNH BÁO: Hành động này không thể hoàn tác. Bạn chắc chắn muốn thu hồi khóa này chứ?');">
							<input type="hidden" name="action" value="revoke">
							<button type="submit" class="btn btn-danger btn-block">
								❌ Thu Hồi (Revoke) Khóa Này Ngay</button>
						</form>
						<% } else { %>
						<div class="text-center p-5 text-muted">
							<h5>Không có khóa nào đang hoạt động để thu hồi.</h5>
						</div>
						<% } %>
					</div>
				</div>

				<div class="text-center mt-4">
					<a href="home" class="btn btn-link">◀️ Quay về trang chủ cửa
						hàng</a>
				</div>

			</div>
		</div>
	</div>

	<script>
// Logic JavaScript sinh cặp khóa RSA bằng thư viện JSEncrypt
document.getElementById("btnGenerate").addEventListener("click", function() {
    this.innerText = "🔄 Đang tính toán sinh khóa 2048-bit...";
    this.disabled = true;

    setTimeout(() => {
        try {
            var crypt = new JSEncrypt({default_key_size: 2048});
            crypt.getKey();

            var privKey = crypt.getPrivateKey();
            var pubKey = crypt.getPublicKey();

            document.getElementById("txtPrivateKey").value = privKey;
            document.getElementById("txtPublicKey").value = pubKey;

            // Kích hoạt các nút tương tác
            document.getElementById("btnDownload").disabled = false;
            document.getElementById("btnSave").disabled = false;
            
            this.innerText = "✨ Tạo Cặp Khóa RSA 2048-Bit";
            this.disabled = false;
            alert("Đã tạo cặp khóa thành công! Hãy tải file Private Key về máy trước khi bấm lưu.");
        } catch(err) {
            alert("Lỗi sinh khóa: " + err);
            this.disabled = false;
        }
    }, 200);
});

// Hàm hỗ trợ người dùng download Private Key thành file vật lý đuôi .pem
document.getElementById("btnDownload").addEventListener("click", function() {
    var privKeyContent = document.getElementById("txtPrivateKey").value;
    if(!privKeyContent) return;

    var blob = new Blob([privKeyContent], { type: "text/plain;charset=utf-8" });
    var link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "Private_Key.pem";
    link.click();
    URL.revokeObjectURL(link.href);
});
</script>

</body>
</html>