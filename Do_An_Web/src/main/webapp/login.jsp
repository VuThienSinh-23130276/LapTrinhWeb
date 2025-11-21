<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Login</title>
</head>
<body>
	<h2>Đăng nhập</h2>

	<form action="${pageContext.request.contextPath}/login" method="post">
		<label>Username:</label> <input type="text" name="username" required><br>
		<br> <label>Password:</label> <input type="password"
			name="password" required><br>
		<br>

		<button type="submit">Login</button>
	</form>

</body>
</html>
