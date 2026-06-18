<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Xác thực chữ ký đơn hàng</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">
<style>
    .sign-wrap { padding: 40px 15px; max-width: 700px; margin: 0 auto; }
    .sign-card { 
        background: #fff; border: 1px solid #eee; border-radius: 14px; 
        padding: 30px; box-shadow: 0 10px 25px rgba(0,0,0,.06); 
    }
    .data-box {
        background: #f8f9fa; padding: 15px; border: 1px dashed #ced4da;
        border-radius: 8px; font-family: 'Consolas', monospace; font-size: 16px;
        text-align: center; font-weight: bold; color: #d63384; margin-bottom: 20px;
    }
</style>
</head>
<body style="background: #fafafa;">

    <jsp:include page="/layout/LayoutHeader.jsp" />

    <div class="container sign-wrap">
        <div class="sign-card">
            <h3 style="font-weight: 800; text-align: center; margin-bottom: 25px;">
                <i class="fas fa-file-signature" style="color: #0d6efd;"></i> Xác Thực Chữ Ký Số
            </h3>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="border-radius: 8px; font-weight: 500;">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <div style="margin-bottom: 20px;">
                <p><b>Bước 1:</b> Copy chuỗi dữ liệu dưới đây và dán vào <b>Tool Offline</b> để tiến hành Ký số:</p>
                <div class="data-box">${sessionScope.lastOrderCode}|${sessionScope.totalPrice}</div>
            </div>

            <form action="SignServlet" method="post">
                <input type="hidden" name="total" value="${sessionScope.totalPrice}">
                
                <div class="form-group">
                    <label><b>Bước 2:</b> Dán chữ ký số (Base64) nhận được từ Tool vào ô bên dưới:</label>
                    <textarea name="signature" class="form-control" rows="6" required placeholder="Ví dụ: MIIBIjANBgkqhkiG9w0BAQEFAAOCA..."></textarea>
                </div>

                <button type="submit" class="btn btn-dark w-100" style="padding: 12px; font-size: 16px; font-weight: bold; margin-top: 10px;">
                    <i class="fas fa-check-circle"></i> Hoàn tất chốt đơn
                </button>
            </form>
        </div>
    </div>

    <jsp:include page="/layout/LayoutFooter.jsp" />

</body>
</html>