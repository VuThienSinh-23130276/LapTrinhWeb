<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - P&T Shop</title>
    
    <link rel="stylesheet" href="./assets/css/bootstrap.css">
    <link rel="stylesheet" href="./assets/css/main.css">
    <link rel="stylesheet" href="./assets/css/login.css">
    <link rel="stylesheet" href="./assets/fontawesome-free-5.15.3-web/css/all.min.css">
</head>

<body>

    <c:if test="${not empty sessionScope.user}">
        <c:redirect url="index.jsp"/>
    </c:if>

    <div class="container">
        <div class="login__form" style="margin-top: 50px; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
            <div class="row">
                <div class="col-sm-12 col-lg-6">
                    <form action="${pageContext.request.contextPath}/login" method="post" class="form" id="form-login">
                        
                        <h3 class="heading" style="margin-bottom: 20px;">ĐĂNG NHẬP</h3>
                        
                        <h5 style="text-align:left; font-size: 16px;">
                            <c:choose>
                                <%-- Trường hợp 1: Đổi mật khẩu thành công --%>
                                <c:when test="${not empty sessionScope.forgotPassword and sessionScope.forgotPassword.complete}">
                                    <span style="color: green;">
                                        <i class="fa fa-check"></i> Đổi mật khẩu thành công, mời đăng nhập.
                                    </span>
                                </c:when>

                                <%-- Trường hợp 2: Đăng ký thành công --%>
                                <c:when test="${not empty sessionScope.success}">
                                    <span style="color: green;">
                                        <i class="fa fa-check"></i> Đăng ký thành công, mời đăng nhập.
                                    </span>
                                </c:when>

                                <%-- Trường hợp 3: Đăng nhập lỗi (Sai pass, sai user) --%>
                                <c:when test="${not empty requestScope.loginStatus}">
                                    <span style="color: red;">
                                        ${requestScope.loginStatus}
                                    </span>
                                </c:when>
                            </c:choose>
                        </h5>

                        <div class="form-group" style="margin-bottom: 15px;">
                            <label for="username" class="form-label">Tài khoản</label>
                            <input id="username" name="username" type="text" placeholder="Nhập tài khoản" class="form-control" style="width:100%; padding:10px;" required>
                        </div>

                        <div class="form-group" style="margin-bottom: 15px;">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input id="password" name="password" type="password" placeholder="Nhập mật khẩu" class="form-control" style="width:100%; padding:10px;" required>
                        </div>

                        <button type="submit" class="form-submit" style="background: #333; color: white; border: none; padding: 10px 20px; cursor: pointer;">
                            ĐĂNG NHẬP <i class="fas fa-arrow-right" style="margin-left: 10px;"></i>
                        </button>
                        
                        <div style="margin-top: 15px;">
                            <a href="ForgotPassword.jsp" style="color: blue;">Bạn quên mật khẩu?</a>
                        </div>
                    </form>
                </div>

                <div class="col-sm-12 col-lg-6">
                    <h3 class="heading">TẠO MỘT TÀI KHOẢN</h3>
                    <p>Đăng ký thành viên để hưởng nhiều ưu đãi:</p>
                    <ul style="list-style: none; padding-left: 0;">
                        <li><i class="fas fa-check"></i> Thanh toán nhanh hơn</li>
                        <li><i class="fas fa-check"></i> Xem lịch sử đơn hàng</li>
                        <li><i class="fas fa-check"></i> Nhận ưu đãi giảm giá</li>
                    </ul>
                    <a href="register.jsp">
                        <button style="background: white; color: black; border: 1px solid #333; padding: 10px 20px; cursor: pointer;">
                            ĐĂNG KÝ NGAY
                        </button>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="./assets/js/jquery-3.6.1.min.js"></script>
    <script src="./assets/js/bootstrap.min.js"></script>

</body>
</html>