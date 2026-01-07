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
		List<Product> products;
		
		// Nếu không có param type → hiển thị TẤT CẢ sản phẩm
		if (type == null || type.isBlank()) {
			System.out.println("🔍 HomeServlet: Lấy tất cả sản phẩm");
			products = ProductDAO.getAll();
			type = "all"; // Để JSP biết đang hiển thị tất cả
		} else {
			// Có param type → lọc theo type (new/hot/like)
			System.out.println("🔍 HomeServlet: Lấy sản phẩm theo type = " + type);
			products = ProductDAO.getByType(type);
			// Nếu không có sản phẩm theo type → fallback sang tất cả
			if (products == null || products.isEmpty()) {
				System.out.println("⚠️ HomeServlet: Không có sản phẩm type=" + type + ", fallback sang tất cả");
				products = ProductDAO.getAll();
				type = "all";
			}
		}

		System.out.println("📦 HomeServlet: Trả về " + (products != null ? products.size() : 0) + " sản phẩm");
		request.setAttribute("products", products);
		request.setAttribute("type", type);

		request.getRequestDispatcher("home.jsp").forward(request, response);
	}
}
