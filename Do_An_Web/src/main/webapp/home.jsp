<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/main.css">
</head>

<body>



<!-- ===== SLIDE ===== -->
<div id="demo" class="carousel slide" data-ride="carousel">
    <div class="carousel-inner">
        <c:forEach items="${slides}" var="s" varStatus="st">
            <div class="carousel-item ${st.first ? 'active' : ''}">
                <img src="${s.slide_link}" class="d-block w-100">
            </div>
        </c:forEach>
    </div>
</div>

<!-- ===== SẢN PHẨM MỚI ===== -->
<div class="container mt-4">
    <h3>Sản phẩm mới</h3>
    <div class="row">
        <c:forEach items="${newProducts}" var="p" begin="0" end="3">
            <div class="col-md-3">
                <div class="card">
                    <img class="card-img-top" src="${p.main_img_link}">
                    <div class="card-body">
                        <h5>${p.prod_name}</h5>

                        <c:choose>
                            <c:when test="${not empty p.sales}">
                                <p class="text-danger">
                                    <fmt:formatNumber
                                            value="${p.price * (1 - p.sales.discount_rate/100)}"
                                            type="number"/>
                                    đ
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p>
                                    <fmt:formatNumber value="${p.price}"
                                                      type="number"/> đ
                                </p>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not empty user}">
                            <a class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-heart"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- ===== SẢN PHẨM HOT ===== -->
<div class="container mt-4">
    <h3>Sản phẩm hot</h3>
    <div class="row">
        <c:forEach items="${hotProducts}" var="p" begin="0" end="3">
            <div class="col-md-3">
                <div class="card">
                    <img class="card-img-top" src="${p.main_img_link}">
                    <div class="card-body">
                        <h5>${p.prod_name}</h5>
                        <p>
                            <fmt:formatNumber value="${p.price}"
                                              type="number"/> đ
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- ===== CÓ THỂ BẠN THÍCH ===== -->
<div class="container mt-4">
    <h3>Có thể bạn thích</h3>
    <div class="row">
        <c:forEach items="${likeProducts}" var="p" begin="0" end="3">
            <div class="col-md-3">
                <div class="card">
                    <img class="card-img-top" src="${p.main_img_link}">
                    <div class="card-body">
                        <h5>${p.prod_name}</h5>
                        <p>
                            <fmt:formatNumber value="${p.price}"
                                              type="number"/> đ
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="layout/LayoutFooter.jsp"/>

<script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.1.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

</body>
</html>
