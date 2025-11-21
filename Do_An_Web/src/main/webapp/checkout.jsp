<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Checkout</title>
</head>
<body>

	<h2>Thông tin thanh toán</h2>

	<form action="${pageContext.request.contextPath}/checkout"
		method="post">
		<label>Họ tên:</label> <input type="text" name="fullname" required><br>
		<br> <label>Địa chỉ:</label> <input type="text" name="address"
			required><br>
		<br>

		<button type="submit">Xác nhận đặt hàng</button>
	</form>

</body>
</html>
