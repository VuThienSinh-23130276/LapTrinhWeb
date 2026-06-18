<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Xác thực chữ ký đơn hàng</title>
<style>
body {
	font-family: sans-serif;
	max-width: 600px;
	margin: 40px auto;
	padding: 20px;
}

textarea {
	width: 100%;
	height: 150px;
	margin: 10px 0;
}

.data-box {
	background: #f0f0f0;
	padding: 10px;
	border: 1px dashed #333;
	font-weight: bold;
}
</style>
</head>
<body>
	<h2>Ký số đơn hàng (Offline)</h2>

	<p>
		<b>Bước 1:</b> Copy chuỗi dữ liệu này vào Tool Offline để ký:
	</p>
	<div class="data-box">${sessionScope.lastOrderCode}|${sessionScope.totalPrice}</div>

	<form action="SignServlet" method="post">
		<input type="hidden" name="total" value="${sessionScope.totalPrice}">
		<p>
			<b>Bước 2:</b> Dán chữ ký nhận được từ Tool vào đây:
		</p>
		<textarea name="signature" required
			placeholder="Dán chữ ký Base64 ở đây..."></textarea>
		<br>
		<button type="submit" style="padding: 10px 20px;">Gửi chữ ký
			xác thực</button>
	</form>
</body>
</html>