<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Giỏ hàng</title>
<style>
table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px
}

th, td {
	border: 1px solid #ccc;
	padding: 10px;
	text-align: center
}

th {
	background: #f2f2f2
}

img {
	max-width: 80px
}

.total {
	font-size: 18px;
	font-weight: bold;
	text-align: right;
	margin-top: 20px
}

.actions {
	margin-top: 20px;
	display: flex;
	justify-content: space-between;
	align-items: center
}

button {
	padding: 6px 12px;
	cursor: pointer
}

.qtybox {
	display: flex;
	gap: 6px;
	justify-content: center;
	align-items: center
}

.qtybtn {
	width: 36px
}
</style>
</head>
<body>
<jsp:include page="layout/LayoutHeader.jsp"/>


	<h1>Giỏ hàng</h1>

	<c:choose>
		<c:when test="${empty cartItems}">
			<p>Giỏ hàng đang trống.</p>
			<a href="${pageContext.request.contextPath}/products">← Tiếp tục
				mua sắm</a>
		</c:when>

		<c:otherwise>
			<table>
				<thead>
					<tr>
						<th>Hình ảnh</th>
						<th>Tên sản phẩm</th>
						<th>Giá</th>
						<th>Số lượng</th>
						<th>Thành tiền</th>
						<th>Thao tác</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="item" items="${cartItems}">
						<tr>
							<td><img src="${item.product.image}"
								alt="${item.product.name}"></td>
							<td>${item.product.name}</td>
							<td><fmt:formatNumber value="${item.product.price}"
									type="number" /> VNĐ</td>

							<td>
								<div class="qtybox">
									<!-- - -->
									<form action="${pageContext.request.contextPath}/cart"
										method="post" style="margin: 0;">
										<input type="hidden" name="action" value="dec"> <input
											type="hidden" name="id" value="${item.product.id}">
										<button class="qtybtn" type="submit">-</button>
									</form>

									<strong>${item.quantity}</strong>

									<!-- + -->
									<form action="${pageContext.request.contextPath}/cart"
										method="post" style="margin: 0;">
										<input type="hidden" name="action" value="inc"> <input
											type="hidden" name="id" value="${item.product.id}">
										<button class="qtybtn" type="submit">+</button>
									</form>

									<!-- update nhập số -->
									<form action="${pageContext.request.contextPath}/cart"
										method="post"
										style="display: flex; gap: 6px; align-items: center; margin: 0;">
										<input type="hidden" name="action" value="update"> <input
											type="hidden" name="id" value="${item.product.id}"> <input
											type="number" name="qty" min="1" value="${item.quantity}"
											style="width: 70px;">
										<button type="submit">Cập nhật</button>
									</form>
								</div>
							</td>

							<td><fmt:formatNumber value="${item.subTotal}" type="number" />
								VNĐ</td>

							<td>
								<form action="${pageContext.request.contextPath}/cart"
									method="post" style="margin: 0;">
									<input type="hidden" name="action" value="remove"> <input
										type="hidden" name="id" value="${item.product.id}">
									<button type="submit">Xoá</button>
								</form>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<div class="total">
				Tổng tiền:
				<fmt:formatNumber value="${total}" type="number" />
				VNĐ
			</div>

			<div class="actions">
				<a href="${pageContext.request.contextPath}/products">← Tiếp tục
					mua sắm</a> <a href="${pageContext.request.contextPath}/checkout"><button>Thanh
						toán</button></a>
			</div>
		</c:otherwise>
	</c:choose>
	<jsp:include page="layout/LayoutFooter.jsp"/>

</body>
</html>
