package controller;

import DAO.KeyDAO;
import DAO.OrderDAO;
import model.User;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SignServlet")
public class SignServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private KeyDAO keyDAO = new KeyDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		User user = (User) session.getAttribute("user");

		if (user == null) {

			response.sendRedirect("login.jsp");
			return;
		}

		Integer orderId = (Integer) session.getAttribute("lastOrderId");

		if (orderId == null) {

			response.sendRedirect("orders");
			return;
		}

		String signature = request.getParameter("signature");

		Integer keyId = keyDAO.getActiveKeyId(user.getId());

		if (keyId == null) {

			response.getWriter().println("Khong tim thay Public Key ACTIVE");
			return;
		}

		boolean ok = OrderDAO.saveSignature(orderId, signature, keyId);

		if (ok) {

			session.removeAttribute("lastOrderId");

			response.sendRedirect(request.getContextPath() + "/orders");

		} else {

			response.getWriter().println("Luu chu ky that bai");
		}
	}
}