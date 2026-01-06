package controller;

import DAO.CartDAO;
import DAO.ProductDAO;
import model.CartItem;
import model.Product;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
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
		User user = (User) session.getAttribute("user");

		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null)
			cart = new ArrayList<>();

		// ✅ nếu user đã login -> load giỏ từ DB (ưu tiên DB)
		if (user != null) {
			cart = CartDAO.loadCart(user.getId());
			session.setAttribute("cart", cart);
		} else {
			session.setAttribute("cart", cart);
		}

		request.setAttribute("cartItems", cart);

		double total = 0;
		for (CartItem item : cart)
			total += item.getSubTotal();
		request.setAttribute("total", total);

		request.getRequestDispatcher("cart.jsp").forward(request, response);
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");

		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null) {
			cart = new ArrayList<>();
			session.setAttribute("cart", cart);
		}

		String action = request.getParameter("action");
		if (action == null)
			action = "add";

		int id = Integer.parseInt(request.getParameter("id"));

		switch (action) {
		case "add" -> {
			int qty = 1;
			String qtyStr = request.getParameter("qty");
			if (qtyStr != null && !qtyStr.trim().isEmpty()) {
				try {
					qty = Integer.parseInt(qtyStr.trim());
					if (qty <= 0)
						qty = 1;
				} catch (Exception ignored) {
					qty = 1;
				}
			}

			Product p = ProductDAO.getById(id);
			if (p != null) {
				boolean found = false;
				for (CartItem item : cart) {
					if (item.getProduct().getId() == id) {
						item.setQuantity(item.getQuantity() + qty);
						found = true;
						break;
					}
				}
				if (!found)
					cart.add(new CartItem(p, qty));
			}

			// ✅ sync DB nếu login
			if (user != null)
				CartDAO.add(user.getId(), id, qty);
		}

		case "inc" -> {
			for (CartItem item : cart) {
				if (item.getProduct().getId() == id) {
					item.setQuantity(item.getQuantity() + 1);
					break;
				}
			}
			if (user != null)
				CartDAO.add(user.getId(), id, 1);
		}

		case "dec" -> {
			CartItem target = null;
			for (CartItem item : cart) {
				if (item.getProduct().getId() == id) {
					target = item;
					break;
				}
			}
			if (target != null) {
				int newQty = target.getQuantity() - 1;
				if (newQty <= 0) {
					cart.remove(target);
					if (user != null)
						CartDAO.remove(user.getId(), id);
				} else {
					target.setQuantity(newQty);
					if (user != null)
						CartDAO.updateQty(user.getId(), id, newQty);
				}
			}
		}

		case "update" -> {
			int qty;
			try {
				qty = Integer.parseInt(request.getParameter("qty"));
			} catch (Exception e) {
				qty = 1;
			}

			if (qty <= 0) {
				cart.removeIf(item -> item.getProduct().getId() == id);
				if (user != null)
					CartDAO.remove(user.getId(), id);
			} else {
				for (CartItem item : cart) {
					if (item.getProduct().getId() == id) {
						item.setQuantity(qty);
						break;
					}
				}
				if (user != null)
					CartDAO.updateQty(user.getId(), id, qty);
			}
		}

		case "remove" -> {
			cart.removeIf(item -> item.getProduct().getId() == id);
			if (user != null)
				CartDAO.remove(user.getId(), id);
		}
		}

		response.sendRedirect(request.getHeader("Referer"));

	}
}
