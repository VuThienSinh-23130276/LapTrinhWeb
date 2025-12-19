package connect;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {



	public static Connection getConnection() {
		Connection conn = null;
		String url = "jdbc:sqlserver://localhost:1433;databaseName=ShopQuanAo;encrypt=false;";
		String user = "app_user";
		String pass = "App@123";

		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			conn = DriverManager.getConnection(url, user, pass);
			System.out.println("✅ Kết nối SQL thành công!");
		} catch (Exception e) {
			System.out.println("❌ Kết nối thất bại:");
			e.printStackTrace();
		}
		return conn;
	}
	
}