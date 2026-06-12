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
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
			return;
		}

		User user = (User) session.getAttribute("user");
		if (user == null) {
			// Yêu cầu đăng nhập trước khi vào trang checkout
			response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
			return;
		}

		// Kiểm tra giỏ hàng có sản phẩm không
		@SuppressWarnings("unchecked")
		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null || cart.isEmpty()) {
			// Nếu giỏ hàng trống, redirect về trang giỏ hàng
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}

		// Set user vào request để JSP có thể hiển thị thông tin
		request.setAttribute("user", user);
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
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String paymentMethod = request.getParameter("paymentMethod");

		// Validate các trường bắt buộc
		if (fullname == null || fullname.trim().isEmpty()) {
			request.setAttribute("error", "Vui lòng nhập họ tên!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}
		if (address == null || address.trim().isEmpty()) {
			request.setAttribute("error", "Vui lòng nhập địa chỉ giao hàng!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}
		if (phone == null || phone.trim().isEmpty()) {
			request.setAttribute("error", "Vui lòng nhập số điện thoại!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}
		if (email == null || email.trim().isEmpty() || !email.contains("@")) {
			request.setAttribute("error", "Vui lòng nhập email hợp lệ!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}
		if (paymentMethod == null || (!paymentMethod.equals("COD") && !paymentMethod.equals("TRANSFER"))) {
			request.setAttribute("error", "Vui lòng chọn phương thức thanh toán!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null || cart.isEmpty()) {
			request.setAttribute("error", "Giỏ hàng đang trống, hãy thêm sản phẩm trước khi thanh toán.");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		// ✅ tạo đơn với đầy đủ thông tin
		Order order = OrderDAO.createOrder(user, cart, fullname, address.trim(), phone.trim(), email.trim(), paymentMethod);
		if (order == null) {
			request.setAttribute("error", "Đặt hàng thất bại (lỗi hệ thống hoặc CSDL). Vui lòng thử lại sau.");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		// Clear cart sau khi tạo đơn thành công
		CartDAO.clear(user.getId()); // Xóa trong database
		session.removeAttribute("cart"); // Xóa trong session
		session.setAttribute("lastOrderCode", order.getOrderCode()); // để show trên success
		session.setAttribute("lastPaymentMethod", paymentMethod); // để hiển thị QR nếu cần

		// Gửi email xác nhận đến email người dùng nhập
		try {
			MailUtil.sendOrderEmail(getServletContext(), email.trim(), order, cart);
		} catch (Exception e) {
			System.out.println("⚠️ Gửi mail lỗi: " + e.getMessage());
		}

		// Nếu thanh toán bằng chuyển khoản, redirect đến trang hiển thị QR code
		if ("TRANSFER".equals(paymentMethod)) {
			response.sendRedirect(request.getContextPath() + "/success?payment=transfer");
		} else {
			response.sendRedirect(request.getContextPath() + "/success");
		}
	}
}
