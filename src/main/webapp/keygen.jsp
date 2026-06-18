<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý Khóa số</title>
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

.alert {
	padding: 10px;
	margin-bottom: 20px;
	border-radius: 4px;
}

.error {
	background: #f8d7da;
	color: #721c24;
}

.success {
	background: #d4edda;
	color: #155724;
}
</style>
</head>
<body>
	<h2>Quản lý Khóa số (PKI)</h2>

	<c:if test="${not empty error}">
		<div class="alert error">${error}</div>
	</c:if>
	<c:if test="${not empty message}">
		<div class="alert success">${message}</div>
	</c:if>

	<p>
		Sử dụng <b>Tool Offline</b> để sinh khóa. Sau đó dán Public Key của
		bạn vào ô dưới đây để đăng ký với hệ thống:
	</p>

	<form action="KeyManagementServlet" method="post">
		<input type="hidden" name="action" value="add">
		<textarea name="publicKey" required
			placeholder="-----BEGIN PUBLIC KEY----- ..."></textarea>
		<br>
		<button type="submit">Lưu Public Key</button>
	</form>

	<hr>

	<p>Nếu nghi ngờ bị lộ khóa, hãy thu hồi khóa cũ:</p>
	<form action="KeyManagementServlet" method="post">
		<input type="hidden" name="action" value="revoke">
		<button type="submit" style="background: #dc3545; color: white;">Thu
			hồi khóa hiện tại</button>
	</form>
</body>
</html>