package controller;

import DAO.ProductDAO;
import model.Product;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/products")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class ProductAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String[] ALLOWED_TYPES = { "image/jpeg", "image/png", "image/jpg" };

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
		case "edit" -> {
			String idStr = request.getParameter("id");
			if (idStr != null) {
				try {
					int id = Integer.parseInt(idStr);
					Product p = ProductDAO.getById(id);
					if (p != null) {
						request.setAttribute("product", p);
						request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
						return;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			response.sendRedirect(request.getContextPath() + "/admin/products");
		}
		case "delete" -> {
			String idStr = request.getParameter("id");
			if (idStr != null) {
				try {
					int id = Integer.parseInt(idStr);
					if (ProductDAO.delete(id)) {
						request.setAttribute("success", "Xóa sản phẩm thành công!");
					} else {
						request.setAttribute("error", "Xóa sản phẩm thất bại!");
					}
				} catch (Exception e) {
					request.setAttribute("error", "Lỗi: " + e.getMessage());
				}
			}
			// Fall through to list
		}
		default -> {
			request.setAttribute("products", ProductDAO.getAll());
			request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
		}
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		User user = session == null ? null : (User) session.getAttribute("user");

		if (user == null || !user.isAdmin()) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");
		if (action == null)
			action = "update";

		List<String> errors = new ArrayList<>();

		String idStr = request.getParameter("id");
		int id = 0;
		try {
			id = Integer.parseInt(idStr);
		} catch (Exception e) {
			errors.add("ID sản phẩm không hợp lệ.");
		}

		String name = safe(request.getParameter("name"));
		String type = safe(request.getParameter("type"));
		String description = safe(request.getParameter("description"));
		String priceStr = safe(request.getParameter("price"));
		String quantityStr = safe(request.getParameter("quantity"));

		if (name.isBlank())
			errors.add("Tên sản phẩm không được để trống.");
		if (type.isBlank())
			type = "new";

		double price = 0;
		try {
			price = Double.parseDouble(priceStr);
			if (price <= 0)
				errors.add("Giá phải lớn hơn 0.");
		} catch (Exception e) {
			errors.add("Giá không hợp lệ.");
		}

		int quantity = 0;
		try {
			quantity = Integer.parseInt(quantityStr);
			if (quantity < 0)
				errors.add("Số lượng không được âm.");
		} catch (Exception e) {
			errors.add("Số lượng không hợp lệ.");
		}

		Product product = ProductDAO.getById(id);
		if (product == null) {
			errors.add("Không tìm thấy sản phẩm.");
		}

		// Xử lý upload ảnh (nếu có)
		String imagePath = product != null ? product.getImage() : null;
		try {
			Part imagePart = request.getPart("image");
			if (imagePart != null && imagePart.getSize() > 0) {
				String contentType = imagePart.getContentType();
				boolean allowed = false;
				for (String t : ALLOWED_TYPES) {
					if (t.equalsIgnoreCase(contentType)) {
						allowed = true;
						break;
					}
				}
				if (!allowed) {
					errors.add("File phải là ảnh PNG/JPG.");
				} else if (imagePart.getSize() > 2 * 1024 * 1024) {
					errors.add("Ảnh vượt quá 2MB.");
				} else {
					String uploadsDir = getServletContext().getRealPath("/images/uploads");
					File dir = new File(uploadsDir);
					if (!dir.exists())
						dir.mkdirs();

					String submittedName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
					String ext = "";
					int dot = submittedName.lastIndexOf('.');
					if (dot >= 0)
						ext = submittedName.substring(dot);
					String storedFileName = UUID.randomUUID().toString() + ext;
					File saved = new File(dir, storedFileName);
					imagePart.write(saved.getAbsolutePath());
					imagePath = "uploads/" + storedFileName;
				}
			}
		} catch (Exception e) {
			// Không có file upload hoặc lỗi → giữ nguyên ảnh cũ
		}

		if (!errors.isEmpty()) {
			request.setAttribute("errors", errors);
			if (product != null)
				request.setAttribute("product", product);
			request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
			return;
		}

		// Cập nhật
		product.setName(name);
		product.setPrice(price);
		product.setType(type);
		product.setDescription(description);
		product.setQuantity(quantity);
		if (imagePath != null)
			product.setImage(imagePath);

		if (ProductDAO.update(product)) {
			request.setAttribute("success", "Cập nhật sản phẩm thành công!");
		} else {
			request.setAttribute("error", "Cập nhật sản phẩm thất bại!");
		}
		request.setAttribute("product", product);
		request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
	}

	private String safe(String input) {
		return input == null ? "" : input.trim();
	}
}
