package connect;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {

	private static final String URL = "jdbc:h2:./database/shopdb;AUTO_SERVER=TRUE";
	private static final String USER = "sa";
	private static final String PASS = "";

	public static Connection getConnection() {
		try {
			Class.forName("org.h2.Driver");
			Connection conn = DriverManager.getConnection(URL, USER, PASS);
			System.out.println("✔ Kết nối DATABASE thành công");
			return conn;
		} catch (Exception e) {
			System.err.println("✘ Kết nối DATABASE KHÔNG thành công");
			e.printStackTrace();
			return null;
		}
	}

}
