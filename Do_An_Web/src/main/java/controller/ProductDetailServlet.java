package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.Product;
import repository.ProductRepository;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");
		if (idStr == null) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		int id = Integer.parseInt(idStr);
		Product p = ProductRepository.findById(id);

		if (p == null) {
			// Không tìm thấy sản phẩm → quay lại trang chủ
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		// Lưu vào session để checkout còn biết đang mua cái gì
		HttpSession session = request.getSession();
		session.setAttribute("selectedProduct", p);

		// Đưa vào request để hiển thị trên trang chi tiết
		request.setAttribute("product", p);
		request.getRequestDispatcher("product-detail.jsp").forward(request, response);
	}
}
