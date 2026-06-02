<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">

<style>
  /* ===== FOOTER THEME (match header) ===== */
  .footer-topline{
    height: 4px;
    width: 100%;
    background: #111;
  }

  .footer{
    background: #f1f3f5;
    color: #111;
    padding: 18px 0 0;
  }

  .footer a{
    color: #111;
    text-decoration: none;
  }
  .footer a:hover{
    text-decoration: underline;
  }

  .footer-inner{
    padding: 10px 0 14px;
  }

  .footer-left{
    display:flex;
    gap:14px;
    align-items:flex-start;
  }

  .footer-logo{
    width: 84px;
    height: 84px;
    border-radius: 50%;
    border: 2px solid #111;
    object-fit: cover;
    flex: 0 0 auto;
    background: #fff;
  }

  .footer__heading{
    font-size: 16px;
    font-weight: 800;
    margin: 0 0 10px 0;
    letter-spacing: .3px;
  }

  .footer__list{
    margin:0;
    padding:0;
    list-style:none;
  }

  .footer__item{
    margin: 0 0 8px 0;
  }
  .footer__item p{
    margin:0;
    line-height: 1.55;
    font-size: 14px;
  }

  .footer__item-icon{
    margin-right: 10px;
    width: 18px;
    text-align:center;
    opacity: .85;
  }

  .footer-social{
    display:flex;
    gap: 10px;
    align-items:center;
    margin-top: 8px;
  }
  .footer-social a{
    width: 36px;
    height: 36px;
    border-radius: 999px;
    display:flex;
    align-items:center;
    justify-content:center;
    background: rgba(17,17,17,.06);
    border: 1px solid rgba(17,17,17,.10);
    transition: .15s;
  }
  .footer-social a:hover{
    transform: translateY(-1px);
    background: rgba(17,17,17,.10);
  }
  .footer-social i{
    font-size: 18px;
  }

  .footer__bottom{
    margin-top: 8px;
    padding: 12px 0;
    border-top: 1px solid rgba(0,0,0,.10);
    background: rgba(0,0,0,.03);
  }

  .footer__text{
    margin:0;
    text-align:center;
    font-size: 13px;
    opacity: .9;
  }

  /* nhỏ lại trên mobile */
  @media (max-width: 576px){
    .footer-left{ gap: 12px; }
    .footer-logo{ width: 72px; height: 72px; }
    .footer__heading{ margin-top: 8px; }
  }
</style>

<!-- Line đen cố định (không bị CSS trang khác đè) -->
<div class="footer-topline"></div>

<footer class="footer">
  <div class="container footer-inner">
    <div class="row align-items-start">

      <!-- CỘT TRÁI -->
      <div class="col-sm-12 col-md-6" style="margin-bottom: 14px;">
        <div class="footer-left">
          <img
            class="footer-logo"
            src="${pageContext.request.contextPath}/assets/img/logo/logomain.png"
            alt="Logo">

          <div style="flex:1;">
            <ul class="footer__list">
              <li class="footer__item">
                <p><i class="fas fa-map-marker-alt footer__item-icon"></i>Ho Chi Minh, Viet Nam</p>
              </li>
              <li class="footer__item">
                <p>
                  <i class="fas fa-phone-alt footer__item-icon"></i>
                  Số điện thoại: <a href="tel:0325556718">0325 556 718</a>
                </p>
              </li>
              <li class="footer__item">
                <p>
                  <i class="fas fa-envelope footer__item-icon"></i>
                  Email: <a href="mailto:S&amp;Nshopnlu@gmail.com">S&amp;Nshopnlu@gmail.com</a>
                </p>
              </li>

              <li class="footer__item">
                <div class="footer-social">
                  <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                  <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                  <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                  <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- CỘT PHẢI -->
      <div class="col-sm-12 col-md-6" style="margin-bottom: 14px;">
        <h3 class="footer__heading">THÔNG TIN CỦA CHÚNG TÔI</h3>
        <ul class="footer__list">
          <li class="footer__item">
            <p>Cơ sở 1: 26 Đường D1, P12, Quận Bình Thạnh, TP.HCM</p>
          </li>
          <li class="footer__item">
            <p>Cơ sở 2: 86 Đinh Bộ Lĩnh, P26, Quận Bình Thạnh, TP.HCM</p>
          </li>
          <li class="footer__item">
            <p>Lĩnh vực kinh doanh: Thời trang nam/nữ, phụ kiện.</p>
          </li>
        </ul>
      </div>

    </div>
  </div>

  <div class="footer__bottom">
    <p class="footer__text">&copy; Bản quyền thuộc về S&amp;N Shop</p>
  </div>
</footer>
