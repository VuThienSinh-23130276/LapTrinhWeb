<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Giỏ hàng</title>
</head>
<body>

	<h2>Giỏ hàng</h2>

	<c:if test="${empty cartItems}">
		<p>Giỏ hàng đang trống.</p>
	</c:if>

	<c:if test="${not empty cartItems}">
		<table border="1" cellpadding="5">
			<tr>
				<th>Tên sản phẩm</th>
				<th>Giá</th>
				<th>Số lượng</th>
				<th>Thành tiền</th>
				<th>Thao tác</th>
			</tr>
			<c:forEach var="item" items="${cartItems}">
				<tr>
					<td>${item.product.name}</td>
					<td>${item.product.price}</td>
					<td>${item.quantity}</td>
					<td>${item.subTotal}</td>
					<td>
						<form action="${pageContext.request.contextPath}/cart"
							method="post">
							<input type="hidden" name="action" value="remove" /> <input
								type="hidden" name="id" value="${item.product.id}" />
							<button type="submit">Xoá</button>
						</form>
					</td>
				</tr>
			</c:forEach>
		</table>

		<h3>Tổng tiền: ${total}</h3>

		<br>
		<a href="${pageContext.request.contextPath}/products">Tiếp tục mua</a>
		<form action="${pageContext.request.contextPath}/checkout"
			method="get" style="display: inline;">
			<button type="submit">Thanh toán</button>
			
			
			
						
		</form>
	</c:if>

</body>
</html>
