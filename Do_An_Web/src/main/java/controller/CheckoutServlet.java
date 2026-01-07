package controller;

import DAO.OrderDAO;
import model.CartItem;
import model.Order;
import model.User;
import util.MailUtil;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.getRequestDispatcher("/checkout.jsp").forward(request, response);
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		User user = (User) session.getAttribute("user");
		if (user == null) {
			// bắt buộc đăng nhập mới checkout để có lịch sử mua hàng
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		request.setCharacterEncoding("UTF-8");
		String fullname = request.getParameter("fullname");
		String address = request.getParameter("address");

		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null || cart.isEmpty()) {
			request.setAttribute("error", "Giỏ hàng đang trống, hãy thêm sản phẩm trước khi thanh toán.");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		// ✅ tạo đơn (ưu tiên fullname người nhập)
		Order order = OrderDAO.createOrder(user, cart, fullname);
		if (order == null) {
			request.setAttribute("error", "Đặt hàng thất bại (lỗi hệ thống hoặc CSDL). Vui lòng thử lại sau.");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		// clear cart sau khi tạo đơn
		session.removeAttribute("cart");
		session.setAttribute("lastOrderCode", order.getOrderCode()); // để show trên success

		// Gửi email xác nhận (username được coi là email)
		try {
			MailUtil.sendOrderEmail(getServletContext(), user.getUsername(), order, cart, address);
		} catch (Exception e) {
			System.out.println("⚠️ Gửi mail lỗi: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/success");
	}
}
