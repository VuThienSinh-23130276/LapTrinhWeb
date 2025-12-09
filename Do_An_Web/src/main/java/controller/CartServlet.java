package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.CartItem;
import model.Product;
import repository.ProductRepository;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("unchecked")
	private List<CartItem> getCart(HttpSession session) {
		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null) {
			cart = new ArrayList<>();
			session.setAttribute("cart", cart);
		}
		return cart;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		List<CartItem> cart = getCart(session);

		double total = 0;
		for (CartItem item : cart) {
			total += item.getSubTotal();
		}

		request.setAttribute("cartItems", cart);
		request.setAttribute("total", total);

		request.getRequestDispatcher("jsp/cart.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		HttpSession session = request.getSession();
		List<CartItem> cart = getCart(session);

		if ("add".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			Product p = ProductRepository.findById(id);
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
