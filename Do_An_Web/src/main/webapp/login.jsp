<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">
</head>

<body>
<jsp:include page="layout/LayoutHeader.jsp"/>

<main class="login-page">
    <div class="container" style="padding: 40px 0;">
        <div class="row justify-content-center">
            <div class="col-12 col-md-8 col-lg-6">

                <form class="login__form" action="${pageContext.request.contextPath}/login" method="post">
                    <h2 class="heading">ĐĂNG NHẬP</h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" style="font-size:14px;">
                            ${error}
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label class="form-label">Tài khoản</label>
                        <input type="text" name="username" class="form-control"
                               value="${param.username}" required>
                    </div>

                    <div class="form-group matkhau">
                        <label class="form-label">Mật khẩu</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>

                    <button type="submit" class="form-submit">
                        Đăng nhập
                    </button>

                    <p style="margin-top:15px;text-align:center;font-size:14px;">
                        Chưa có tài khoản?
                        <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký ngay</a>
                    </p>
                </form>

            </div>
        </div>
    </div>
</main>

<jsp:include page="layout/LayoutFooter.jsp"/>
</body>
</html>
