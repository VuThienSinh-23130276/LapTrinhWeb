<%@ page contentType="text/html; charset=UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<header class="header">
  <!-- HEADER-V2-TEST -->
  <div class="container header-inner">

    <div class="left-box">
      <a href="${pageContext.request.contextPath}/home" class="logo-wrap">
        <img src="${pageContext.request.contextPath}/assets/img/logo/logomain.png" alt="Logo">
      </a>

      <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
      </nav>
    </div>

    <div class="userbox-wrap" id="userboxWrap">
      <div class="userbox-btn" id="userboxBtn">
        <div class="userbox-avatar">👤</div>
        <div class="userbox-name">
          <c:choose>
            <c:when test="${sessionScope.user != null}">
              ${sessionScope.user.username}
            </c:when>
            <c:otherwise>Khách</c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="userbox-dd" id="userboxDd">
        <c:choose>
          <c:when test="${sessionScope.user != null}">
            <div class="dd-title">Tài khoản</div>
            <div class="dd-row">ID: <b>${sessionScope.user.id}</b></div>
            <div class="dd-row">Username: <b>${sessionScope.user.username}</b></div>
            <div class="dd-row">Họ tên: <b>${sessionScope.user.fullname}</b></div>

            <a class="dd-link" href="${pageContext.request.contextPath}/account">Thông tin tài khoản</a>
            <a class="dd-link" href="${pageContext.request.contextPath}/orders">Lịch sử mua hàng</a>
            <a class="dropdown-item" href="${pageContext.request.contextPath}/KeyManagementServlet">
    <i class="fas fa-key" style="color: #ffc107;"></i> Quản lý Khóa (PKI)
</a>
            

            <c:if test="${sessionScope.user.role == 'admin'}">
              <div class="dd-title">Quản trị</div>
              <a class="dd-link" href="${pageContext.request.contextPath}/product-upload">Đăng sản phẩm</a>
              <a class="dd-link" href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a>
              <a class="dd-link" href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a>
              
            </c:if>

           

            <form action="${pageContext.request.contextPath}/logout" method="post" style="margin:10px 14px;">
              <button class="btn-logout" type="submit">Đăng xuất</button>
            </form>
          </c:when>

          <c:otherwise>
            <div class="dd-title">Bạn chưa đăng nhập</div>
            <a class="dd-link" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
            <a class="dd-link" href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

  </div>
</header>

<style>
/* HEADER giống footer - nhìn ra liền */
.header{
  background:#f1f3f5 !important;
  border-bottom:4px solid #111 !important;
}

.header-inner{
  background:transparent !important;
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:14px 0;
}

.left-box{
  display:flex;
  align-items:center;
  gap:14px;
}

.logo-wrap img{
  height:50px;
  border-radius:50%;
  border:2px solid #111;
}

.main-nav a{
  text-decoration:none;
  color:#111;
  font-weight:700;
  font-size:15px;
}

/* USER */
.userbox-wrap{position:relative;font-family:Arial,sans-serif;}
.userbox-btn{
  display:flex;align-items:center;gap:10px;
  padding:6px 12px;border-radius:999px;
  cursor:pointer;background:#fff;
  border:1px solid #ddd;
}
.userbox-avatar{
  width:26px;height:26px;border-radius:50%;
  background:#f0f0f0;display:flex;
  align-items:center;justify-content:center;
}
.userbox-name{font-size:14px;max-width:120px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}

.userbox-dd{
  position:absolute;right:0;top:44px;
  width:280px;background:#fff;
  border:1px solid #ddd;border-radius:12px;
  box-shadow:0 10px 25px rgba(0,0,0,.15);
  display:none;overflow:hidden;z-index:9999;
}
.userbox-dd.show{display:block;}
.dd-title{padding:10px 14px;font-weight:700;background:#f1f1f1;}
.dd-row{padding:10px 14px;border-bottom:1px solid #f1f1f1;}
.dd-link{display:block;padding:10px 14px;color:#111;text-decoration:none;}
.dd-link:hover{background:#f5f5f5;}
.btn-logout{width:100%;padding:10px;background:#111;color:#fff;border:none;border-radius:8px;cursor:pointer;}
</style>

<script>
(function(){
  const wrap=document.getElementById("userboxWrap");
  const btn=document.getElementById("userboxBtn");
  const dd=document.getElementById("userboxDd");
  if(!wrap||!btn||!dd) return;

  btn.onclick=function(e){e.stopPropagation();dd.classList.toggle("show");};
  document.addEventListener("click",function(e){if(!wrap.contains(e.target))dd.classList.remove("show");});
  document.addEventListener("keydown",function(e){if(e.key==="Escape")dd.classList.remove("show");});
})();
</script>
