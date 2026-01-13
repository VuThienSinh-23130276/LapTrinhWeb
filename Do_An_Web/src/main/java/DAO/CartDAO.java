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
	    // Kiểm tra xem đã có variant_id này trong giỏ chưa
	    String checkSql = "SELECT quantity FROM CartItems WHERE user_id = ? AND variant_id = ?";
	    
	    try (Connection conn = DBConnect.getConnection()) {
	        // Kiểm tra xem đã có chưa
	        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
	            checkPs.setInt(1, userId);
	            checkPs.setInt(2, variantId);
	            
	            try (ResultSet rs = checkPs.executeQuery()) {
	                if (rs.next()) {
	                    // Đã có -> update quantity
	                    int existingQty = rs.getInt("quantity");
	                    int newQty = existingQty + qty;
	                    
	                    String updateSql = "UPDATE CartItems SET quantity = ? WHERE user_id = ? AND variant_id = ?";
	                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
	                        updatePs.setInt(1, newQty);
	                        updatePs.setInt(2, userId);
	                        updatePs.setInt(3, variantId);
	                        updatePs.executeUpdate();
	                    }
	                } else {
	                    // Chưa có -> insert mới (chỉ cần user_id, variant_id, quantity)
	                    String insertSql = "INSERT INTO CartItems (user_id, variant_id, quantity) VALUES (?, ?, ?)";
	                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
	                        insertPs.setInt(1, userId);
	                        insertPs.setInt(2, variantId);
	                        insertPs.setInt(3, qty);
	                        insertPs.executeUpdate();
	                    }
	                }
	            }
	        }
	    } catch (Exception e) {
	        System.err.println("❌ Error in CartDAO.add():");
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
 	 	