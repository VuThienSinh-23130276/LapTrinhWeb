package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import DAO.ProductDAO;
import model.Product;
import model.User;

@WebServlet("/product-upload")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB in memory
		maxFileSize = 2 * 1024 * 1024, // 2MB/file
		maxRequestSize = 3 * 1024 * 1024 // 3MB tổng
)
public class ProductUploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String[] ALLOWED_TYPES = { "image/jpeg", "image/png", "image/jpg" };

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		User user = session == null ? null : (User) session.getAttribute("user");
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}
		// Chỉ admin mới được upload
		if (!user.isAdmin()) {
			request.setAttribute("error", "Chỉ tài khoản admin mới được đăng sản phẩm!");
			request.getRequestDispatcher("/home").forward(request, response);
			return;
		}
		request.getRequestDispatcher("/product-upload.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = session == null ? null : (User) session.getAttribute("user");
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}
		// Chỉ admin mới được upload
		if (!user.isAdmin()) {
			request.setAttribute("error", "Chỉ tài khoản admin mới được đăng sản phẩm!");
			request.getRequestDispatcher("/home").forward(request, response);
			return;
		}

		request.setCharacterEncoding("UTF-8");

		List<String> errors = new ArrayList<>();

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

		Part imagePart = null;
		try {
			imagePart = request.getPart("image");
		} catch (Exception e) {
			errors.add("Không đọc được file ảnh.");
		}

		String storedFileName = null;
		if (imagePart == null || imagePart.getSize() == 0) {
			errors.add("Vui lòng chọn ảnh sản phẩm.");
		} else {
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
			}

			if (imagePart.getSize() > 2 * 1024 * 1024) {
				errors.add("Ảnh vượt quá 2MB.");
			}
		}

		if (!errors.isEmpty()) {
			request.setAttribute("errors", errors);
			request.getRequestDispatcher("/product-upload.jsp").forward(request, response);
			return;
		}

		// Lưu file
		String uploadsDir = getServletContext().getRealPath("/images/uploads");
		File dir = new File(uploadsDir);
		if (!dir.exists()) {
			dir.mkdirs();
		}

		String submittedName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
		String ext = "";
		int dot = submittedName.lastIndexOf('.');
		if (dot >= 0) {
			ext = submittedName.substring(dot);
		}
		storedFileName = UUID.randomUUID().toString() + ext;
		File saved = new File(dir, storedFileName);
		imagePart.write(saved.getAbsolutePath());

		// Lưu DB
		Product p = new Product();
		p.setName(name);
		p.setPrice(price);
		p.setType(type);
		p.setDescription(description);
		p.setQuantity(quantity);
		p.setImage("uploads/" + storedFileName); // để JSP dùng images/${p.image}

		Product created = ProductDAO.create(p);
		if (created == null) {
			errors.add("Tạo sản phẩm thất bại. Vui lòng thử lại.");
			request.setAttribute("errors", errors);
			request.getRequestDispatcher("/product-upload.jsp").forward(request, response);
			return;
		}

		request.setAttribute("success", "Đăng sản phẩm thành công!");
		request.setAttribute("product", created);
		request.getRequestDispatcher("/product-upload.jsp").forward(request, response);
	}

	private String safe(String input) {
		return input == null ? "" : input.trim();
	}
}
