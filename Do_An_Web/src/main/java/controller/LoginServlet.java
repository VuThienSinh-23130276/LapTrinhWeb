package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import DAO.CartDAO;
import DAO.UserDAO;
import model.CartItem;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		UserDAO dao = new UserDAO();
		User user = dao.checkLogin(username, password);

		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("user", user);

			// ✅ merge giỏ khách (session) vào DB rồi load lại
			@SuppressWarnings("unchecked")
			List<CartItem> guestCart = (List<CartItem>) session.getAttribute("cart");
			if (guestCart != null && !guestCart.isEmpty()) {
				for (CartItem item : guestCart) {
					// Sử dụng variantId thay vì productId
					if (item.getVariantId() > 0) {
						CartDAO.add(user.getId(), item.getVariantId(), item.getQuantity());
					}
				}
			}

			// ✅ load cart từ DB vào session
			session.setAttribute("cart", CartDAO.loadCart(user.getId()));

			// Kiểm tra redirect parameter
			String redirect = request.getParameter("redirect");
			if ("checkout".equals(redirect)) {
				response.sendRedirect(request.getContextPath() + "/checkout");
			} else if ("cart".equals(redirect)) {
				response.sendRedirect(request.getContextPath() + "/cart");
			} else {
				response.sendRedirect(request.getContextPath() + "/home");
			}
		} else {
			request.setAttribute("error", "Sai username hoặc password!");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
	}
}
