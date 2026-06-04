package DAO;

import connect.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class KeyDAO {

    // Lấy chuỗi Public Key đang ACTIVE của người dùng
    public String getActivePublicKey(int userId) {
        String sql = "SELECT publicKey FROM UserPublicKeys WHERE userId = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("publicKey");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm một Public Key mới vào hệ thống
    public boolean insertPublicKey(int userId, String publicKey) {
        String sql = "INSERT INTO UserPublicKeys (userId, publicKey, status, createdAt) VALUES (?, ?, 'ACTIVE', ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, publicKey);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thu hồi (Revoke) khóa đang ACTIVE của người dùng
    public boolean revokeKey(int userId) {
        String sql = "UPDATE UserPublicKeys SET status = 'REVOKED', revokedAt = ? WHERE userId = ? AND status = 'ACTIVE'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}