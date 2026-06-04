package controller;

import DAO.KeyDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/KeyManagementServlet")
public class KeyManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private KeyDAO keyDAO = new KeyDAO();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Chuyển hướng về trang keygen để hiển thị giao diện trạng thái
		request.getRequestDispatcher("keygen.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");

		User user = (User) request.getSession().getAttribute("user");
		if (user == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		if ("add".equalsIgnoreCase(action)) {
			String publicKey = request.getParameter("publicKey");
			if (publicKey != null && !publicKey.trim().isEmpty()) {
				// Kiểm tra xem đã có khóa nào active chưa, nếu có thì ép buộc phải revoke trước
				String activeKey = keyDAO.getActivePublicKey(user.getId());
				if (activeKey != null) {
					request.setAttribute("error",
							"Bạn đang có một khóa hoạt động! Vui lòng thu hồi trước khi tạo khóa mới.");
				} else {
					boolean success = keyDAO.insertPublicKey(user.getId(), publicKey.trim());
					if (success) {
						request.setAttribute("message", "Đã lưu và kích hoạt Khóa công khai thành công!");
					} else {
						request.setAttribute("error", "Lỗi hệ thống, không thể lưu khóa.");
					}
				}
			}
		} else if ("revoke".equalsIgnoreCase(action)) {
			boolean success = keyDAO.revokeKey(user.getId());
			if (success) {
				request.setAttribute("message",
						"Đã thu hồi (Revoke) khóa thành công! Hệ thống đã vô hiệu hóa chữ ký cũ.");
			} else {
				request.setAttribute("error", "Không tìm thấy khóa hoạt động nào để thu hồi.");
			}
		}

		request.getRequestDispatcher("keygen.jsp").forward(request, response);
	}
}