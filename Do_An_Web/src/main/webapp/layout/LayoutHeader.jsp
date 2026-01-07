<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ================= HEADER ================= -->
<header class="header" style="position: relative; z-index: 9999;">
  <div class="container" style="display:flex; align-items:center; justify-content:space-between; padding:12px 0;">

    <!-- LOGO -->
    <a href="${pageContext.request.contextPath}/home.jsp" style="display:flex;align-items:center;">
      <img src="${pageContext.request.contextPath}/assets/img/logo/logomain.jpg"
           alt="Logo" height="50" style="border-radius:50%;border:2px solid #000;">
    </a>

    <!-- MENU -->
    <nav>
      <a href="${pageContext.request.contextPath}/home.jsp" style="margin-right:32px;">Trang chủ</a>
      <a href="${pageContext.request.contextPath}/products.jsp" style="margin-right:32px;">Sản phẩm</a>
      
    </nav>

    <!-- USER MENU -->
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

            <c:if test="${sessionScope.user.role == 'admin'}">
              <div class="dd-title">Quản trị</div>
              <a class="dd-link" href="${pageContext.request.contextPath}/product-upload">Đăng sản phẩm</a>
              <a class="dd-link" href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a>
              <a class="dd-link" href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a>
            </c:if>

            <a class="dd-link" href="${pageContext.request.contextPath}/orders">Lịch sử mua hàng</a>

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

<!-- ================= USER MENU STYLE ================= -->
<style>
.userbox-wrap{
  position: relative;
  font-family: Arial, sans-serif;
}
.userbox-btn{
  display:flex;align-items:center;gap:10px;
  padding:6px 10px;border-radius:999px;
  cursor:pointer;background:#fff;
  border:1px solid #eee;
  box-shadow:0 2px 10px rgba(0,0,0,.08);
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
  border:1px solid #eee;border-radius:12px;
  box-shadow:0 12px 30px rgba(0,0,0,.14);
  display:none;overflow:hidden;
}
.userbox-dd.show{display:block;}
.dd-title{padding:10px 14px;font-weight:700;background:#f7f7f7;}
.dd-row{padding:10px 14px;border-bottom:1px solid #f3f3f3;}
.dd-link{display:block;padding:10px 14px;color:#111;text-decoration:none;}
.dd-link:hover{background:#f7f7f7;}
.btn-logout{
  width:100%;padding:10px;
  background:#111;color:#fff;
  border:none;border-radius:8px;
  cursor:pointer;
}
</style>

<!-- ================= USER MENU SCRIPT ================= -->
<script>
(function(){
  const wrap=document.getElementById("userboxWrap");
  const btn=document.getElementById("userboxBtn");
  const dd=document.getElementById("userboxDd");
  if(!wrap||!btn||!dd) return;
  btn.onclick=(e)=>{e.stopPropagation();dd.classList.toggle("show");};
  document.addEventListener("click",(e)=>{if(!wrap.contains(e.target))dd.classList.remove("show");});
  document.addEventListener("keydown",(e)=>{if(e.key==="Escape")dd.classList.remove("show");});
})();
</script>
