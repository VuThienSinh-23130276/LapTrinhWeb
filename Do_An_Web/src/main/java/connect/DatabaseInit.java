package connect;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.Statement;

public class DatabaseInit {

	public static void init() {
		try (Connection conn = DBConnect.getConnection(); Statement stmt = conn.createStatement()) {

			// schema
			InputStream schemaStream = DatabaseInit.class.getClassLoader().getResourceAsStream("schema.sql");

			if (schemaStream != null) {
				String schemaSql = new String(schemaStream.readAllBytes());
				stmt.execute(schemaSql);
			}

			// data
			InputStream dataStream = DatabaseInit.class.getClassLoader().getResourceAsStream("data.sql");

			if (dataStream != null) {
				String dataSql = new String(dataStream.readAllBytes());
				stmt.execute(dataSql);
			}

			System.out.println("✔ Database initialized");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
