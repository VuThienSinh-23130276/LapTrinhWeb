<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Danh sách sản phẩm</title>
</head>
<body>

	<h3>Xin chào, ${sessionScope.username}</h3>

	<h2>Danh sách sản phẩm</h2>

	<table border="1" cellpadding="5">
		<tr>
			<th>ID</th>
			<th>Tên</th>
			<th>Giá</th>
			<th>Thao tác</th>
		</tr>
		<c:forEach var="p" items="${products}">
			<tr>
				<td>${p.id}</td>
				<td>${p.name}</td>
				<td>${p.price}</td>
				<td>
					<form action="${pageContext.request.contextPath}/cart"
						method="post">
						<input type="hidden" name="action" value="add" /> <input
							type="hidden" name="id" value="${p.id}" />
						<button type="submit">Thêm vào giỏ</button>
					</form>
				</td>
			</tr>
		</c:forEach>
	</table>

	<br>
	<a href="${pageContext.request.contextPath}/cart">Xem giỏ hàng</a>

</body>
</html>
