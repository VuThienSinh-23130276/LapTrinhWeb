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
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">

<style>
.admin-wrap {
	padding: 30px 0;
}
.table {
	background: #fff;
	vertical-align: middle;
}

.badge-custom {
	padding: 6px 10px;
	border-radius: 6px;
	font-size: 13px;
	font-weight: bold;
	display: inline-block;
}
.badge-valid { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.badge-invalid { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
.badge-unsigned { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
</style>
</head>
<body>
	<jsp:include page="../layout/LayoutHeader.jsp" />

	<div class="container admin-wrap" style="max-width: 1200px;">
		<h2>Quản lý đơn hàng (Admin)</h2>

		<div style="margin-bottom: 20px;">
			<a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">← Về trang chủ</a>
		</div>

		<table class="table table-bordered table-striped">
			<thead class="thead-light">
				<tr>
					<th>Mã đơn</th>
					<th>Người đặt</th>
					<th>Username</th>
					<th>Thanh toán</th>
					<th>Trạng thái GD</th>
					<th>Tổng tiền</th>
					<th>Ngày đặt</th>
					<th>Xác thực chữ ký <i class="fas fa-shield-alt" style="color: #666;"></i></th>
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
									<span style="color: #666;">Tiền mặt (COD)</span>
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
						<td style="font-weight: bold;"><fmt:formatNumber value="${o.total}" type="number" maxFractionDigits="0" /> VNĐ</td>
						<td>
							<fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
						</td>
						
						<td style="text-align: center;">
							<c:choose>
								<c:when test="${o.verifyStatus == 'VALID'}">
									<div class="badge-custom badge-valid" title="Dữ liệu toàn vẹn, chữ ký hợp lệ">
										<i class="fas fa-check-circle"></i> Hợp lệ
									</div>
								</c:when>
								<c:when test="${o.verifyStatus == 'INVALID'}">
									<div class="badge-custom badge-invalid" title="CẢNH BÁO: Dữ liệu đơn hàng đã bị thay đổi!">
										<i class="fas fa-exclamation-triangle"></i> Bị can thiệp
									</div>
								</c:when>
								<c:otherwise>
									<div class="badge-custom badge-unsigned" title="Đơn hàng chưa có chữ ký số">
										<i class="fas fa-info-circle"></i> Chưa ký
									</div>
								</c:otherwise>
							</c:choose>
						</td>
						
						<td>
							<a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.id}"
								class="btn btn-sm btn-info">Chi tiết</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<c:if test="${empty ordersMap}">
			<div class="alert alert-warning">Chưa có đơn hàng nào trong hệ thống.</div>
		</c:if>
	</div>

	<jsp:include page="../layout/LayoutFooter.jsp" />
</body>
</html>