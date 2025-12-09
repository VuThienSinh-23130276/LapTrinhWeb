package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import connect.DBConnect;
import model.User;

public class UserDAO {
	private Connection conn;

	public UserDAO() {
		conn = DBConnect.getConnection();
	}

	// Kiểm tra username tồn tại hay chưa
	public boolean checkUsername(String username) {
		boolean exists = false;
		try {
			String sql = "SELECT * FROM users WHERE username = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, username);

			ResultSet rs = ps.executeQuery();
			exists = rs.next();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return exists;
	}

	public boolean register(User user) {
		try {
			String sql = "INSERT INTO users(username, password, fullname) VALUES (?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, user.getUsername());
			ps.setString(2, user.getPassword());
			ps.setString(3, user.getFullname());

			int result = ps.executeUpdate();
			System.out.println("✅ Insert result: " + result); // Debug
			return result > 0;

		} catch (Exception e) {
			System.out.println("❌ Lỗi register:");
			e.printStackTrace();
		}
		return false;
	}

	public User checkLogin(String username, String password) {
		User user = null;
		try {
			String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				user = new User(rs.getInt("id"), rs.getString("username"), rs.getString("password"),
						rs.getString("fullname"));
				System.out.println("✅ Login thành công: " + username);
			} else {
				System.out.println("❌ Sai username/password");
			}
		} catch (Exception e) {
			System.out.println("❌ Lỗi checkLogin:");
			e.printStackTrace();
		}
		return user;
	}
}
