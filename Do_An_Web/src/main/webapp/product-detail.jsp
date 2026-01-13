<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết sản phẩm</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

<style>
.detail-wrap { padding: 30px 0; }
.detail-card{
  border:1px solid #e5e5e5;background:#fff;padding:20px;border-radius:12px;
}
.detail-img{
  width:100%;max-width:420px;height:320px;object-fit:cover;border:1px solid #eee;border-radius:10px;
}
.thumb-wrap img{
  width:70px;height:60px;object-fit:cover;border:1px solid #ddd;cursor:pointer;border-radius:6px;
}
.price{ color:#d0021b;font-weight:800;font-size:22px; }
.actions{ margin-top:16px;display:flex;gap:10px;flex-wrap:wrap; }
.option-title{ font-weight:800;margin-top:14px; }
.color-group label.btn{ border-radius:999px; cursor:pointer; }
.color-group label.btn.active{ background-color:#000; color:#fff; border-color:#000; }
.size-group button.btn{ border-radius:999px; }
.size-group button.btn.active{ background-color:#000; color:#fff; border-color:#000; }
</style>
</head>

<body>
<jsp:include page="/layout/LayoutHeader.jsp"/>

<div class="container detail-wrap">

  <c:if test="${empty product}">
    <div class="alert alert-warning">Không tìm thấy sản phẩm.</div>
    <a class="btn btn-dark" href="${pageContext.request.contextPath}/home">Quay lại trang chủ</a>
  </c:if>

  <c:if test="${not empty product}">
    <div class="detail-card row">

      <!-- LEFT -->
      <div class="col-md-5">
        <img id="mainImg" class="detail-img"
             src="${pageContext.request.contextPath}/assets/imgProduct/images/${product.image}"
             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/imgProduct/images/product-default.png';"
             alt="${product.name}">

        <div class="thumb-wrap mt-2 d-flex gap-2 flex-wrap" id="thumbWrap"></div>
      </div>

      <!-- RIGHT -->
      <div class="col-md-7">
        <h3 style="font-weight:900;">${product.name}</h3>
        <div class="price">${product.price} VNĐ</div>
        <p class="mt-2 text-muted" style="margin-bottom:0;">${product.description}</p>

        <!-- COLOR -->
        <div class="option-title">Màu:</div>
        <div class="d-flex gap-2 mt-2 flex-wrap color-group">
          <c:forEach var="c" items="${colors}" varStatus="st">
            <label class="btn btn-outline-dark color-option" data-color="${c}">
              <input type="radio" name="colorRadio" value="${c}"
                     style="display:none"
                     ${st.first ? "checked" : ""}
                     onchange="onChangeColor(this.value)">
              ${c}
            </label>
          </c:forEach>
        </div>

        <!-- SIZE -->
        <div class="option-title">Size:</div>
        <div class="d-flex gap-2 mt-2 flex-wrap size-group" id="sizeWrap"></div>

        <!-- ACTIONS -->
        <div class="actions">
          <form action="${pageContext.request.contextPath}/cart" method="post" id="addToCartForm" style="margin:0;">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="id" value="${product.id}">
            <input type="hidden" name="color" id="colorInput" value="">
            <input type="hidden" name="size" id="sizeInput" value="">

            <button class="btn btn-dark" type="submit" id="addToCartBtn">Thêm vào giỏ</button>
          </form>

          <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/cart">Xem giỏ hàng</a>
          <a class="btn btn-link" href="${pageContext.request.contextPath}/home">Quay lại</a>
        </div>

        <div class="text-muted mt-2" style="font-size:13px;">
          <span>Đã chọn: </span>
          <b id="chosenText">-</b>
        </div>
      </div>
    </div>
  </c:if>

</div>

<jsp:include page="/layout/LayoutFooter.jsp"/>

<script>
const ctx = "${pageContext.request.contextPath}";

// ⚠️ các biến này phải là JSON hợp lệ được servlet set vào request
let imagesByColor = {};
let sizesByColor = {};

try {
  imagesByColor = ${imagesJson} || {};
  sizesByColor = ${sizesJson} || {};
  } catch (e) {
    imagesByColor = {};
    sizesByColor = {};
  }

function updateChosenText(){
  const c = document.getElementById("colorInput").value || "-";
  const s = document.getElementById("sizeInput").value || "-";
  document.getElementById("chosenText").innerText = c + " | " + s;
}

function onChangeColor(color){
  if (!color) return;
  
  const colorInput = document.getElementById("colorInput");
  if (!colorInput) return;
  
  colorInput.value = color;

  // Highlight màu đã chọn
  document.querySelectorAll(".color-option").forEach(label => {
    label.classList.remove("active");
    if (label.dataset.color === color) {
      label.classList.add("active");
    }
  });

  renderImages(color);
  renderSizes(color);

  const sizeInput = document.getElementById("sizeInput");
  if (!sizeInput.value) {
    const sizes = sizesByColor[color] || [];
    if (sizes.length > 0) {
      sizeInput.value = sizes[0];
      updateChosenText();
    }
  } else {
    updateChosenText();
  }
}

function renderImages(color){
  const wrap = document.getElementById("thumbWrap");
  wrap.innerHTML = "";

  const imgs = imagesByColor[color] || [];
  // Nếu không có ảnh theo màu -> giữ ảnh main hiện tại, không return làm gì gây side-effect
  if (imgs.length === 0) return;

  imgs.forEach((file, i) => {
    const img = document.createElement("img");
    img.src = ctx + "/assets/imgProduct/images/" + file;
    img.onclick = () => document.getElementById("mainImg").src = img.src;
    wrap.appendChild(img);
    if (i === 0) document.getElementById("mainImg").src = img.src;
  });
}

function renderSizes(color){
  const wrap = document.getElementById("sizeWrap");
  wrap.innerHTML = "";

  const sizes = sizesByColor[color] || [];
  if (sizes.length === 0){
    // không có size -> clear sizeInput và hiển thị thông báo
    document.getElementById("sizeInput").value = "";
    wrap.innerHTML = '<span class="text-danger">Không có size nào cho màu này</span>';
    updateChosenText();
    return;
  }

  sizes.forEach((s, i) => {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "btn btn-outline-dark";
    btn.innerText = s;

    btn.onclick = () => {
      const sizeInput = document.getElementById("sizeInput");
      if (sizeInput) {
        sizeInput.value = s;
      }
      [...wrap.children].forEach(b => {
        if (b.classList) b.classList.remove("active");
      });
      btn.classList.add("active");
      updateChosenText();
    };

    wrap.appendChild(btn);

    if (i === 0) {
      const sizeInput = document.getElementById("sizeInput");
      if (sizeInput) {
        sizeInput.value = s;
      }
      btn.classList.add("active");
      updateChosenText();
    }
  });
}

function validateAddToCart(){
  const c = document.getElementById("colorInput").value;
  const s = document.getElementById("sizeInput").value;
  
  if (!c || !s){
    alert("Vui lòng chọn màu và size trước khi thêm vào giỏ!");
    return false;
  }
  
  return true;
}

// Thêm form submit handler để đảm bảo validate trước khi submit
function setupFormSubmit() {
  const form = document.getElementById("addToCartForm");
  if (form) {
    const btn = document.getElementById("addToCartBtn");
    if (btn) {
      btn.addEventListener("click", function(e) {
        const colorInput = document.getElementById("colorInput");
        const sizeInput = document.getElementById("sizeInput");
        
        if (!colorInput || !sizeInput) {
          e.preventDefault();
          alert("Lỗi: Không tìm thấy input elements!");
          return false;
        }
        
        const c = colorInput.value.trim();
        const s = sizeInput.value.trim();
        
        if (!c || !s) {
          e.preventDefault();
          e.stopPropagation();
          alert("Vui lòng chọn màu và size trước khi thêm vào giỏ!");
          return false;
        }
        
        return true;
      });
    }
  }
}

// Thêm event listener cho label click (để đảm bảo radio được trigger)
document.addEventListener("DOMContentLoaded", function() {
  setupFormSubmit();
  
  document.querySelectorAll(".color-option").forEach(label => {
    label.addEventListener("click", function(e) {
      e.preventDefault();
      const radio = this.querySelector("input[type='radio']");
      if (radio) {
        radio.checked = true;
        radio.dispatchEvent(new Event('change'));
        onChangeColor(radio.value);
      }
    });
  });

  function initializeFirstColor() {
    const first = document.querySelector("input[name='colorRadio']:checked");
    if (first){
      onChangeColor(first.value);
    } else {
      const colorRadios = document.querySelectorAll("input[name='colorRadio']");
      if (colorRadios.length > 0 && colorRadios[0]) {
        colorRadios[0].checked = true;
        onChangeColor(colorRadios[0].value);
      } else {
        updateChosenText();
      }
    }
  }
  
  initializeFirstColor();
  setTimeout(initializeFirstColor, 100);
});
</script>

</body>
</html>
