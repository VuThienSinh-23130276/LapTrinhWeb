<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Lịch sử mua hàng</title>
  <style>
    body{font-family: Arial, sans-serif; background:#fafafa; margin:0;}
    .wrap{max-width: 980px; margin: 26px auto; background:#fff; border:1px solid #eee; border-radius:12px; padding:18px;}
    h2{margin:0 0 8px;}
    .sub{color:#666; margin:0 0 16px;}
    table{width:100%; border-collapse: collapse;}
    th,td{padding:10px; border-bottom:1px solid #f1f1f1; text-align:left;}
    th{background:#f7f7f7; font-weight:700;}
    .code{font-weight:800;}
    .empty{padding:14px; color:#666;}
    .top-actions{display:flex; gap:10px; margin-top:14px;}
    .btn{display:inline-block; padding:10px 12px; border-radius:10px; text-decoration:none; font-weight:700;}
    .btn-primary{background:#111; color:#fff;}
    .btn-light{background:#f3f3f3; color:#111;}
  </style>
</head>
<body>
 <jsp:include page="layout/LayoutHeader.jsp"/>


<div class="wrap">
  <h2>Lịch sử mua hàng</h2>
  <p class="sub">
    Khách hàng: <b>${sessionScope.user.fullname}</b> (${sessionScope.user.username})
  </p>

  <c:choose>
    <c:when test="${empty orders}">
      <div class="empty">Bạn chưa có đơn hàng nào.</div>
    </c:when>
    <c:otherwise>
      <table>
        <thead>
          <tr>
            <th>Mã đơn</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="o" items="${orders}">
            <tr>
              <td class="code">${o.orderCode}</td>
              <td>${o.createdAt}</td>
              <td>${o.total} VND</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>

  <div class="top-actions">
    <a class="btn btn-light" href="${pageContext.request.contextPath}/home">← Về trang chủ</a>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">Tiếp tục mua sắm</a>
  </div>
</div>
<jsp:include page="layout/LayoutFooter.jsp"/>

</body>
</html>
