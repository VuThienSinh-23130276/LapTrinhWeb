package DAO;

import connect.DBConnect;
import model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;



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
	// Lấy màu còn hàng (stock > 0) để tránh màu có nhưng size rỗng
public static List<String> getColors(int productId) {
    List<String> colors = new ArrayList<>();
    String sql = """
        SELECT DISTINCT color
        FROM ProductVariants
        WHERE product_id = ? AND stock > 0
        ORDER BY color
    """;

    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                colors.add(rs.getString("color"));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return colors;
}

// Map màu -> size còn hàng
public static Map<String, List<String>> getSizesByColor(int productId) {
    Map<String, List<String>> map = new LinkedHashMap<>();
    String sql = """
        SELECT color, size
        FROM ProductVariants
        WHERE product_id = ? AND stock > 0
        ORDER BY color, size
    """;

    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String color = rs.getString("color");
                String size = rs.getString("size");
                map.computeIfAbsent(color, k -> new ArrayList<>()).add(size);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return map;
}

// Map màu -> list ảnh
public static Map<String, List<String>> getImagesByColor(int productId) {
    Map<String, List<String>> map = new LinkedHashMap<>();
    String sql = """
        SELECT color, image
        FROM ProductImages
        WHERE product_id = ?
        ORDER BY color, is_main DESC, sort_order ASC, id ASC
    """;

    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String color = rs.getString("color");
                String image = rs.getString("image");
                map.computeIfAbsent(color, k -> new ArrayList<>()).add(image);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return map;
}

/* ================= JSON HELPERS (NO GSON) ================= */

private static String escapeJson(String s) {
    if (s == null) return "";
    return s.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
}

private static String mapToJson(Map<String, List<String>> map) {
    if (map == null || map.isEmpty()) return "{}";
    StringBuilder sb = new StringBuilder();
    sb.append("{");
    boolean firstKey = true;

    for (Map.Entry<String, List<String>> e : map.entrySet()) {
        if (!firstKey) sb.append(",");
        firstKey = false;

        sb.append("\"").append(escapeJson(e.getKey())).append("\":");
        sb.append("[");

        List<String> arr = e.getValue();
        for (int i = 0; i < arr.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(escapeJson(arr.get(i))).append("\"");
        }
        sb.append("]");
    }
    sb.append("}");
    return sb.toString();
}

public static String getSizesByColorJson(int productId) {
    return mapToJson(getSizesByColor(productId));
}

public static String getImagesByColorJson(int productId) {
    return mapToJson(getImagesByColor(productId));
}

/* ================= VARIANT HELPER ================= */

public static Integer getVariantId(int productId, String color, String size) {
    if (color == null || size == null) return null;

    color = color.trim();
    size  = size.trim();

    String sql = """
        SELECT id
        FROM ProductVariants
        WHERE product_id = ? AND color = ? AND size = ? AND stock > 0
    """;

    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, productId);
        ps.setString(2, color);
        ps.setString(3, size);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("id");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
//================= CATEGORY LIST (menu danh mục) =================
public static List<String> getAllCategories() {
 List<String> cats = new ArrayList<>();
 String sql = """
     SELECT DISTINCT category
     FROM Products
     WHERE category IS NOT NULL AND LTRIM(RTRIM(category)) <> ''
     ORDER BY category
 """;

 try (Connection conn = DBConnect.getConnection();
      PreparedStatement ps = conn.prepareStatement(sql);
      ResultSet rs = ps.executeQuery()) {

     while (rs.next()) {
         cats.add(rs.getString("category"));
     }
 } catch (Exception e) {
     e.printStackTrace();
 }
 return cats;
}

//================= FILTER: type + category =================
public static List<Product> getByTypeAndCategory(String type, String category) {
 List<Product> list = new ArrayList<>();
 String sql = """
     SELECT id, name, price, image, type, description, quantity
     FROM Products
     WHERE type = ? AND category = ?
 """;

 try (Connection conn = DBConnect.getConnection();
      PreparedStatement ps = conn.prepareStatement(sql)) {

     ps.setString(1, type);
     ps.setString(2, category);

     try (ResultSet rs = ps.executeQuery()) {
         while (rs.next()) {
             list.add(mapRow(rs));
         }
     }
 } catch (Exception e) {
     e.printStackTrace();
 }
 return list;
}
public static List<Product> getByCategory(String category) {
    List<Product> list = new ArrayList<>();
    String sql = "SELECT id, name, price, image, type, description, quantity FROM Products WHERE category = ?";
    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, category);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}



	
	
}
