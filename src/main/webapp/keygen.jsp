<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý Khóa số</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">
<style>
.pki-wrap { padding: 40px 15px; max-width: 700px; margin: 0 auto; }
.pki-card { 
    background: #fff; 
    border: 1px solid #eee; 
    border-radius: 14px; 
    padding: 25px; 
    box-shadow: 0 10px 25px rgba(0,0,0,.06); 
}
</style>
</head>
<body style="background: #fafafa;">

    <jsp:include page="/layout/LayoutHeader.jsp" />

    <div class="container pki-wrap">
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại trang chủ
            </a>
        </div>

        <div class="pki-card">
            <h2 style="font-weight: 800; margin-bottom: 20px;">Quản lý Khóa số (PKI)</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="border-radius: 8px;"><b>Lỗi:</b> ${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success" style="border-radius: 8px;"><b>Thành công:</b> ${message}</div>
            </c:if>

            <p style="font-size: 15px;">Sử dụng <b>Tool Offline</b> để sinh cặp khóa mới. Sau đó dán chuỗi <strong>Public Key</strong> vào ô dưới đây để đăng ký định danh với hệ thống:</p>

            <form action="KeyManagementServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <textarea name="publicKey" class="form-control" rows="7" required placeholder="-----BEGIN PUBLIC KEY-----&#10;Dán toàn bộ nội dung khóa vào đây...&#10;-----END PUBLIC KEY-----"></textarea>
                </div>
                <button type="submit" class="btn btn-dark w-100" style="padding: 12px; font-weight: bold; font-size: 16px;">
                    <i class="fas fa-save"></i> Lưu Public Key
                </button>
            </form>

            <hr style="margin: 35px 0;">

            <div style="background: #fff3cd; border: 1px solid #ffeeba; padding: 15px; border-radius: 8px;">
                <p style="color: #856404; font-size: 14px; margin-bottom: 10px;">
                    <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i> 
                    <b>Khu vực nguy hiểm:</b> Nếu nghi ngờ máy tính bị lộ file Private Key, hãy thu hồi khóa cũ ngay lập tức để bảo vệ tài khoản.
                </p>
                <form action="KeyManagementServlet" method="post">
                    <input type="hidden" name="action" value="revoke">
                    <button type="submit" class="btn btn-danger" style="font-weight: bold;">
                        <i class="fas fa-trash-alt"></i> Thu hồi khóa hiện tại
                    </button>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/layout/LayoutFooter.jsp" />

</body>
</html>