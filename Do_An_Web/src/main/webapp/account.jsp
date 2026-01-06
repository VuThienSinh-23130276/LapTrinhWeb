<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Thông tin tài khoản</title>
<style>
.box {
	max-width: 600px;
	margin: 30px auto;
	padding: 20px;
	border: 1px solid #eee;
	border-radius: 12px;
}

.row {
	display: flex;
	justify-content: space-between;
	padding: 10px 0;
	border-bottom: 1px solid #f2f2f2;
}

.row b {
	color: #666;
}
</style>
</head>
<body>
<jsp:include page="layout/LayoutHeader.jsp"/>


	<c:if test="${sessionScope.user == null}">
		<c:redirect url="login.jsp" />
	</c:if>

	<div class="box">
		<h2>Thông tin tài khoản</h2>

		<div class="row">
			<b>ID</b><span>${sessionScope.user.id}</span>
		</div>
		<div class="row">
			<b>Username</b><span>${sessionScope.user.username}</span>
		</div>
		<div class="row">
			<b>Fullname</b><span>${sessionScope.user.fullname}</span>
		</div>

		<%-- Theo yêu cầu "đầy đủ thuộc tính" nhưng password không nên show.
       Nếu thầy bắt phải đủ thì chỉ hiển thị mask: --%>
		<div class="row">
			<b>Password</b><span>********</span>
		</div>

		<br /> <a href="${pageContext.request.contextPath}/orders">Xem
			lịch sử mua hàng</a>
	</div>
	<jsp:include page="layout/LayoutFooter.jsp"/>

</body>
</html>
