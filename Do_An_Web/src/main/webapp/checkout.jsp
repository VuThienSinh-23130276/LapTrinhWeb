<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Checkout</title>

  <!-- CSS đồng bộ với các trang khác -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

  <style>
    .checkout-wrap{ padding: 28px 0 50px; }
    .checkout-card{
      background:#fff;
      border:1px solid #eee;
      border-radius:14px;
      box-shadow:0 10px 25px rgba(0,0,0,.06);
      padding:22px;
      max-width:720px;
      margin:0 auto;
    }
    .checkout-title{
      font-size:26px;
      font-weight:800;
      margin-bottom:16px;
    }
    .checkout-actions{
      display:flex;
      gap:10px;
      flex-wrap:wrap;
      margin-top:14px;
    }
  </style>
</head>
<body>

  <!-- include tuyệt đối để khỏi lỗi path -->
  <jsp:include page="/layout/LayoutHeader.jsp"/>

  <div class="container checkout-wrap">

    <div class="checkout-card">
      <div class="checkout-title">Thông tin thanh toán</div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger" style="margin-bottom:14px;">
          <b>${error}</b>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div class="form-group" style="margin-bottom:12px;">
          <label style="font-weight:700;">Họ tên</label>
          <input type="text" name="fullname" class="form-control" placeholder="Nhập họ tên" required>
        </div>

        <div class="form-group" style="margin-bottom:12px;">
          <label style="font-weight:700;">Địa chỉ</label>
          <input type="text" name="address" class="form-control" placeholder="Nhập địa chỉ giao hàng" required>
        </div>

        <div class="checkout-actions">
          <button type="submit" class="btn btn-dark">Xác nhận đặt hàng</button>
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/cart">Quay lại giỏ hàng</a>
        </div>
      </form>
    </div>

  </div>

  <jsp:include page="/layout/LayoutFooter.jsp" />
</body>
</html>
