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
				String activeKey = keyDAO.getActivePublicKey(user.getId());
				if (activeKey != null) {
					request.setAttribute("error", "Bạn đang có khóa hoạt động! Vui lòng thu hồi trước.");
				} else {
					boolean success = keyDAO.insertPublicKey(user.getId(), publicKey.trim());
					request.setAttribute(success ? "message" : "error",
							success ? "Đã lưu Public Key!" : "Lỗi hệ thống.");
				}
			}
		} else if ("revoke".equalsIgnoreCase(action)) {
			boolean success = keyDAO.revokeKey(user.getId());
			request.setAttribute(success ? "message" : "error", success ? "Đã thu hồi khóa!" : "Không tìm thấy khóa.");
		}
		request.getRequestDispatcher("keygen.jsp").forward(request, response);
	}
}