package connect;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DBConnect {

    private static HikariDataSource dataSource;

    static {
        try {
            System.out.println("🔄 Khởi tạo HikariCP...");

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(
                "jdbc:sqlserver://localhost:1433;databaseName=ShopQuanAo;encrypt=false;"
            );
            config.setUsername("app_user");
            config.setPassword("App@123");

            config.setDriverClassName(
                "com.microsoft.sqlserver.jdbc.SQLServerDriver"
            );

            // Cấu hình pool
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setConnectionTimeout(30000); // 30s
            config.setIdleTimeout(600000);      // 10 phút
            config.setMaxLifetime(1800000);     // 30 phút

            dataSource = new HikariDataSource(config);

            System.out.println("✅ HikariCP khởi tạo thành công!");

        } catch (Exception e) {
            System.out.println("❌ Lỗi khởi tạo HikariCP:");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            Connection conn = dataSource.getConnection();
            System.out.println("✅ Lấy Connection từ HikariCP");
            return conn;
        } catch (SQLException e) {
            System.out.println("❌ Không lấy được Connection từ HikariCP");
            e.printStackTrace();
            return null;
        }
    }
}
