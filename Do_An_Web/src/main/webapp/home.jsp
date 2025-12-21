<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Trang chủ</title>

<link rel="stylesheet" href="./assets/css/bootstrap.css">
<link rel="stylesheet" href="./assets/css/base.css">
<link rel="stylesheet" href="./assets/css/main.css">

<style>
.home-wrap {
	padding: 30px 0 10px;
}

.category-menu {
	display: flex;
	gap: 28px;
	font-size: 20px;
	font-weight: 600;
	margin: 0 0 22px 0;
}

.category-menu a {
	color: #111;
	text-decoration: none;
	padding-bottom: 6px;
}

.category-menu a.active {
	border-bottom: 3px solid #111;
}

.product-list {
	display: flex;
	gap: 20px;
	flex-wrap: wrap;
	margin-bottom: 40px;
}

.product-card {
	width: 240px;
	border: 1px solid #e5e5e5;
	background: #fff;
}

.product-card a {
	text-decoration: none;
	color: inherit;
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

.product-card .name {
	font-size: 16px;
	font-weight: 700;
	margin: 0 0 8px;
}

.product-card .price {
	color: #d0021b;
	font-weight: 700;
	margin: 0;
}

.empty-note {
	padding: 14px 0;
	color: #666;
}
</style>
</head>

<body>

	<div class="container home-wrap">

		<div class="category-menu">
			<a href="home?type=new" class="${type == 'new' ? 'active' : ''}">Sản
				phẩm mới</a> <a href="home?type=hot"
				class="${type == 'hot' ? 'active' : ''}">Sản phẩm hot</a> <a
				href="home?type=like" class="${type == 'like' ? 'active' : ''}">Có
				thể bạn thích</a>
		</div>

		<c:if test="${empty products}">
			<div class="empty-note">Chưa có sản phẩm cho mục này. (Kiểm tra
				dữ liệu bảng Products và cột type = '${type}')</div>
		</c:if>

		<div class="product-list">
			<c:forEach items="${products}" var="p">
				<div class="product-card">
					<a href="product-detail?id=${p.id}"> <img
						src="images/${p.image}"
						onerror="this.onerror=null;this.src='images/product-default.png';"
						alt="${p.name}">
						<div class="body">
							<p class="name">${p.name}</p>
							<p class="price">${p.price}VNĐ</p>
						</div>
					</a>
				</div>
			</c:forEach>
		</div>

	</div>

	<jsp:include page="layout/LayoutFooter.jsp" />

</body>
</html>
