package DAO;

import connect.DBConnect;
import model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

	public static List<Product> getAll() {
		List<Product> list = new ArrayList<>();
		String sql = "SELECT id, name, price, image, type, description, quantity FROM Products";
		Connection conn = null;
		try {
			conn = DBConnect.getConnection();
			if (conn == null) {
				System.err.println("❌ ProductDAO.getAll(): Kết nối database là null!");
				return list;
			}
			
			try (PreparedStatement ps = conn.prepareStatement(sql);
					ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}
			System.out.println("✅ ProductDAO.getAll(): Lấy được " + list.size() + " sản phẩm");
		} catch (Exception e) {
			System.err.println("❌ ProductDAO.getAll(): Lỗi khi lấy sản phẩm:");
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return list;
	}

	public static List<Product> getByType(String type) {
		List<Product> list = new ArrayList<>();
		String sql = "SELECT id, name, price, image, type, description, quantity FROM Products WHERE type = ?";
		Connection conn = null;
		try {
			conn = DBConnect.getConnection();
			if (conn == null) {
				System.err.println("❌ ProductDAO.getByType(): Kết nối database là null!");
				return list;
			}
			
			try (PreparedStatement ps = conn.prepareStatement(sql)) {
				ps.setString(1, type);
				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						list.add(mapRow(rs));
					}
				}
			}
			System.out.println("✅ ProductDAO.getByType(" + type + "): Lấy được " + list.size() + " sản phẩm");
		} catch (Exception e) {
			System.err.println("❌ ProductDAO.getByType(" + type + "): Lỗi khi lấy sản phẩm:");
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return list;
	}

	public static Product getById(int id) {
		String sql = "SELECT id, name, price, image, type, description, quantity FROM Products WHERE id = ?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return mapRow(rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Tạo sản phẩm mới (dùng cho form upload).
	 */
	public static Product create(Product product) {
		String sql = "INSERT INTO Products(name, price, image, type, description, quantity) VALUES (?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnect.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setString(1, product.getName());
			ps.setDouble(2, product.getPrice());
			ps.setString(3, product.getImage());
			ps.setString(4, product.getType());
			ps.setString(5, product.getDescription());
			ps.setInt(6, product.getQuantity());

			int affected = ps.executeUpdate();
			if (affected > 0) {
				try (ResultSet rs = ps.getGeneratedKeys()) {
					if (rs.next()) {
						product.setId(rs.getInt(1));
					}
				}
				return product;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Cập nhật sản phẩm (admin).
	 */
	public static boolean update(Product product) {
		String sql = "UPDATE Products SET name=?, price=?, image=?, type=?, description=?, quantity=? WHERE id=?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, product.getName());
			ps.setDouble(2, product.getPrice());
			ps.setString(3, product.getImage());
			ps.setString(4, product.getType());
			ps.setString(5, product.getDescription());
			ps.setInt(6, product.getQuantity());
			ps.setInt(7, product.getId());
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * Xóa sản phẩm (admin).
	 */
	public static boolean delete(int id) {
		String sql = "DELETE FROM Products WHERE id=?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// ✅ NEW: kiểm tra & trừ tồn kho trong transaction
	// Trả true nếu trừ được, false nếu không đủ hàng
	public static boolean decreaseStock(Connection conn, int productId, int qty) throws Exception {
		// Khóa row để tránh race-condition
		String checkSql = "SELECT quantity FROM Products WITH (UPDLOCK, ROWLOCK) WHERE id = ?";
		try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
			ps.setInt(1, productId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return false;
				int stock = rs.getInt("quantity");

				// stock < 0 => coi như không quản lý tồn kho
				if (stock < 0)
					return true;

				if (stock < qty)
					return false;
			}
		}

		String updateSql = "UPDATE Products SET quantity = quantity - ? WHERE id = ?";
		try (PreparedStatement ps2 = conn.prepareStatement(updateSql)) {
			ps2.setInt(1, qty);
			ps2.setInt(2, productId);
			ps2.executeUpdate();
		}
		return true;
	}

	private static Product mapRow(ResultSet rs) throws Exception {
		// nếu bạn chưa chạy ALTER ADD quantity thì sẽ lỗi.
		// nhưng ở trên mình đã sửa query SELECT ... quantity rồi, nên nhớ chạy SQL phần
		// 0.
		return new Product(rs.getInt("id"), rs.getString("name"), rs.getDouble("price"), rs.getString("image"),
				rs.getString("type"), rs.getString("description"), rs.getInt("quantity"));
	}
}
