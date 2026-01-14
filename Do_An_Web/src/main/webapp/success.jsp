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

    /* QR Code Modal Styles */
    .qr-modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.7);
      animation: fadeIn 0.3s;
    }
    .qr-modal.show {
      display: flex;
      align-items: center;
      justify-content: center;
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    .qr-modal-content {
      background: #ffe5f0;
      border-radius: 18px;
      padding: 0;
      max-width: 400px;
      width: 90%;
      max-height: 90vh;
      text-align: center;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      animation: slideUp 0.3s;
      overflow-y: auto;
      overflow-x: hidden;
      display: flex;
      flex-direction: column;
    }
    @keyframes slideUp {
      from { transform: translateY(30px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .qr-modal-header {
      padding: 15px 20px;
      background: #ffe5f0;
      flex-shrink: 0;
    }
    .qr-modal-content h3 {
      margin: 0 0 8px;
      font-size: 20px;
      font-weight: 800;
      color: #111;
    }
    .qr-modal-content p {
      color: #666;
      margin: 0 0 15px;
      font-size: 13px;
    }
    .qr-payment-logos {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      padding: 12px 15px;
      background: #fff;
      border-bottom: 1px solid #e0e0e0;
      flex-shrink: 0;
    }
    .qr-payment-logos img {
      height: 30px;
      object-fit: contain;
    }
    .qr-code-container {
      background: #000;
      padding: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      flex-shrink: 0;
    }
    .qr-code-container img {
      width: 240px;
      height: 240px;
      object-fit: contain;
      display: block;
    }
    .qr-modal-body {
      padding: 15px 20px 20px;
      background: #ffe5f0;
      flex-shrink: 0;
    }
    .qr-bank-info {
      background: #fff;
      padding: 12px;
      border-radius: 8px;
      margin: 12px 0;
      text-align: left;
      font-size: 12px;
      border: 1px solid #e0e0e0;
    }
    .qr-bank-info strong {
      display: block;
      margin-bottom: 6px;
      color: #111;
      font-size: 13px;
    }
    .qr-bank-info span {
      color: #333;
      display: block;
      margin-bottom: 4px;
      line-height: 1.5;
    }
    .close-qr-modal {
      margin-top: 12px;
      padding: 10px 20px;
      background: #111;
      color: #fff;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 700;
      font-size: 14px;
      width: 100%;
      transition: all 0.2s;
      flex-shrink: 0;
    }
    .close-qr-modal:hover {
      opacity: 0.9;
      transform: translateY(-1px);
      background: #333;
    }
    .qr-success-message {
      color: #28a745;
      font-weight: 700;
      margin-top: 10px;
      font-size: 12px;
      padding: 8px;
      background: #d4edda;
      border-radius: 6px;
      border: 1px solid #c3e6cb;
    }
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

  <!-- QR Code Modal -->
  <c:if test="${param.payment == 'transfer'}">
    <div id="qrModal" class="qr-modal show">
      <div class="qr-modal-content">
        <div class="qr-modal-header">
          <h3>Thanh toán bằng chuyển khoản</h3>
          <p>Vui lòng quét mã QR code bên dưới để thanh toán</p>
        </div>
        
        <!-- Payment Logos -->
        <div class="qr-payment-logos">
          <span style="font-weight: 700; color: #0066cc; font-size: 16px;">mo mo</span>
          <span style="width: 1px; height: 20px; background: #e0e0e0; display: inline-block;"></span>
          <span style="font-weight: 700; color: #d32f2f; font-size: 16px;">VIETQR</span>
          <span style="width: 1px; height: 20px; background: #e0e0e0; display: inline-block;"></span>
          <span style="font-weight: 700; color: #1976d2; font-size: 16px;">napas 247</span>
        </div>
        
        <!-- QR Code -->
        <div class="qr-code-container">
          <img src="${pageContext.request.contextPath}/assets/img/logo/fakeqr.jpg" 
               alt="QR Code thanh toán"
               style="width: 240px; height: 240px; object-fit: contain;" />
        </div>

        <!-- Bank Info -->
        <div class="qr-modal-body">
          <div class="qr-bank-info">
            <strong>Thông tin chuyển khoản:</strong>
            <span><strong>Chủ tài khoản:</strong> VŨ THIÊN SINH </span>
            <span><strong>Số tài khoản:</strong> ********718</span>
            <span><strong>Nội dung:</strong> Thanh toán đơn hàng ${sessionScope.lastOrderCode}</span>
            <span><strong>Số tiền:</strong> Vui lòng kiểm tra trong email xác nhận</span>
          </div>

          <div class="qr-success-message">
            ✓ Đơn hàng của bạn đã được đánh dấu là đã thanh toán
          </div>

          <button class="close-qr-modal" onclick="closeQRModal()">Đã thanh toán</button>
        </div>
      </div>
    </div>
  </c:if>

  <script>
    function closeQRModal() {
      document.getElementById('qrModal').classList.remove('show');
      setTimeout(function() {
        document.getElementById('qrModal').style.display = 'none';
      }, 300);
    }

    // Đóng modal khi click bên ngoài
    window.onclick = function(event) {
      const modal = document.getElementById('qrModal');
      if (event.target == modal) {
        closeQRModal();
      }
    }
  </script>

  <jsp:include page="layout/LayoutFooter.jsp" />
</body>
</html>
