package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// JSP nằm trực tiếp trong webapp → thêm dấu / ở đầu
		request.getRequestDispatcher("/checkout.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		session.removeAttribute("cart");
		session.removeAttribute("selectedProduct"); // nếu có dùng

		// Sau khi xử lý xong → redirect tới /success (SuccessServlet)
		response.sendRedirect(request.getContextPath() + "/success");
	}
}
