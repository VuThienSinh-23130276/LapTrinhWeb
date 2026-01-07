<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý sản phẩm - Admin</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/base.css">
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
		<h2>Quản lý sản phẩm</h2>

		<c:if test="${not empty success}">
			<div class="alert alert-success">${success}</div>
		</c:if>
		<c:if test="${not empty error}">
			<div class="alert alert-danger">${error}</div>
		</c:if>

		<div style="margin-bottom: 20px;">
			<a href="${pageContext.request.contextPath}/product-upload"
				class="btn btn-primary">Thêm sản phẩm mới</a> <a
				href="${pageContext.request.contextPath}/home"
				class="btn btn-secondary">Về trang chủ</a>
		</div>

		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th>ID</th>
					<th>Ảnh</th>
					<th>Tên sản phẩm</th>
					<th>Giá</th>
					<th>Loại</th>
					<th>Số lượng</th>
					<th>Thao tác</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${products}" var="p">
					<tr>
						<td>${p.id}</td>
						<td><img
							src="${pageContext.request.contextPath}/assets/imgProduct/images/${p.image}"
							alt="${p.name}"
							style="width: 60px; height: 60px; object-fit: cover;"> "></td>
						<td>${p.name}</td>
						<td>${p.price}VNĐ</td>
						<td>${p.type}</td>
						<td>${p.quantity}</td>
						<td><a
							href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}"
							class="btn btn-sm btn-warning">Sửa</a> <a
							href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}"
							class="btn btn-sm btn-danger"
							onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">Xóa</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<c:if test="${empty products}">
			<p class="text-muted">Chưa có sản phẩm nào.</p>
		</c:if>
	</div>

	<jsp:include page="../layout/LayoutFooter.jsp" />
</body>
</html>
