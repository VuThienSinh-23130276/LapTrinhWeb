package DAO;

import connect.DBConnect;
import model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductDAO: thao tác với SQL Server.
 *
 * Yêu cầu bảng Products có các cột: id (INT), name (NVARCHAR), price (FLOAT),
 * image (NVARCHAR), type (NVARCHAR), description (NVARCHAR(MAX))
 *
 * Gợi ý type: 'new' | 'hot' | 'like'
 */
public class ProductDAO {

	private static final String TABLE = "Products";

	public static List<Product> getAll() {
		List<Product> list = new ArrayList<>();
		String sql = "SELECT id, name, price, image, type, description FROM " + TABLE + " ORDER BY id DESC";

		try (Connection con = DBConnect.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(mapRow(rs));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public static List<Product> getByType(String type) {
		List<Product> list = new ArrayList<>();
		String sql = "SELECT id, name, price, image, type, description FROM " + TABLE
				+ " WHERE type = ? ORDER BY id DESC";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, type);
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

	public static Product getById(int id) {
		String sql = "SELECT id, name, price, image, type, description FROM " + TABLE + " WHERE id = ?";

		try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private static Product mapRow(ResultSet rs) throws Exception {
		return new Product(rs.getInt("id"), rs.getString("name"), rs.getDouble("price"), rs.getString("image"),
				rs.getString("type"), rs.getString("description"));
	}
}
