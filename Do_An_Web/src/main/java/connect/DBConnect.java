package connect;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
	private static String url = "jdbc:mysql://localhost:3306/ShopQuanAo";
	private static String user = "sa";
	private static String pass = "1234";

	public static Connection getConnection() {
		Connection conn = null;
		String url = "jdbc:sqlserver://localhost:1433;databaseName=ShopQuanAo;encrypt=false;";
		String user = "sa";
		String pass = "1234";

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