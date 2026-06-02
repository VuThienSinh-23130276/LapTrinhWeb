<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng sản phẩm</title>
<link rel="stylesheet" href="./assets/css/bootstrap.css">
<link rel="stylesheet" href="./assets/css/base.css">
<style>
.upload-wrap {
	padding: 30px 0;
}
.card {
	border: 1px solid #e5e5e5;
	padding: 20px;
	border-radius: 8px;
	background: #fff;
	max-width: 720px;
	margin: 0 auto;
}
.form-group {
	margin-bottom: 14px;
}
</style>
</head>
<body>
<jsp:include page="layout/LayoutHeader.jsp"/>

	<div class="container upload-wrap">
		<h2>Đăng sản phẩm mới</h2>

		<c:if test="${not empty errors}">
			<div class="alert alert-danger" role="alert">
				<ul style="margin: 0; padding-left: 18px;">
					<c:forEach items="${errors}" var="err">
						<li>${err}</li>
					</c:forEach>
				</ul>
			</div>
		</c:if>

		<c:if test="${not empty success}">
			<div class="alert alert-success" role="alert">${success}</div>
		</c:if>

		<div class="card">
			<form action="${pageContext.request.contextPath}/product-upload"
				method="post" enctype="multipart/form-data">

				<div class="form-group">
					<label>Tên sản phẩm</label> <input class="form-control"
						name="name" required>
				</div>

				<div class="form-group">
					<label>Giá (VNĐ)</label> <input class="form-control" name="price"
						type="number" min="1000" step="1000" required>
				</div>

				<div class="form-group">
					<label>Số lượng</label> <input class="form-control" name="quantity"
						type="number" min="0" step="1" required>
				</div>

				<div class="form-group">
					<label>Loại (new/hot/like)</label> <input class="form-control"
						name="type" placeholder="new">
				</div>

				<div class="form-group">
					<label>Mô tả</label>
					<textarea class="form-control" rows="4" name="description"></textarea>
				</div>

				<div class="form-group">
					<label>Ảnh sản phẩm (PNG/JPG &lt;= 2MB)</label> <input
						class="form-control" type="file" name="image" accept="image/*"
						required>
				</div>

				<button class="btn btn-dark" type="submit">Đăng sản phẩm</button>
				<a class="btn btn-link" href="${pageContext.request.contextPath}/home">Về
					trang chủ</a>
			</form>
		</div>

		<c:if test="${not empty product}">
			<hr>
			<h4>Xem nhanh</h4>
			<p>
				<b>${product.name}</b> - ${product.price} VNĐ
			</p>
			<img style="max-width: 240px; border: 1px solid #eee; padding: 4px"
				src="${pageContext.request.contextPath}/images/${product.image}"
				onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/product/noavatar.png';"
				alt="${product.name}">
		</c:if>
	</div>

	<jsp:include page="layout/LayoutFooter.jsp" />
</body>
</html>
