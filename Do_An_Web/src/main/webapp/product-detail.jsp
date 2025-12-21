<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết sản phẩm</title>

<link rel="stylesheet" href="./assets/css/bootstrap.css">
<link rel="stylesheet" href="./assets/css/base.css">
<link rel="stylesheet" href="./assets/css/main.css">

<style>
.detail-wrap {
	padding: 30px 0;
}

.detail-card {
	border: 1px solid #e5e5e5;
	background: #fff;
	padding: 20px;
}

.detail-img {
	width: 100%;
	max-width: 420px;
	height: 320px;
	object-fit: cover;
	border: 1px solid #eee;
}

.price {
	color: #d0021b;
	font-weight: 800;
	font-size: 20px;
}

.desc {
	margin-top: 10px;
	color: #444;
}

.actions {
	margin-top: 16px;
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
}
</style>
</head>

<body>

	<div class="container detail-wrap">

		<c:if test="${empty product}">
			<div class="alert alert-warning">Không tìm thấy sản phẩm.</div>
			<a class="btn btn-dark"
				href="${pageContext.request.contextPath}/home">Quay lại trang
				chủ</a>
		</c:if>

		<c:if test="${not empty product}">
			<div class="detail-card row">
				<div class="col-md-5">
					<img class="detail-img" src="images/${product.image}"
						onerror="this.onerror=null;this.src='images/product-default.png';"
						alt="${product.name}">
				</div>

				<div class="col-md-7">
					<h3>${product.name}</h3>
					<div class="price">${product.price}VNĐ</div>

					<div class="desc">
						<c:out value="${product.description}" />
					</div>

					<div class="actions">
						<form action="${pageContext.request.contextPath}/cart"
							method="post" style="margin: 0;">
							<input type="hidden" name="action" value="add" /> <input
								type="hidden" name="id" value="${product.id}" />
							<button type="submit" class="btn btn-dark">Thêm vào giỏ</button>
						</form>

						<a class="btn btn-outline-dark"
							href="${pageContext.request.contextPath}/cart">Xem giỏ hàng</a>

						<form action="${pageContext.request.contextPath}/checkout"
							method="get" style="margin: 0;">
							<button type="submit" class="btn btn-success">Thanh toán</button>
						</form>

						<a class="btn btn-link"
							href="${pageContext.request.contextPath}/home">Quay lại trang
							chủ</a>
					</div>
				</div>
			</div>
		</c:if>

	</div>

	<jsp:include page="layout/LayoutFooter.jsp" />

</body>
</html>
