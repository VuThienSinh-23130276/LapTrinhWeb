package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import repository.ProductRepository;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Lấy danh sách sản phẩm để hiển thị trên trang chủ
		request.setAttribute("products", ProductRepository.findAll());
		request.getRequestDispatcher("home.jsp").forward(request, response);
	}
}
