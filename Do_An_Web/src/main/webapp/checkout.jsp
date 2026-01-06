<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Checkout</title>
</head>
<body>
<jsp:include page="layout/LayoutHeader.jsp"/>


	<h2>Thông tin thanh toán</h2>

	<c:if test="${not empty error}">
		<p style="color: red;">
			<b>${error}</b>
		</p>
	</c:if>

	<form action="${pageContext.request.contextPath}/checkout"
		method="post">
		<label>Họ tên:</label> <input type="text" name="fullname" required><br>
		<br> <label>Địa chỉ:</label> <input type="text" name="address"
			required><br>
		<br>

		<button type="submit">Xác nhận đặt hàng</button>
	</form>

	<jsp:include page="layout/LayoutFooter.jsp" />
</body>
</html>
