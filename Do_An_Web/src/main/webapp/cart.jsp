<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Giỏ hàng</title>

  <!-- CSS đồng bộ -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

  <style>
    .cart-wrap{ padding: 24px 0 50px; }
    .cart-title{ font-size: 34px; font-weight: 900; margin: 10px 0 18px; }
    .cart-card{
      background:#fff;
      border:1px solid #eee;
      border-radius:14px;
      box-shadow:0 10px 25px rgba(0,0,0,.06);
      padding:16px;
    }
    .cart-img{
      width:84px;height:84px;object-fit:cover;border-radius:10px;
      border:1px solid #eee;
      background:#fafafa;
    }
    .qtybox{
      display:flex;
      gap:8px;
      align-items:center;
      justify-content:center;
      flex-wrap:wrap;
    }
    .qtybtn{
      width:38px;
      height:34px;
      padding:0;
      display:inline-flex;
      align-items:center;
      justify-content:center;
    }
    .qtyinput{
      width:80px;
      height:34px;
    }
    .cart-summary{
      margin-top:14px;
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:12px;
      flex-wrap:wrap;
    }
    .total{
      font-size:20px;
      font-weight:900;
    }
  </style>
</head>

<body>
  <!-- include tuyệt đối cho chắc -->
  <jsp:include page="/layout/LayoutHeader.jsp"/>

  <div class="container cart-wrap">
    <div class="cart-title">Giỏ hàng</div>

    <c:choose>
      <c:when test="${empty cartItems}">
        <div class="cart-card">
          <p class="text-muted" style="margin:0;">Giỏ hàng đang trống.</p>
          <div style="margin-top:12px;">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/products">← Tiếp tục mua sắm</a>
          </div>
        </div>
      </c:when>

      <c:otherwise>
        <div class="cart-card">
          <div class="table-responsive">
            <table class="table table-bordered align-middle" style="margin:0;">
              <thead class="table-light">
                <tr class="text-center">
                  <th style="width:120px;">Hình ảnh</th>
                  <th>Tên sản phẩm</th>
                  <th style="width:150px;">Giá</th>
                  <th style="width:320px;">Số lượng</th>
                  <th style="width:160px;">Thành tiền</th>
                  <th style="width:120px;">Thao tác</th>
                </tr>
              </thead>

              <tbody>
                <c:forEach var="item" items="${cartItems}">
                  <tr>
                    <td class="text-center">
                      <img class="cart-img"
                           src="${pageContext.request.contextPath}/assets/imgProduct/images/${item.product.image}"
                           alt="${item.product.name}">
                    </td>

                    <td style="font-weight:700;">${item.product.name}</td>

                    <td class="text-center">
                      <fmt:formatNumber value="${item.product.price}" type="number"/> VNĐ
                    </td>

                    <td>
                      <div class="qtybox">
                        <!-- - -->
                        <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                          <input type="hidden" name="action" value="dec">
                          <input type="hidden" name="id" value="${item.product.id}">
                          <button class="btn btn-outline-dark qtybtn" type="submit">-</button>
                        </form>

                        <span style="min-width:24px;text-align:center;font-weight:800;">${item.quantity}</span>

                        <!-- + -->
                        <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                          <input type="hidden" name="action" value="inc">
                          <input type="hidden" name="id" value="${item.product.id}">
                          <button class="btn btn-outline-dark qtybtn" type="submit">+</button>
                        </form>

                        <!-- update nhập số -->
                        <form action="${pageContext.request.contextPath}/cart" method="post"
                              style="display:flex;gap:8px;align-items:center;margin:0;">
                          <input type="hidden" name="action" value="update">
                          <input type="hidden" name="id" value="${item.product.id}">
                          <input class="form-control qtyinput" type="number" name="qty" min="1"
                                 value="${item.quantity}">
                          <button class="btn btn-dark" type="submit">Cập nhật</button>
                        </form>
                      </div>
                    </td>

                    <td class="text-center" style="font-weight:800;">
                      <fmt:formatNumber value="${item.subTotal}" type="number"/> VNĐ
                    </td>

                    <td class="text-center">
                      <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="id" value="${item.product.id}">
                        <button class="btn btn-outline-danger" type="submit"
                                onclick="return confirm('Xóa sản phẩm này khỏi giỏ hàng?')">Xóa</button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>

          <div class="cart-summary">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/products">← Tiếp tục mua sắm</a>

            <div class="total">
              Tổng tiền:
              <fmt:formatNumber value="${total}" type="number"/> VNĐ
            </div>

            <a class="btn btn-dark" href="${pageContext.request.contextPath}/checkout">Thanh toán</a>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <jsp:include page="/layout/LayoutFooter.jsp"/>
</body>
</html>
