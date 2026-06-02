package connect;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {

    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://localhost:1433;databaseName=ShopQuanAo;encrypt=false;trustServerCertificate=true;";
            String user = "sa";
            String pass = "Sa12345678!";
            
            System.out.println("✅ Lấy Connection trực tiếp thành công");
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            System.out.println("❌ Kết nối Database trực tiếp thất bại:");
            e.printStackTrace();
            return null;
        }
    }
}