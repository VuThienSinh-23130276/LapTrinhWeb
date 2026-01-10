package controller;

import DAO.ProductDAO;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Product product = ProductDAO.getById(id);
        if (product == null) {
            request.setAttribute("product", null);
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);
            return;
        }

        // colors
        List<String> colors = ProductDAO.getColors(id);
        if (colors == null || colors.isEmpty()) {
            colors = java.util.List.of("Mặc định");
        }

        // JSON strings (phải là JSON hợp lệ)
        String sizesJson = ProductDAO.getSizesByColorJson(id);
        if (sizesJson == null || sizesJson.trim().isEmpty()) sizesJson = "{}";

        String imagesJson = ProductDAO.getImagesByColorJson(id);
        if (imagesJson == null || imagesJson.trim().isEmpty()) imagesJson = "{}";

        request.setAttribute("product", product);
        request.setAttribute("colors", colors);
        request.setAttribute("sizesJson", sizesJson);
        request.setAttribute("imagesJson", imagesJson);

        request.getRequestDispatcher("product-detail.jsp").forward(request, response);
    }
}
