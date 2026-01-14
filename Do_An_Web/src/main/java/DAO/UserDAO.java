package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import connect.DBConnect;
import model.User;

public class UserDAO {

    // ================== CHECK USERNAME ==================
    public boolean checkUsername(String username) {
        String sql = "SELECT 1 FROM users WHERE username = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi checkUsername:");
            e.printStackTrace();
        }
        return false;
    }

    // ================== REGISTER ==================
    public boolean register(User user) {
        try {
            // Thử insert có role
            String sql = "INSERT INTO users(username, password, fullname, role) VALUES (?, ?, ?, ?)";

            try (Connection conn = DBConnect.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, user.getUsername());
                ps.setString(2, user.getPassword());
                ps.setString(3, user.getFullname());
                ps.setString(4, user.getRole() != null ? user.getRole() : "user");

                int result = ps.executeUpdate();
                System.out.println("✅ Register thành công (có role)");
                return result > 0;
            }

        } catch (Exception e) {
            // Nếu cột role chưa tồn tại
            try {
                System.out.println("⚠️ Cột role chưa có, insert không role");

                String sql = "INSERT INTO users(username, password, fullname) VALUES (?, ?, ?)";

                try (Connection conn = DBConnect.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {

                    ps.setString(1, user.getUsername());
                    ps.setString(2, user.getPassword());
                    ps.setString(3, user.getFullname());

                    int result = ps.executeUpdate();
                    System.out.println("✅ Register thành công (không role)");
                    return result > 0;
                }

            } catch (Exception ex) {
                System.out.println("❌ Lỗi register:");
                ex.printStackTrace();
            }
        }
        return false;
    }

    // ================== LOGIN ==================
    public User checkLogin(String username, String password) {
        String sql = "SELECT id, username, password, fullname FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    int id = rs.getInt("id");
                    String fullname = rs.getString("fullname");

                    // Mặc định role
                    String role = "user";

                    // Thử đọc role (nếu cột tồn tại)
                    try (PreparedStatement psRole =
                                 conn.prepareStatement("SELECT role FROM users WHERE id = ?");
                         ) {

                        psRole.setInt(1, id);
                        try (ResultSet rsRole = psRole.executeQuery()) {
                            if (rsRole.next()) {
                                String r = rsRole.getString("role");
                                if (r != null && !r.trim().isEmpty()) {
                                    role = r.trim();
                                }
                            }
                        }
                    } catch (Exception e) {
                        // Cột role chưa tồn tại → bỏ qua
                    }

                    System.out.println("✅ Login thành công: " + username + " (role: " + role + ")");
                    return new User(id, username, password, fullname, role);
                }
            }

        } catch (Exception e) {
            System.out.println("❌ Lỗi checkLogin:");
            e.printStackTrace();
        }

        System.out.println("❌ Sai username hoặc password");
        return null;
    }
}
