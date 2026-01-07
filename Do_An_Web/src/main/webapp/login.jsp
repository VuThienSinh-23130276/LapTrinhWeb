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


<div class="container" style="margin-top:50px">
    <div class="row justify-content-center">
        <div class="col-md-6">

            <form action="login" method="post">
                <h3 class="text-center">ĐĂNG NHẬP</h3>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>

                <div class="form-group">
                    <label>Tài khoản</label>
                    <input type="text"
                           name="username"
                           class="form-control"
                           value="${param.username}"
                           required>
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password"
                           name="password"
                           class="form-control"
                           required>
                </div>

                <button type="submit" class="btn btn-dark btn-block">
                    Đăng nhập
                </button>
            </form>

            <p style="margin-top:15px;text-align:center">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký ngay</a>
            </p>

        </div>
    </div>
</div>

<jsp:include page="layout/LayoutFooter.jsp"/>

</body>
</html>
