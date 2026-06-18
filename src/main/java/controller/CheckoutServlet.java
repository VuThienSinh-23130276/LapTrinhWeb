package controller;

import DAO.CartDAO;
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

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
			return;
		}

		@SuppressWarnings("unchecked")
		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null || cart.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}

		request.getRequestDispatcher("/checkout.jsp").forward(request, response);
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		User user = (User) session.getAttribute("user");
		request.setCharacterEncoding("UTF-8");

		String fullname = request.getParameter("fullname");
		String address = request.getParameter("address");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String paymentMethod = request.getParameter("paymentMethod");

		// Validate cơ bản
		if (fullname == null || address == null || phone == null || email == null) {
			request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null || cart.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}

		// 1. Tạo đơn hàng (Trạng thái mặc định là PENDING, chưa có chữ ký)
		Order order = OrderDAO.createOrder(user, cart, fullname, address.trim(), phone.trim(), email.trim(),
				paymentMethod);

		if (order != null) {
			// 2. Clear giỏ hàng sau khi tạo đơn
			CartDAO.clear(user.getId());
			session.removeAttribute("cart");

			// 3. Lưu thông tin vào Session để trang sign.jsp hiển thị dữ liệu cho Tool
			// Offline ký
			session.setAttribute("lastOrderCode", order.getOrderCode());
			session.setAttribute("lastOrderId", order.getId());
			session.setAttribute("totalPrice", order.getTotal());

			// 4. Gửi email xác nhận
			try {
				MailUtil.sendOrderEmail(getServletContext(), email.trim(), order, cart);
			} catch (Exception e) {
				System.out.println("⚠️ Gửi mail lỗi: " + e.getMessage());
			}

			// 5. Chuyển hướng sang trang yêu cầu Ký số
			response.sendRedirect(request.getContextPath() + "/sign.jsp");
		} else {
			request.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại.");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
		}
	}
}