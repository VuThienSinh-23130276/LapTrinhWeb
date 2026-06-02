package controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.UserKeyDAO;
import model.CartItem;
import model.Order;
import model.User;
import util.MailUtil;
import util.RSAUtil;

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
			response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
			return;
		}

		@SuppressWarnings("unchecked")
		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null || cart.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}

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
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		request.setCharacterEncoding("UTF-8");
		String fullname = request.getParameter("fullname");
		String address = request.getParameter("address");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String paymentMethod = request.getParameter("paymentMethod");

		// 1. Nhận dữ liệu chuỗi hóa đơn gốc và chuỗi chữ ký điện tử từ client gửi lên
		String orderDataString = request.getParameter("orderData");
		String clientSignature = request.getParameter("signature");

		// Validate các trường thông tin giao hàng bắt buộc
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

		// 2. Kiểm tra tính hiện diện của dữ liệu chữ ký số gửi từ form ẩn
		if (orderDataString == null || clientSignature == null || orderDataString.isBlank() || clientSignature.isBlank()) {
			request.setAttribute("error", "Thiếu dữ liệu xác thực đơn hàng hoặc chữ ký điện tử RSA!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null || cart.isEmpty()) {
			request.setAttribute("error", "Giỏ hàng đang trống, hãy thêm sản phẩm trước khi thanh toán.");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
			return;
		}

		try {
			// 3. Lấy Public Key đang kích hoạt và phiên bản khóa lớn nhất của người dùng này
			String activePublicKeyPEM = UserKeyDAO.getActivePublicKey(user.getId());
			int currentVersion = UserKeyDAO.getMaxVersion(user.getId());

			if (activePublicKeyPEM == null) {
				request.setAttribute("error", "Tài khoản của bạn chưa cấu hình chữ ký điện tử. Vui lòng vào mục Tài khoản để tạo mới khóa bảo mật!");
				request.getRequestDispatcher("/checkout.jsp").forward(request, response);
				return;
			}

			// 4. Tiến hành gọi lớp tiện ích RSAUtil giải mã đối chiếu chữ ký số từ Client
			boolean isVerified = RSAUtil.verifyRSASignature(orderDataString, clientSignature, activePublicKeyPEM);

			if (!isVerified) {
				request.setAttribute("error", "Chữ ký số không hợp lệ! Thiết bị của bạn có thể đang sử dụng một khóa cũ đã bị hủy bỏ.");
				request.getRequestDispatcher("/checkout.jsp").forward(request, response);
				return;
			}

			// 5. Xác thực thành công -> Lưu thông tin đơn hàng cùng chữ ký và phiên bản khóa vào Database
			Order order = OrderDAO.createOrder(user, cart, fullname, address.trim(), phone.trim(), email.trim(), paymentMethod, clientSignature, currentVersion);
			
			if (order == null) {
				request.setAttribute("error", "Đặt hàng thất bại (lỗi hệ thống hoặc CSDL). Vui lòng thử lại sau.");
				request.getRequestDispatcher("/checkout.jsp").forward(request, response);
				return;
			}

			// Xóa sạch giỏ hàng khi thủ tục đặt hàng bảo mật hoàn tất
			CartDAO.clear(user.getId()); 
			session.removeAttribute("cart");
			session.setAttribute("lastOrderCode", order.getOrderCode()); 
			session.setAttribute("lastPaymentMethod", paymentMethod); 

			// Gửi email thông báo xác nhận trạng thái đơn hàng
			try {
				MailUtil.sendOrderEmail(getServletContext(), email.trim(), order, cart);
			} catch (Exception e) {
				System.out.println("⚠️ Gửi mail lỗi: " + e.getMessage());
			}

			if ("TRANSFER".equals(paymentMethod)) {
				response.sendRedirect(request.getContextPath() + "/success?payment=transfer");
			} else {
				response.sendRedirect(request.getContextPath() + "/success");
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Lỗi xảy ra trong quá trình kiểm tra thuật toán bảo mật hệ thống!");
			request.getRequestDispatcher("/checkout.jsp").forward(request, response);
		}
	}
}