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
	        SELECT 
	            ci.variant_id, ci.quantity,
	            v.color, v.size,
	            p.id AS product_id, p.name, p.price, p.image, p.type, p.description, p.quantity AS stock
	        FROM CartItems ci
	        JOIN ProductVariants v ON v.id = ci.variant_id
	        JOIN Products p ON p.id = v.product_id
	        WHERE ci.user_id = ?
	        ORDER BY ci.variant_id
	    """;

	    try (Connection conn = DBConnect.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, userId);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Product p = new Product(
	                        rs.getInt("product_id"),
	                        rs.getString("name"),
	                        rs.getDouble("price"),
	                        rs.getString("image"),
	                        rs.getString("type"),
	                        rs.getString("description"),
	                        rs.getInt("stock")
	                );

	                CartItem ci = new CartItem(p, rs.getInt("quantity"));
	                ci.setVariantId(rs.getInt("variant_id"));
	                ci.setColor(rs.getString("color"));
	                ci.setSize(rs.getString("size"));

	                cart.add(ci);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return cart;
	}

	// Upsert theo (user_id, variant_id)
	public static void add(int userId, int variantId, int qty) {
	    String sql = """
	        MERGE CartItems AS target
	        USING (SELECT ? AS user_id, ? AS variant_id) AS src
	        ON target.user_id = src.user_id AND target.variant_id = src.variant_id
	        WHEN MATCHED THEN
	            UPDATE SET quantity = target.quantity + ?
	        WHEN NOT MATCHED THEN
	            INSERT (user_id, variant_id, quantity) VALUES (?, ?, ?);
	    """;

	    try (Connection conn = DBConnect.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, userId);
	        ps.setInt(2, variantId);
	        ps.setInt(3, qty);
	        ps.setInt(4, userId);
	        ps.setInt(5, variantId);
	        ps.setInt(6, qty);

	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public static void updateQty(int userId, int variantId, int qty) {
	    String sql = "UPDATE CartItems SET quantity = ? WHERE user_id = ? AND variant_id = ?";
	    try (Connection conn = DBConnect.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, qty);
	        ps.setInt(2, userId);
	        ps.setInt(3, variantId);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public static void remove(int userId, int variantId) {
	    String sql = "DELETE FROM CartItems WHERE user_id = ? AND variant_id = ?";
	    try (Connection conn = DBConnect.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, userId);
	        ps.setInt(2, variantId);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public static void clear(int userId) {
	    String sql = "DELETE FROM CartItems WHERE user_id = ?";
	    try (Connection conn = DBConnect.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, userId);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}
 	 	