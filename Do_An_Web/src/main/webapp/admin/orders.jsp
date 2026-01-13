<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý đơn hàng - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<style>
.admin-wrap {
	padding: 30px 0;
}
.table {
	background: #fff;
}
</style>
</head>
<body>
	<jsp:include page="../layout/LayoutHeader.jsp" />

	<div class="container admin-wrap">
		<h2>Quản lý đơn hàng</h2>

		<div style="margin-bottom: 20px;">
			<a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Về trang chủ</a>
		</div>

		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th>Mã đơn</th>
					<th>Người đặt</th>
					<th>Username</th>
					<th>Phương thức thanh toán</th>
					<th>Trạng thái thanh toán</th>
					<th>Tổng tiền</th>
					<th>Ngày đặt</th>
					<th>Thao tác</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${ordersMap}" var="entry">
					<c:set var="o" value="${entry.key}" />
					<c:set var="username" value="${entry.value}" />
					<tr>
						<td><strong>${o.orderCode}</strong></td>
						<td>${o.fullname}</td>
						<td><span style="color: #666;">${username}</span></td>
						<td>
							<c:choose>
								<c:when test="${o.paymentMethod == 'COD'}">
									<span style="color: #666;">Thanh toán khi nhận hàng</span>
								</c:when>
								<c:when test="${o.paymentMethod == 'TRANSFER'}">
									<span style="color: #0066cc;">Chuyển khoản</span>
								</c:when>
								<c:otherwise>
									<span style="color: #666;">${o.paymentMethod}</span>
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${o.paid}">
									<span style="color: #28a745; font-weight: 700;">✓ Đã thanh toán</span>
								</c:when>
								<c:otherwise>
									<span style="color: #dc3545; font-weight: 700;">✗ Chưa thanh toán</span>
								</c:otherwise>
							</c:choose>
						</td>
						<td><fmt:formatNumber value="${o.total}" type="number" maxFractionDigits="0" />VNĐ</td>
						<td>
							<fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.id}"
								class="btn btn-sm btn-info">Xem chi tiết</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<c:if test="${empty ordersMap}">
			<p class="text-muted">Chưa có đơn hàng nào.</p>
		</c:if>
	</div>

	<jsp:include page="../layout/LayoutFooter.jsp" />
</body>
</html>
