package controller;

import DAO.ProductDAO;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String type = request.getParameter("type");
		if (type == null || type.isBlank()) {
			type = "new";
		}

		// Lọc theo type (new/hot/like)
		List<Product> products = ProductDAO.getByType(type);

		// Nếu DB chưa set type (hoặc type không khớp), fallback sang lấy tất cả để
		// trang không bị trống
		if (products == null || products.isEmpty()) {
			products = ProductDAO.getAll();
		}

		request.setAttribute("products", products);
		request.setAttribute("type", type);

		request.getRequestDispatcher("home.jsp").forward(request, response);
	}
}
