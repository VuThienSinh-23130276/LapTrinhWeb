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

	public static Order createOrder(User user, List<CartItem> cart, String fullname, String address, String phone,
			String email, String paymentMethod, String signature, int publicKeyVersion) {

// Tự sinh mã đơn hàng tùy theo logic dự án của bạn
		String orderCode = "DH" + System.currentTimeMillis();

// Tính tổng tiền đơn hàng từ danh sách sản phẩm trong giỏ
		double total = 0;
		for (CartItem item : cart) {
			total += item.getSubTotal();
		}

// Bổ sung thêm 3 cột mới: signature, publicKeyVersion, isVerified vào câu lệnh INSERT
		String sqlOrder = "INSERT INTO Orders (orderCode, userId, fullname, address, phone, email, total, paymentMethod, isPaid, createdAt, signature, publicKeyVersion, isVerified) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), ?, ?, 1)";

		try (Connection conn = connect.DBConnect.getConnection()) {
// Chặn tự động commit để chạy giao dịch (Transaction) an toàn cho cả bảng Order và OrderItem
			conn.setAutoCommit(false);

			try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder,
					java.sql.Statement.RETURN_GENERATED_KEYS)) {
				psOrder.setString(1, orderCode);
				psOrder.setInt(2, user.getId());
				psOrder.setString(3, fullname);
				psOrder.setString(4, address);
				psOrder.setString(5, phone);
				psOrder.setString(6, email);
				psOrder.setDouble(7, total);
				psOrder.setString(8, paymentMethod);
				psOrder.setString(9, signature);
				psOrder.setInt(10, publicKeyVersion);

				int affectedRows = psOrder.executeUpdate();
				if (affectedRows == 0) {
					conn.rollback();
					return null;
				}

				int orderId = 0;
				try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						orderId = generatedKeys.getInt(1);
					}
				}

// Thực hiện lặp để lưu chi tiết từng sản phẩm vào bảng OrderItems của bạn
				String sqlItem = "INSERT INTO OrderItems (orderId, variantId, quantity, price) VALUES (?, ?, ?, ?)";
				try (PreparedStatement psItem = conn.prepareStatement(sqlItem)) {
					for (CartItem item : cart) {
						psItem.setInt(1, orderId);
						psItem.setInt(2, item.getVariantId());
						psItem.setInt(3, item.getQuantity());
						psItem.setDouble(4, item.getProduct().getPrice()); // Hoặc hàm lấy giá tương ứng của bạn
						psItem.addBatch();
					}
					psItem.executeBatch();
				}

				conn.commit();

// Dựng lại và trả về đối tượng Order hoàn chỉnh
				Order order = new Order();
				order.setId(orderId);
				order.setOrderCode(orderCode);
				order.setUserId(user.getId());
				order.setTotal(total);
				order.setSignature(signature);
				order.setPublicKeyVersion(publicKeyVersion);
				return order;

			} catch (Exception e) {
				conn.rollback();
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static List<Order> getOrdersByUser(int userId) {
		List<Order> list = new ArrayList<>();
		String sql = "SELECT id, orderCode, userId, fullname, address, phone, email, total, createdAt, paymentMethod, isPaid FROM Orders "
				+ "WHERE userId=? ORDER BY id DESC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Order o = new Order();
					o.setId(rs.getInt("id"));
					o.setOrderCode(rs.getString("orderCode"));
					o.setUserId(rs.getInt("userId"));
					o.setFullname(rs.getString("fullname"));
					o.setAddress(rs.getString("address"));
					o.setPhone(rs.getString("phone"));
					o.setEmail(rs.getString("email"));
					o.setTotal(rs.getDouble("total"));
					o.setCreatedAt(rs.getTimestamp("createdAt"));
					String pm = rs.getString("paymentMethod");
					o.setPaymentMethod(pm != null ? pm : "COD");
					o.setPaid(rs.getBoolean("isPaid"));
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
		String sql = "SELECT id, orderCode, userId, fullname, address, phone, email, total, createdAt, paymentMethod, isPaid FROM Orders WHERE id=?";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, orderId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					Order o = new Order();
					o.setId(rs.getInt("id"));
					o.setOrderCode(rs.getString("orderCode"));
					o.setUserId(rs.getInt("userId"));
					o.setFullname(rs.getString("fullname"));
					o.setAddress(rs.getString("address"));
					o.setPhone(rs.getString("phone"));
					o.setEmail(rs.getString("email"));
					o.setTotal(rs.getDouble("total"));
					o.setCreatedAt(rs.getTimestamp("createdAt"));
					String pm = rs.getString("paymentMethod");
					o.setPaymentMethod(pm != null ? pm : "COD");
					o.setPaid(rs.getBoolean("isPaid"));
					return o;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Lấy tất cả đơn hàng (admin) kèm thông tin username của người đặt. Trả về Map
	 * với key là Order và value là username để JSP hiển thị.
	 */
	public static java.util.Map<Order, String> getAllOrdersWithUsername() {
		java.util.Map<Order, String> map = new java.util.LinkedHashMap<>();
		// JOIN với Users để lấy username
		String sql = "SELECT o.id, o.orderCode, o.userId, o.fullname, o.address, o.phone, o.email, o.total, o.createdAt, o.paymentMethod, o.isPaid, u.username "
				+ "FROM Orders o LEFT JOIN Users u ON o.userId = u.id ORDER BY o.id DESC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Order o = new Order();
					o.setId(rs.getInt("id"));
					o.setOrderCode(rs.getString("orderCode"));
					o.setUserId(rs.getInt("userId"));
					o.setFullname(rs.getString("fullname"));
					o.setAddress(rs.getString("address"));
					o.setPhone(rs.getString("phone"));
					o.setEmail(rs.getString("email"));
					o.setTotal(rs.getDouble("total"));
					o.setCreatedAt(rs.getTimestamp("createdAt"));
					String pm = rs.getString("paymentMethod");
					o.setPaymentMethod(pm != null ? pm : "COD");
					o.setPaid(rs.getBoolean("isPaid"));
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
		String sql = "SELECT id, orderCode, userId, fullname, address, phone, email, total, createdAt, paymentMethod, isPaid FROM Orders ORDER BY id DESC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Order o = new Order();
					o.setId(rs.getInt("id"));
					o.setOrderCode(rs.getString("orderCode"));
					o.setUserId(rs.getInt("userId"));
					o.setFullname(rs.getString("fullname"));
					o.setAddress(rs.getString("address"));
					o.setPhone(rs.getString("phone"));
					o.setEmail(rs.getString("email"));
					o.setTotal(rs.getDouble("total"));
					o.setCreatedAt(rs.getTimestamp("createdAt"));
					String pm = rs.getString("paymentMethod");
					o.setPaymentMethod(pm != null ? pm : "COD");
					o.setPaid(rs.getBoolean("isPaid"));
					list.add(o);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}
