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
        String category = request.getParameter("category");

        if (type == null || type.isBlank()) type = "all";
        if (category == null || category.isBlank()) category = "all";

        // để render menu category (nếu bạn đang dùng)
        request.setAttribute("categories", ProductDAO.getAllCategories());

        List<Product> products;

        // ====== FILTER ======
        if ("all".equalsIgnoreCase(type) && "all".equalsIgnoreCase(category)) {
            products = ProductDAO.getAll();
        } else if (!"all".equalsIgnoreCase(type) && "all".equalsIgnoreCase(category)) {
            products = ProductDAO.getByType(type);
        } else if ("all".equalsIgnoreCase(type) && !"all".equalsIgnoreCase(category)) {
            products = ProductDAO.getByCategory(category);
        } else {
            products = ProductDAO.getByTypeAndCategory(type, category);
        }

        request.setAttribute("products", products);
        request.setAttribute("type", type);
        request.setAttribute("category", category);

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
