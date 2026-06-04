<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Danh sách sản phẩm</title>

<link rel="stylesheet" href="./assets/css/bootstrap.css">
<link rel="stylesheet" href="./assets/css/base.css">
<link rel="stylesheet" href="./assets/css/main.css">

<style>
.list-wrap {
	padding: 30px 0;
}

.product-list {
	display: flex;
	gap: 20px;
	flex-wrap: wrap;
}

.product-card {
	width: 240px;
	border: 1px solid #e5e5e5;
	background: #fff;
}

.product-card img {
	width: 100%;
	height: 170px;
	object-fit: cover;
	display: block;
}

.product-card .body {
	padding: 12px;
}

.name {
	font-weight: 700;
	margin: 0 0 8px;
}

.price {
	color: #d0021b;
	font-weight: 800;
	margin: 0 0 10px;
}
</style>
</head>

<body>
	<jsp:include page="layout/LayoutHeader.jsp" />


	<div class="container list-wrap">
		<h4>
			Xin chào,
			<c:choose>
				<c:when test="${sessionScope.user != null}">
				${sessionScope.user.fullname}
			</c:when>
				<c:otherwise>Khách</c:otherwise>
			</c:choose>
		</h4>
		<h2>Danh sách sản phẩm</h2>

		<c:if test="${empty products}">
			<p>Chưa có sản phẩm.</p>
		</c:if>

		<div class="product-list">
			<c:forEach items="${products}" var="p">
				<div class="product-card">
					<a
						href="${pageContext.request.contextPath}/product-detail?id=${p.id}"
						style="text-decoration: none; color: inherit;">
						<c:choose>
							<c:when test="${not empty p.image and fn:startsWith(p.image, 'uploads/')}">
								<c:url value="/images/${p.image}" var="imgUrl" />
							</c:when>
							<c:otherwise>
								<c:url value="/assets/imgProduct/images/${p.image}" var="imgUrl" />
							</c:otherwise>
						</c:choose>
						<c:url value="/assets/img/product/noavatar.png" var="defaultImg" />
						<img src="${imgUrl}"
							onerror="this.onerror=null;this.src='${defaultImg}';"
							alt="${p.name}">


						<div class="body">
							<p class="name">${p.name}</p>
							<p class="price">${p.price}VNĐ</p>
						</div>
					</a>

					<div class="body" style="padding-top: 0;">
						<a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" 
						   class="btn btn-dark btn-sm">Xem chi tiết</a>
					</div>
				</div>
			</c:forEach>
		</div>

		<div style="margin-top: 20px;">
			<a href="${pageContext.request.contextPath}/cart">Xem giỏ hàng</a> |
			<a href="${pageContext.request.contextPath}/home">Về trang chủ</a>
		</div>
	</div>

	<jsp:include page="layout/LayoutFooter.jsp" />

</body>
</html>
