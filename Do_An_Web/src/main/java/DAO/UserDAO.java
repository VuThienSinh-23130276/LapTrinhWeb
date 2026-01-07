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
			// Kiểm tra xem cột role có tồn tại không
			String sql;
			try {
				// Thử INSERT với role
				sql = "INSERT INTO users(username, password, fullname, role) VALUES (?, ?, ?, ?)";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, user.getUsername());
				ps.setString(2, user.getPassword());
				ps.setString(3, user.getFullname());
				ps.setString(4, user.getRole() != null ? user.getRole() : "user");
				int result = ps.executeUpdate();
				System.out.println("✅ Insert result: " + result);
				return result > 0;
			} catch (Exception e) {
				// Nếu cột role chưa có, INSERT không có role
				System.out.println("⚠️ Cột 'role' chưa có, INSERT không có role");
				sql = "INSERT INTO users(username, password, fullname) VALUES (?, ?, ?)";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, user.getUsername());
				ps.setString(2, user.getPassword());
				ps.setString(3, user.getFullname());

				int result = ps.executeUpdate();
				System.out.println("✅ Insert result: " + result);
				return result > 0;
			}
		} catch (Exception e) {
			System.out.println("❌ Lỗi register:");
			e.printStackTrace();
		}
		return false;
	}

	public User checkLogin(String username, String password) {
		User user = null;
		try {
			// SELECT các cột cơ bản (không SELECT role để tránh lỗi nếu cột chưa tồn tại)
			String sql = "SELECT id, username, password, fullname FROM users WHERE username = ? AND password = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				int id = rs.getInt("id");
				String uname = rs.getString("username");
				String pwd = rs.getString("password");
				String fullname = rs.getString("fullname");
				
				// Đọc role riêng (nếu cột tồn tại)
				String role = "user"; // mặc định
				try {
					PreparedStatement psRole = conn.prepareStatement("SELECT role FROM users WHERE id = ?");
					psRole.setInt(1, id);
					ResultSet rsRole = psRole.executeQuery();
					if (rsRole.next()) {
						String roleValue = rsRole.getString("role");
						if (roleValue != null && !roleValue.trim().isEmpty()) {
							role = roleValue.trim();
						}
					}
					rsRole.close();
					psRole.close();
				} catch (Exception e) {
					// Cột role chưa tồn tại → dùng mặc định "user"
					// Không cần log vì đây là trường hợp bình thường khi chưa chạy script SQL
				}
				
				user = new User(id, uname, pwd, fullname, role);
				System.out.println("✅ Login thành công: " + username + " (role: " + role + ")");
			} else {
				System.out.println("❌ Sai username/password");
			}
			rs.close();
			ps.close();
		} catch (Exception e) {
			System.out.println("❌ Lỗi checkLogin:");
			e.printStackTrace();
		}
		return user;
	}
}
