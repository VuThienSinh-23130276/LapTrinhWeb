<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Trang chủ</title>
</head>
<body>

	<h2>Xin chào, ${sessionScope.username}</h2>

	<h3>Danh sách sản phẩm</h3>

	<c:if test="${empty products}">
		<p>Hiện chưa có sản phẩm nào.</p>
	</c:if>

	<c:if test="${not empty products}">
		<ul>
			<c:forEach var="p" items="${products}">
				<li><b>${p.name}</b> - Giá: ${p.price} | <a
					href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
						Xem chi tiết </a></li>
			</c:forEach>
		</ul>
	</c:if>

</body>
</html>
