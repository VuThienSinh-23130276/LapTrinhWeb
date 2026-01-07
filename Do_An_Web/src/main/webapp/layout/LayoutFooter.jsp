<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/fontawesome-free-5.15.3-web/css/all.min.css">

<style>
  /* Siết footer gọn hơn */
  .footer{ padding: 16px 0 0; }
  .footer .footer__list{ margin:0; padding:0; list-style:none; }
  .footer .footer__item{ margin: 0 0 8px 0; }
  .footer .footer__item p{ margin:0; line-height: 1.4; }
  .footer__item-icon{ margin-right: 10px; width: 18px; text-align:center; opacity: .85; }

  .footer__heading{
    font-size: 16px;
    letter-spacing: .5px;
    margin: 0 0 10px 0;
  }

  .footer__bottom{
    margin-top: 8px;
    padding: 10px 0;
    border-top: 1px solid rgba(0,0,0,.08);
    background: rgba(0,0,0,.03);
  }
  .footer__text{ margin:0; text-align:center; font-size: 13px; }

  .footer-social a i{ font-size: 22px; margin-right: 10px; }
</style>

<footer class="footer">
  <div class="container">
    <div class="row align-items-start" style="padding: 8px 0 6px;">

      <!-- CỘT TRÁI -->
      <div class="col-sm-12 col-md-6" style="margin-bottom: 10px;">
        <div style="display:flex; gap:14px; align-items:flex-start;">
          <img src="${pageContext.request.contextPath}/assets/img/logo/logomain.jpg"
               alt="Logo" width="82" height="82"
               style="border-radius: 50%; border: 2px solid #000; flex: 0 0 auto;">

          <div style="flex:1;">
            <ul class="footer__list">
              <li class="footer__item">
                <p><i class="fas fa-search-location footer__item-icon"></i>Ho Chi Minh, Viet Nam</p>
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
              <li class="footer__item footer-social" style="margin-top: 4px;">
                <a href="#"><i class="fab fa-facebook"></i></a>
                <a href="#"><i class="fab fa-instagram" style="color: pink;"></i></a>
                <a href="#"><i class="fab fa-youtube" style="color: red;"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- CỘT PHẢI -->
      <div class="col-sm-12 col-md-6" style="margin-bottom: 10px;">
        <h3 class="footer__heading">THÔNG TIN CỦA CHÚNG TÔI</h3>
        <ul class="footer__list">
          <li class="footer__item">
            <p>Cơ sở 1: 26 Đường D1, P12, Quận Bình Thạnh, TP.HCM</p>
          </li>
          <li class="footer__item">
            <p>Cơ sở 2: 86 Đinh Bộ Lĩnh, P26, Quận Bình Thạnh, TP.HCM</p>
          </li>
          <li class="footer__item">
            <p>Lĩnh vực kinh doanh</p>
          </li>
        </ul>
      </div>

    </div>
  </div>

  <div class="footer__bottom">
    <p class="footer__text">&copy; Bản quyền thuộc về S&amp;N Shop</p>
  </div>
</footer>
