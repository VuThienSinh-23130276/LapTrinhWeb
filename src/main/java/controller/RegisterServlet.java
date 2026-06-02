package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.UserDAO;
import model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String fullname = request.getParameter("fullname");

		// Validate
		if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()
				|| fullname == null || fullname.trim().isEmpty()) {

			request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
			request.getRequestDispatcher("register.jsp").forward(request, response);
			return;
		}

		try {
			UserDAO dao = new UserDAO();

			// check user da ton tai hay chua
			if (dao.checkUsername(username)) {
				request.setAttribute("error", "Username đã tồn tại!");
				request.getRequestDispatcher("register.jsp").forward(request, response);
				return;
			}

			// tao user moi
			User user = new User();
			user.setUsername(username);
			user.setPassword(password);
			user.setFullname(fullname); 

			boolean success = dao.register(user);

			if (success) {
				request.setAttribute("success", "Đăng ký thành công!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
			} else {
				request.setAttribute("error", "Đăng ký thất bại!");
				request.getRequestDispatcher("register.jsp").forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Lỗi: " + e.getMessage());
			request.getRequestDispatcher("register.jsp").forward(request, response);
		}
	}
}