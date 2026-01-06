package controller;

import DAO.OrderDAO;
import model.Order;
import model.OrderItem;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class OrderAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		User user = session == null ? null : (User) session.getAttribute("user");

		if (user == null || !user.isAdmin()) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		String action = request.getParameter("action");
		if (action == null)
			action = "list";

		switch (action) {
		case "detail" -> {
			String idStr = request.getParameter("id");
			if (idStr != null) {
				try {
					int orderId = Integer.parseInt(idStr);
					Order order = OrderDAO.getOrderById(orderId);
					if (order != null) {
						List<OrderItem> items = OrderDAO.getItemsByOrderId(orderId);
						request.setAttribute("order", order);
						request.setAttribute("items", items);
						request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
						return;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			response.sendRedirect(request.getContextPath() + "/admin/orders");
		}
		default -> {
			java.util.Map<Order, String> ordersMap = OrderDAO.getAllOrdersWithUsername();
			request.setAttribute("ordersMap", ordersMap);
			request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
		}
		}
	}
}
