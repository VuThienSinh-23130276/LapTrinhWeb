package DAO;

import connect.DBConnect;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

	// Tạo mã đơn đơn giản: DH + yyyyMMdd + "-" + id (sau khi insert)
	private static String buildOrderCode(int orderId) {
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
		String date = sdf.format(new java.util.Date());
		return "DH" + date + "-" + orderId;
	}

	public static Order createOrder(User user, List<CartItem> cart, String fullnameInput) {
		if (user == null || cart == null || cart.isEmpty())
			return null;

		double total = 0;
		for (CartItem it : cart)
			total += it.getSubTotal();

		String orderFullname = (fullnameInput != null && !fullnameInput.trim().isEmpty()) ? fullnameInput
				: user.getFullname();

		String insertOrderSql = "INSERT INTO Orders(orderCode, userId, fullname, total) VALUES(?, ?, ?, ?)";
		String updateCodeSql = "UPDATE Orders SET orderCode=? WHERE id=?";
		String insertItemSql = "INSERT INTO OrderItems(orderId, productId, productName, price, quantity, subtotal) "
				+ "VALUES(?, ?, ?, ?, ?, ?)";

		try (Connection con = DBConnect.getConnection()) {
			con.setAutoCommit(false);

			// insert order với code tạm
			int orderId;
			try (PreparedStatement ps = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
				ps.setString(1, "TEMP");
				ps.setInt(2, user.getId());
				ps.setString(3, orderFullname);
				ps.setDouble(4, total);
				ps.executeUpdate();

				try (ResultSet rs = ps.getGeneratedKeys()) {
					if (!rs.next()) {
						con.rollback();
						return null;
					}
					orderId = rs.getInt(1);
				}
			}

			String orderCode = buildOrderCode(orderId);

			// update orderCode
			try (PreparedStatement ps = con.prepareStatement(updateCodeSql)) {
				ps.setString(1, orderCode);
				ps.setInt(2, orderId);
				ps.executeUpdate();
			}

			// insert items
			try (PreparedStatement ps = con.prepareStatement(insertItemSql)) {
				for (CartItem it : cart) {
					ps.setInt(1, orderId);
					ps.setInt(2, it.getProduct().getId());
					ps.setString(3, it.getProduct().getName());
					ps.setDouble(4, it.getProduct().getPrice());
					ps.setInt(5, it.getQuantity());
					ps.setDouble(6, it.getSubTotal());
					ps.addBatch();
				}
				ps.executeBatch();
			}

			con.commit();

			// trả Order
			Order o = new Order();
			o.setId(orderId);
			o.setOrderCode(orderCode);
			o.setUserId(user.getId());
			o.setFullname(user.getFullname());
			o.setTotal(total);
			o.setCreatedAt(new Timestamp(System.currentTimeMillis()));
			return o;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static List<Order> getOrdersByUser(int userId) {
		List<Order> list = new ArrayList<>();
		String sql = "SELECT id, orderCode, userId, fullname, total, createdAt FROM Orders "
				+ "WHERE userId=? ORDER BY id DESC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Order o = new Order(rs.getInt("id"), rs.getString("orderCode"), rs.getInt("userId"),
							rs.getString("fullname"), rs.getDouble("total"), rs.getTimestamp("createdAt"));
					list.add(o);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public static List<OrderItem> getItemsByOrderId(int orderId) {
		List<OrderItem> list = new ArrayList<>();
		String sql = "SELECT id, orderId, productId, productName, price, quantity, subtotal "
				+ "FROM OrderItems WHERE orderId=? ORDER BY id ASC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, orderId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					OrderItem it = new OrderItem(rs.getInt("id"), rs.getInt("orderId"), rs.getInt("productId"),
							rs.getString("productName"), rs.getDouble("price"), rs.getInt("quantity"),
							rs.getDouble("subtotal"));
					list.add(it);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public static Order getOrderById(int orderId) {
		String sql = "SELECT id, orderCode, userId, fullname, total, createdAt FROM Orders WHERE id=?";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, orderId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return new Order(rs.getInt("id"), rs.getString("orderCode"), rs.getInt("userId"),
							rs.getString("fullname"), rs.getDouble("total"), rs.getTimestamp("createdAt"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Lấy tất cả đơn hàng (admin) kèm thông tin username của người đặt.
	 * Trả về Map với key là Order và value là username để JSP hiển thị.
	 */
	public static java.util.Map<Order, String> getAllOrdersWithUsername() {
		java.util.Map<Order, String> map = new java.util.LinkedHashMap<>();
		// JOIN với Users để lấy username
		String sql = "SELECT o.id, o.orderCode, o.userId, o.fullname, o.total, o.createdAt, u.username " +
				"FROM Orders o LEFT JOIN Users u ON o.userId = u.id ORDER BY o.id DESC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Order o = new Order(rs.getInt("id"), rs.getString("orderCode"), rs.getInt("userId"),
							rs.getString("fullname"), rs.getDouble("total"), rs.getTimestamp("createdAt"));
					String username = rs.getString("username");
					map.put(o, username != null ? username : "N/A");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * Lấy tất cả đơn hàng (admin) - giữ nguyên để tương thích.
	 */
	public static List<Order> getAllOrders() {
		List<Order> list = new ArrayList<>();
		String sql = "SELECT id, orderCode, userId, fullname, total, createdAt FROM Orders ORDER BY id DESC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Order o = new Order(rs.getInt("id"), rs.getString("orderCode"), rs.getInt("userId"),
							rs.getString("fullname"), rs.getDouble("total"), rs.getTimestamp("createdAt"));
					list.add(o);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}
