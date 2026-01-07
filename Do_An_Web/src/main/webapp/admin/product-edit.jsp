<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Sửa sản phẩm - Admin</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/base.css">
<style>
.admin-wrap {
	padding: 30px 0;
}

.form-group {
	margin-bottom: 15px;
}
</style>
</head>
<body>
	<jsp:include page="../layout/LayoutHeader.jsp" />

	<div class="container admin-wrap">
		<h2>Sửa sản phẩm</h2>

		<c:if test="${not empty success}">
			<div class="alert alert-success">${success}</div>
		</c:if>
		<c:if test="${not empty error}">
			<div class="alert alert-danger">${error}</div>
		</c:if>

		<c:if test="${not empty errors}">
			<div class="alert alert-danger">
				<ul style="margin: 0;">
					<c:forEach items="${errors}" var="err">
						<li>${err}</li>
					</c:forEach>
				</ul>
			</div>
		</c:if>

		<c:if test="${not empty product}">
			<form action="${pageContext.request.contextPath}/admin/products"
				method="post" enctype="multipart/form-data">
				<input type="hidden" name="action" value="update"> <input
					type="hidden" name="id" value="${product.id}">

				<div class="form-group">
					<label>Tên sản phẩm *</label> <input type="text" name="name"
						class="form-control" value="${product.name}" required>
				</div>

				<div class="form-group">
					<label>Giá (VNĐ) *</label> <input type="number" name="price"
						class="form-control" step="0.01" value="${product.price}" required>
				</div>

				<div class="form-group">
					<label>Loại</label> <select name="type" class="form-control">
						<option value="new" ${product.type == 'new' ? 'selected' : ''}>Sản
							phẩm mới</option>
						<option value="hot" ${product.type == 'hot' ? 'selected' : ''}>Sản
							phẩm hot</option>
						<option value="like" ${product.type == 'like' ? 'selected' : ''}>Có
							thể bạn thích</option>
					</select>
				</div>

				<div class="form-group">
					<label>Số lượng</label> <input type="number" name="quantity"
						class="form-control" value="${product.quantity}" min="0" required>
				</div>

				<div class="form-group">
					<label>Mô tả</label>
					<textarea name="description" class="form-control" rows="4">${product.description}</textarea>
				</div>

				<div class="form-group">
					<label>Ảnh hiện tại</label>
					<div>
						<img
							src="${pageContext.request.contextPath}/assets/imgProduct/images/${product.image}"
							alt="${product.name}"
							style="max-width: 200px; max-height: 200px;">

					</div>
				</div>

				<div class="form-group">
					<label>Thay đổi ảnh (tùy chọn)</label> <input type="file"
						name="image" class="form-control"
						accept="image/jpeg,image/png,image/jpg"> <small
						class="form-text text-muted">Chỉ chọn nếu muốn thay đổi
						ảnh. Định dạng: PNG/JPG, tối đa 2MB.</small>
				</div>

				<div class="form-group">
					<button type="submit" class="btn btn-primary">Cập nhật</button>
					<a href="${pageContext.request.contextPath}/admin/products"
						class="btn btn-secondary">Hủy</a>
				</div>
			</form>
		</c:if>
	</div>

	<jsp:include page="../layout/LayoutFooter.jsp" />
</body>
</html>
