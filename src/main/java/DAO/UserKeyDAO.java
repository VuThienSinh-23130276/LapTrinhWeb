package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserKeyDAO {

    public static String getActivePublicKey(int userId) {
        String sql = "SELECT publicKey FROM user_keys WHERE userId = ? AND status = 'ACTIVE'";
        try (Connection conn = connect.DBConnect.getConnection();
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

    public static String getPublicKeyByVersion(int userId, int version) {
        String sql = "SELECT publicKey FROM user_keys WHERE userId = ? AND version = ?";
        try (Connection conn = connect.DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, version);
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

    public static void revokeOldKeys(int userId) {
        String sql = "UPDATE user_keys SET status = 'REVOKED' WHERE userId = ? AND status = 'ACTIVE'";
        try (Connection conn = connect.DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static int getMaxVersion(int userId) {
        String sql = "SELECT MAX(version) FROM user_keys WHERE userId = ?";
        try (Connection conn = connect.DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static boolean saveNewKey(int userId, String publicKey, int version) {
        // Đổi tên cột public_key -> publicKey, created_at -> createdAt cho khớp DB của bạn
        String sql = "INSERT INTO user_keys (userId, publicKey, version, status, createdAt) VALUES (?, ?, ?, 'ACTIVE', GETDATE())";
        try (Connection conn = connect.DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, publicKey);
            ps.setInt(3, version);
            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}