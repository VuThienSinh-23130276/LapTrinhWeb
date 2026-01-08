<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Hoàn tất</title>

  <style>
    body{
      margin:0;
      font-family: system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
      background:#ffffff;
      color:#111;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }

    .page-wrap{
      width: min(1100px, 92%);
      margin: 28px auto 44px;
    }

    .card{
      background:#fff;
      border:1px solid rgba(0,0,0,.10);
      border-radius:18px;
      box-shadow:0 12px 26px rgba(0,0,0,.06);
      padding:26px;
    }

    .success-title{
      margin:0 0 10px;
      font-size: 34px;
      font-weight: 800;
      letter-spacing: -0.3px;
      line-height: 1.15;
    }

    .sub{
      margin:0 0 18px;
      color: rgba(0,0,0,.70);
      font-size: 15px;
      line-height: 1.7;
    }

    .order-code{
      display:inline-flex;
      gap:10px;
      align-items:center;
      padding:10px 12px;
      border-radius: 12px;
      background: #f1f3f5;
      border: 1px solid rgba(0,0,0,.10);
      margin: 6px 0 18px;
      font-size: 14px;
    }
    .badge{
      display:inline-block;
      padding: 6px 10px;
      border-radius: 999px;
      background:#111;
      color:#fff;
      font-size: 12px;
      font-weight: 700;
    }

    .actions{
      display:flex;
      gap:12px;
      flex-wrap: wrap;
      margin-top: 8px;
    }

    .btn{
      display:inline-flex;
      align-items:center;
      justify-content:center;
      padding: 10px 14px;
      border-radius: 12px;
      text-decoration:none;
      font-weight: 700;
      font-size: 14px;
      border: 1px solid rgba(0,0,0,.12);
      transition: .15s;
      cursor:pointer;
      user-select:none;
    }
    .btn-primary{
      background:#111;
      color:#fff;
      border-color:#111;
    }
    .btn-primary:hover{ transform: translateY(-1px); opacity:.95; }

    .btn-ghost{
      background:#fff;
      color:#111;
    }
    .btn-ghost:hover{ background:#f6f6f6; transform: translateY(-1px); }
  </style>
</head>

<body>
  <jsp:include page="layout/LayoutHeader.jsp"/>

  <main class="page-wrap">
    <section class="card">
      <h2 class="success-title">Đặt hàng thành công!</h2>
      <p class="sub">Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đã được ghi nhận.</p>

      <c:if test="${not empty sessionScope.lastOrderCode}">
        <div class="order-code">
          <span class="badge">Mã đơn</span>
          <b>${sessionScope.lastOrderCode}</b>
        </div>
        <c:remove var="lastOrderCode" scope="session" />
      </c:if>

      <div class="actions">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">
          Tiếp tục mua sắm
        </a>

        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/orders">
          Xem lịch sử mua hàng
        </a>
      </div>
    </section>
  </main>

  <jsp:include page="layout/LayoutFooter.jsp" />
</body>
</html>
