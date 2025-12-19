
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>
    
    <link rel="stylesheet" href="./assets/fontawesome-free-5.15.3-web/css/all.min.css">
    <link rel="stylesheet" href="./assets/css/bootstrap.css">
    <link rel="stylesheet" href="./assets/css/base.css">
    <link rel="stylesheet" href="./assets/css/main.css">
    <link rel="stylesheet" href="./assets/css/login.css">
    
    <style>
        .login-error-msg {
            color: red;
            font-weight: bold;
            margin-bottom: 15px;
            display: block;
        }
        .btn-blocker { width: 100%; display: block; margin-bottom: 10px; }
        .form-social { display: flex; gap: 10px; }
    </style>
</head>

<body>


    <div class="container" style="margin-top: 50px; margin-bottom: 50px;">
        <div class="login__form">
            <div class="row">
                
                <div class="col-sm-12 col-lg-6">
                    <form action="login" method="post" class="form" id="form-login">
                        <h3 class="heading">ĐĂNG NHẬP</h3>
                        
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-triangle"></i> 
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>

                        <div class="form-group">
                            <label for="username" class="form-label">Tài khoản</label>
                            <input id="username" name="username" type="text" placeholder="Nhập tài khoản" class="form-control" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input id="password" name="password" type="password" placeholder="Nhập mật khẩu" class="form-control" required>
                        </div>

                        <button type="submit" class="form-submit" style="background-color: #000; color: #fff; padding: 10px 20px; border: none; width: 100%; margin-top: 10px;">
                            ĐĂNG NHẬP <i class="fas fa-arrow-right" style="margin-left: 10px;"></i>
                        </button>
                        
                        <h4 style="margin-top: 20px; text-align: center;">HOẶC ĐĂNG NHẬP BẰNG</h4>
                        <div class="form-social">
                            <a href="#" class="btn btn-primary btn-blocker" style="background: #3b5998;">
                                <i class="fab fa-facebook-f"></i> Facebook
                            </a>
                            <a href="#" class="btn btn-danger btn-blocker" style="background: #db4437;">
                                <i class="fab fa-google"></i> Google
                            </a>
                        </div>
                    </form>
                </div>

                <div class="col-sm-12 col-lg-6">
                    <h3 class="heading">TẠO MỘT TÀI KHOẢN</h3>
                    <p class="text-login">Tạo tài khoản để nhận ưu đãi và thanh toán nhanh hơn:</p>
                    <ul style="list-style: none; padding: 0;">
                        <li class="text-login-item"><i class="fas fa-check" style="color: green; margin-right: 10px;"></i> Thanh toán nhanh hơn</li>
                        <li class="text-login-item"><i class="fas fa-check" style="color: green; margin-right: 10px;"></i> Theo dõi đơn hàng</li>
                        <li class="text-login-item"><i class="fas fa-check" style="color: green; margin-right: 10px;"></i> Nhận ưu đãi riêng</li>
                    </ul>
                    
                    <a href="register.jsp">
                        <button class="form-submit" style="background-color: #fff; color: #000; border: 1px solid #000; padding: 10px 20px; width: 100%;">
                            ĐĂNG KÝ NGAY <i class="fas fa-arrow-right"></i>
                        </button>
                    </a>
                </div>
            </div>
        </div>
    </div>

  

    <script src="./assets/js/jquery-3.6.1.min.js"></script>
    <script src="./assets/js/bootstrap.min.js"></script>
    <jsp:include page="layout/LayoutFooter.jsp"></jsp:include>
    
</body>
</html>