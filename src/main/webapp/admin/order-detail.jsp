<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết đơn hàng - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<style>
.admin-wrap {
	padding: 30px 0;
}
.order-info {
	background: #f8f9fa;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 20px;
}
.table {
	background: #fff;
}
</style>
</head>
<body>
	<jsp:include page="../layout/LayoutHeader.jsp" />
	

	<div class="container admin-wrap">
		<h2>Chi tiết đơn hàng</h2>

		<c:if test="${not empty order}">
			<div class="order-info">
				<h4>Thông tin đơn hàng</h4>
				<p><strong>Mã đơn:</strong> ${order.orderCode}</p>
				<p><strong>Người đặt:</strong> ${order.fullname}</p>
				<p><strong>Địa chỉ giao hàng:</strong> ${order.address}</p>
				<p><strong>Số điện thoại:</strong> ${order.phone}</p>
				<p><strong>Email:</strong> ${order.email}</p>
				<p><strong>Phương thức thanh toán:</strong> 
					<c:choose>
						<c:when test="${order.paymentMethod == 'COD'}">
							<span style="color: #666;">Thanh toán khi nhận hàng</span>
						</c:when>
						<c:when test="${order.paymentMethod == 'TRANSFER'}">
							<span style="color: #0066cc;">Chuyển khoản</span>
						</c:when>
						<c:otherwise>
							<span style="color: #666;">${order.paymentMethod}</span>
						</c:otherwise>
					</c:choose>
				</p>
				<p><strong>Trạng thái thanh toán:</strong> 
					<c:choose>
						<c:when test="${order.paid}">
							<span style="color: #28a745; font-weight: 700; font-size: 16px;">✓ Đã thanh toán</span>
						</c:when>
						<c:otherwise>
							<span style="color: #dc3545; font-weight: 700; font-size: 16px;">✗ Chưa thanh toán</span>
						</c:otherwise>
					</c:choose>
				</p>
				<p><strong>Ngày đặt:</strong>
					<fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
				</p>
				<p><strong>Tổng tiền:</strong> <span style="color: #d0021b; font-size: 18px; font-weight: bold;">
						<fmt:formatNumber value="${order.total}" type="number" maxFractionDigits="0" />VNĐ
					</span></p>
			</div>

			<h4>Danh sách sản phẩm</h4>
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>Tên sản phẩm</th>
						<th>Giá</th>
						<th>Số lượng</th>
						<th>Thành tiền</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${items}" var="item">
						<tr>
							<td>${item.productName}</td>
							<td><fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0" />VNĐ</td>
							<td>${item.quantity}</td>
							<td><fmt:formatNumber value="${item.subtotal}" type="number" maxFractionDigits="0" />VNĐ</td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="3" style="text-align: right;">Tổng cộng:</th>
						<th style="color: #d0021b;">
							<fmt:formatNumber value="${order.total}" type="number" maxFractionDigits="0" />VNĐ
						</th>
					</tr>
				</tfoot>
			</table>
		</c:if>

		<div style="margin-top: 20px;">
			<a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">Quay lại danh sách</a>
		</div>
	</div>

	<jsp:include page="../layout/LayoutFooter.jsp" />
</body>
</html>
