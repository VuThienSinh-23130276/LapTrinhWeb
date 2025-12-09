<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Chi tiết sản phẩm</title>
</head>
<body>

	<c:if test="${empty product}">
		<p>Không tìm thấy sản phẩm.</p>
		<a href="${pageContext.request.contextPath}/home">Quay lại trang
			chủ</a>
	</c:if>

	<c:if test="${not empty product}">
		<h2>${product.name}</h2>
		<p>Mã sản phẩm: ${product.id}</p>
		<p>Giá: ${product.price}</p>

		<!-- Nút thanh toán: gọi /checkout (GET) để hiện trang checkout -->
		<form action="${pageContext.request.contextPath}/checkout"
			method="get">
			<button type="submit">Thanh toán</button>
		</form>

		<br>
		<a href="${pageContext.request.contextPath}/home">Quay lại trang
			chủ</a>
	</c:if>

</body>
</html>
