<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Đăng ký tài khoản</title>
</head>
<body>

	<h2>Đăng ký tài khoản</h2>

	<form action="register" method="post">
		Username: <input type="text" name="username" required><br>
		<br> Password: <input type="password" name="password" required><br>
		<br> Họ tên: <input type="text" name="fullname" required><br>
		<br>
		<button type="submit">Đăng ký</button>
	</form>
	<!-- dang ky thanh cong -->
	<%
    String success = (String) request.getAttribute("success");
    if (success != null) {
    %>
    <p style="color: red; font-weight: bold;"><%= success %></p>
    <%
    }
    %>
    <!-- dang ky that bai -->
	<%
	String error = (String) request.getAttribute("error");
	if (error != null) {
	%>
	<p style="color: red;"><%=error%></p>
	<%
	}
	%>

	<p>
		Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
	</p>

</body>
</html>
