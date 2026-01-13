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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">

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

      <c:if test="${not empty sessionScope.user}">
        <div class="alert alert-info" style="margin-bottom:14px;font-size:14px;">
          <i class="fas fa-user"></i> Đang đặt hàng với tài khoản: <b>${sessionScope.user.fullname}</b>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        <div class="form-group" style="margin-bottom:12px;">
          <label style="font-weight:700;">Họ tên <span style="color:red;">*</span></label>
          <input type="text" name="fullname" class="form-control" 
                 placeholder="Nhập họ tên" 
                 value="${not empty sessionScope.user.fullname ? sessionScope.user.fullname : ''}" 
                 required>
        </div>

        <div class="form-group" style="margin-bottom:12px;">
          <label style="font-weight:700;">Địa chỉ giao hàng <span style="color:red;">*</span></label>
          <input type="text" name="address" class="form-control" 
                 placeholder="Nhập địa chỉ giao hàng chi tiết" 
                 required>
        </div>

        <div class="form-group" style="margin-bottom:12px;">
          <label style="font-weight:700;">Số điện thoại <span style="color:red;">*</span></label>
          <input type="tel" name="phone" class="form-control" 
                 placeholder="Nhập số điện thoại (VD: 0325 556 718)" 
                 pattern="[0-9\s\-\+\(\)]+"
                 required>
        </div>

        <div class="form-group" style="margin-bottom:12px;">
          <label style="font-weight:700;">Email <span style="color:red;">*</span></label>
          <input type="email" name="email" class="form-control" 
                 placeholder="Nhập email để nhận hóa đơn (VD: example@gmail.com)" 
                 value="${not empty sessionScope.user.username && sessionScope.user.username.contains('@') ? sessionScope.user.username : ''}"
                 required>
          <small class="form-text text-muted">Chúng tôi sẽ gửi hóa đơn và thông tin đơn hàng đến email này</small>
        </div>

        <div class="form-group" style="margin-bottom:16px;">
          <label style="font-weight:700; margin-bottom:10px; display:block;">Phương thức thanh toán <span style="color:red;">*</span></label>
          <div style="display:flex; flex-direction:column; gap:10px;">
            <label style="display:flex; align-items:center; padding:12px; border:2px solid #e0e0e0; border-radius:8px; cursor:pointer; transition:all 0.2s;" 
                   onmouseover="this.style.borderColor='#111'; this.style.backgroundColor='#f9f9f9';" 
                   onmouseout="this.style.borderColor='#e0e0e0'; this.style.backgroundColor='transparent';">
              <input type="radio" name="paymentMethod" value="COD" checked required style="margin-right:10px; width:18px; height:18px; cursor:pointer;">
              <div>
                <strong style="display:block; margin-bottom:4px;">Thanh toán khi nhận hàng (COD)</strong>
                <small style="color:#666;">Bạn sẽ thanh toán khi nhận được hàng</small>
              </div>
            </label>
            <label style="display:flex; align-items:center; padding:12px; border:2px solid #e0e0e0; border-radius:8px; cursor:pointer; transition:all 0.2s;" 
                   onmouseover="this.style.borderColor='#111'; this.style.backgroundColor='#f9f9f9';" 
                   onmouseout="this.style.borderColor='#e0e0e0'; this.style.backgroundColor='transparent';">
              <input type="radio" name="paymentMethod" value="TRANSFER" required style="margin-right:10px; width:18px; height:18px; cursor:pointer;">
              <div>
                <strong style="display:block; margin-bottom:4px;">Chuyển khoản ngân hàng</strong>
                <small style="color:#666;">Thanh toán bằng QR code, đơn hàng sẽ được đánh dấu đã thanh toán</small>
              </div>
            </label>
          </div>
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
