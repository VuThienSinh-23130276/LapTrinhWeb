package DAO;

import connect.DBConnect;
import model.CartItem;
import model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

	public static List<CartItem> loadCart(int userId) {
		List<CartItem> cart = new ArrayList<>();
		String sql = """
				    SELECT ci.product_id, ci.quantity,
				           p.id, p.name, p.price, p.image, p.type, p.description, p.quantity AS stock
				    FROM CartItems ci
				    JOIN Products p ON p.id = ci.product_id
				    WHERE ci.user_id = ?
				""";

		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Product p = new Product(rs.getInt("id"), rs.getString("name"), rs.getDouble("price"),
							rs.getString("image"), rs.getString("type"), rs.getString("description"),
							rs.getInt("stock"));
					cart.add(new CartItem(p, rs.getInt("quantity")));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return cart;
	}

	// Upsert: có rồi thì cộng thêm, chưa có thì insert
	public static void add(int userId, int productId, int qty) {
		String sql = """
				    MERGE CartItems AS target
				    USING (SELECT ? AS user_id, ? AS product_id) AS src
				    ON target.user_id = src.user_id AND target.product_id = src.product_id
				    WHEN MATCHED THEN
				        UPDATE SET quantity = target.quantity + ?
				    WHEN NOT MATCHED THEN
				        INSERT (user_id, product_id, quantity) VALUES (?, ?, ?);
				""";

		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			ps.setInt(2, productId);
			ps.setInt(3, qty);
			ps.setInt(4, userId);
			ps.setInt(5, productId);
			ps.setInt(6, qty);

			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateQty(int userId, int productId, int qty) {
		String sql = "UPDATE CartItems SET quantity = ? WHERE user_id = ? AND product_id = ?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, qty);
			ps.setInt(2, userId);
			ps.setInt(3, productId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void remove(int userId, int productId) {
		String sql = "DELETE FROM CartItems WHERE user_id = ? AND product_id = ?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setInt(2, productId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void clear(int userId) {
		String sql = "DELETE FROM CartItems WHERE user_id = ?";
		try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
