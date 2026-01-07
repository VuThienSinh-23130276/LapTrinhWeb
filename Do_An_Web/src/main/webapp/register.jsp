<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản</title>

    <!-- CSS chung -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">

    <style>
        .register-wrapper {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-box {
            width: 100%;
            max-width: 450px;
            padding: 30px;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 0 15px rgba(0,0,0,0.15);
        }
        .register-box h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: bold;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<jsp:include page="layout/LayoutHeader.jsp"/>

<!-- REGISTER FORM -->
<div class="container register-wrapper">
    <div class="register-box">

        <h2>ĐĂNG KÝ TÀI KHOẢN</h2>

        <form action="register" method="post">

            <div class="form-group">
                <label>Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" required>
            </div>

            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" class="form-control" required>
            </div>

            <div class="form-group">
                <label>Họ và tên</label>
                <input type="text" name="fullname" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-dark btn-block">
                Đăng ký
            </button>
        </form>

        <!-- ĐĂNG KÝ THÀNH CÔNG -->
        <%
            String success = (String) request.getAttribute("success");
            if (success != null) {
        %>
        <div class="alert alert-success mt-3 text-center">
            <%= success %>
        </div>
        <%
            }
        %>

        <!-- ĐĂNG KÝ THẤT BẠI -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert alert-danger mt-3 text-center">
            <%= error %>
        </div>
        <%
            }
        %>

        <p class="text-center mt-3">
            Đã có tài khoản?
            <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập ngay</a>
        </p>

    </div>
</div>

<!-- FOOTER -->
<jsp:include page="layout/LayoutFooter.jsp"/>

</body>
</html>
