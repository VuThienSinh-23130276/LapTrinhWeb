<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Hoàn tất</title>
</head>
<body>
 <jsp:include page="layout/LayoutHeader.jsp"/>


	<h2>Đặt hàng thành công!</h2>
	<p>Cảm ơn bạn đã mua hàng.</p>

	<c:if test="${not empty sessionScope.lastOrderCode}">
		<p>
			<b>Mã đơn hàng:</b> ${sessionScope.lastOrderCode}
		</p>
		<c:remove var="lastOrderCode" scope="session" />
	</c:if>

	<a href="${pageContext.request.contextPath}/products">Tiếp tục mua
		sắm</a>
	<br />
	<br />
	<a href="${pageContext.request.contextPath}/orders">Xem lịch sử mua
		hàng</a>

	<jsp:include page="layout/LayoutFooter.jsp" />
</body>
</html>
