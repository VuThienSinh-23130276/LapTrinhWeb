<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Lịch sử mua hàng</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">
  
  <style>
    body{font-family: Arial, sans-serif; background:#fafafa; margin:0;}
    .wrap{max-width: 1050px; margin: 26px auto; background:#fff; border:1px solid #eee; border-radius:12px; padding:18px;}
    h2{margin:0 0 8px;}
    .sub{color:#666; margin:0 0 16px;}
    table{width:100%; border-collapse: collapse;}
    th,td{padding:12px 10px; border-bottom:1px solid #f1f1f1; text-align:left; vertical-align: middle;}
    th{background:#f7f7f7; font-weight:700;}
    .code{font-weight:800;}
    .empty{padding:14px; color:#666;}
    .top-actions{display:flex; gap:10px; margin-top:20px;}
    .btn{display:inline-block; padding:10px 12px; border-radius:10px; text-decoration:none; font-weight:700;}
    .btn-primary{background:#111; color:#fff;}
    .btn-light{background:#f3f3f3; color:#111;}
    
    /* Style cho các trạng thái chữ ký */
    .badge {
        padding: 6px 10px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: bold;
        display: inline-block;
    }
    .badge-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .badge-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    .badge-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
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
            <th>Thanh toán</th>
            <th>Trạng thái GD</th>
            <th>Tổng tiền</th>
            <th>Xác thực chữ ký <i class="fas fa-shield-alt" style="color: #666;"></i></th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="o" items="${orders}">
            <tr>
              <td class="code">${o.orderCode}</td>
              <td>${o.createdAt}</td>
              <td>
                <c:choose>
                  <c:when test="${o.paymentMethod == 'COD'}">
                    <span style="color: #666;">Tiền mặt (COD)</span>
                  </c:when>
                  <c:when test="${o.paymentMethod == 'TRANSFER'}">
                    <span style="color: #0066cc;">Chuyển khoản</span>
                  </c:when>
                  <c:otherwise>
                    <span style="color: #666;">${o.paymentMethod}</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${o.paid}">
                    <span style="color: #28a745; font-weight: 700;">✓ Đã thanh toán</span>
                  </c:when>
                  <c:otherwise>
                    <span style="color: #dc3545; font-weight: 700;">✗ Chưa thanh toán</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td style="font-weight: bold;">${o.total} đ</td>
              
              <td>
                <c:choose>
                  <c:when test="${o.verifyStatus == 'VALID'}">
                    <div class="badge badge-success" title="Dữ liệu toàn vẹn, chữ ký hợp lệ">
                        <i class="fas fa-check-circle"></i> Hợp lệ
                    </div>
                  </c:when>
                  <c:when test="${o.verifyStatus == 'INVALID'}">
                    <div class="badge badge-danger" title="CẢNH BÁO: Dữ liệu đơn hàng đã bị thay đổi!">
                        <i class="fas fa-exclamation-triangle"></i> Bị can thiệp
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div class="badge badge-warning" title="Đơn hàng chưa có chữ ký số">
                        <i class="fas fa-info-circle"></i> Chưa ký
                    </div>
                  </c:otherwise>
                </c:choose>
              </td>
              
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