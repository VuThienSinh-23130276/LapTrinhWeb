<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>     
<head>
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>

	<h2>Đăng nhập</h2>

	<% if (request.getAttribute("error") != null) { %>
	<p style="color: red;"><%= request.getAttribute("error") %></p>
	<% } %>

	<form action="login" method="post">
		<label>Username:</label><br> <input type="text" name="username"
			required><br>
		<br> <label>Password:</label><br> <input type="password"
			name="password" required><br>
		<br>

		<button type="submit">Login</button>
	</form>

	<br>

	<!-- NÚT ĐĂNG KÝ -->
	<a href="register.jsp">Chưa có tài khoản? Đăng ký ngay</a>

</body>
</html>