package controller;

import DAO.ProductDAO;
import model.CartItem;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("unchecked")
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null) {
			cart = new ArrayList<>();
			session.setAttribute("cart", cart);
		}

		request.setAttribute("cart", cart);
		request.getRequestDispatcher("cart.jsp").forward(request, response);
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null) {
			cart = new ArrayList<>();
			session.setAttribute("cart", cart);
		}

		String action = request.getParameter("action");
		if (action == null)
			action = "add";

		if ("add".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			Product p = ProductDAO.getById(id);

			if (p != null) {
				boolean found = false;
				for (CartItem item : cart) {
					if (item.getProduct().getId() == id) {
						item.setQuantity(item.getQuantity() + 1);
						found = true;
						break;
					}
				}
				if (!found) {
					cart.add(new CartItem(p, 1));
				}
			}
		} else if ("remove".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			cart.removeIf(item -> item.getProduct().getId() == id);
		}

		response.sendRedirect(request.getContextPath() + "/cart");
	}
}
