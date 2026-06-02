package util;

import java.io.InputStream;
import java.util.List;
import java.util.Properties;
import java.util.StringJoiner;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

import model.CartItem;
import model.Order;

public class MailUtil {

	private static final String CONFIG_PATH = "/WEB-INF/mail.properties";

	public static void sendOrderEmail(ServletContext ctx, String toEmail, Order order, List<CartItem> items) {
		if (toEmail == null || !toEmail.contains("@") || order == null) {
			return; // không có email hợp lệ thì bỏ qua
		}

		try {
			Properties cfg = loadConfig(ctx);
			if (cfg == null)
				return;

			String host = cfg.getProperty("mail.host");
			String port = cfg.getProperty("mail.port");
			String username = cfg.getProperty("mail.username");
			String password = cfg.getProperty("mail.password");
			String from = cfg.getProperty("mail.from");
			String enableTls = cfg.getProperty("mail.tls", "true");

			if (isBlank(host) || isBlank(port) || isBlank(username) || isBlank(password) || isBlank(from)) {
				System.out.println("⚠️ Mail config chưa đầy đủ. Bỏ qua gửi mail.");
				return;
			}

			Properties props = new Properties();
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.starttls.enable", enableTls);
			props.put("mail.smtp.host", host);
			props.put("mail.smtp.port", port);

			Session session = Session.getInstance(props, new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username, password);
				}
			});

			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(from));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
			message.setSubject("Xác nhận đơn hàng " + order.getOrderCode() + " - S&N Shop");
			message.setText(buildBody(order, items));

			Transport.send(message);
			System.out.println("✅ Đã gửi email đơn hàng tới " + toEmail);
		} catch (Exception e) {
			System.out.println("❌ Không gửi được email: " + e.getMessage());
			e.printStackTrace();
		}
	}

	private static Properties loadConfig(ServletContext ctx) {
		try (InputStream in = ctx.getResourceAsStream(CONFIG_PATH)) {
			if (in == null)
				return null;
			Properties props = new Properties();
			props.load(in);
			return props;
		} catch (Exception e) {
			System.out.println("⚠️ Không đọc được mail.properties: " + e.getMessage());
			return null;
		}
	}

	private static String buildBody(Order order, List<CartItem> items) {
		StringBuilder sb = new StringBuilder();
		sb.append("═══════════════════════════════════════════════════════\n");
		sb.append("           S&N SHOP - XÁC NHẬN ĐƠN HÀNG\n");
		sb.append("═══════════════════════════════════════════════════════\n\n");
		
		sb.append("Xin chào ").append(order.getFullname() == null ? "Quý khách" : order.getFullname()).append(",\n\n");
		sb.append("Cảm ơn bạn đã đặt hàng tại S&N Shop!\n\n");
		
		sb.append("═══════════════════════════════════════════════════════\n");
		sb.append("THÔNG TIN ĐƠN HÀNG\n");
		sb.append("═══════════════════════════════════════════════════════\n");
		sb.append("Mã đơn hàng: ").append(order.getOrderCode()).append("\n");
		sb.append("Ngày đặt: ").append(new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(order.getCreatedAt())).append("\n");
		sb.append("Tổng tiền: ").append(String.format("%,.0f", order.getTotal())).append(" VNĐ\n\n");
		
		sb.append("═══════════════════════════════════════════════════════\n");
		sb.append("THÔNG TIN GIAO HÀNG\n");
		sb.append("═══════════════════════════════════════════════════════\n");
		sb.append("Họ tên: ").append(order.getFullname()).append("\n");
		sb.append("Địa chỉ: ").append(order.getAddress() != null ? order.getAddress() : "").append("\n");
		sb.append("Số điện thoại: ").append(order.getPhone() != null ? order.getPhone() : "").append("\n");
		sb.append("Email: ").append(order.getEmail() != null ? order.getEmail() : "").append("\n\n");
		
		sb.append("═══════════════════════════════════════════════════════\n");
		sb.append("CHI TIẾT SẢN PHẨM\n");
		sb.append("═══════════════════════════════════════════════════════\n");
		
		if (items != null && !items.isEmpty()) {
			int stt = 1;
			for (CartItem it : items) {
				sb.append(String.format("%d. %s\n", stt++, it.getProduct().getName()));
				if (it.getColor() != null && !it.getColor().isEmpty()) {
					sb.append("   Màu: ").append(it.getColor());
				}
				if (it.getSize() != null && !it.getSize().isEmpty()) {
					sb.append(" | Size: ").append(it.getSize());
				}
				sb.append("\n");
				sb.append(String.format("   Số lượng: %d | Giá: %,.0f VNĐ | Thành tiền: %,.0f VNĐ\n", 
					it.getQuantity(), 
					it.getProduct().getPrice(), 
					it.getSubTotal()));
				sb.append("\n");
			}
		}
		
		sb.append("═══════════════════════════════════════════════════════\n");
		sb.append("TỔNG CỘNG: ").append(String.format("%,.0f", order.getTotal())).append(" VNĐ\n");
		sb.append("═══════════════════════════════════════════════════════\n\n");
		
		sb.append("Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất để xác nhận đơn hàng.\n\n");
		sb.append("Cảm ơn bạn đã tin tưởng và mua sắm tại S&N Shop!\n\n");
		sb.append("Trân trọng,\n");
		sb.append("S&N Shop Team\n");
		sb.append("Email: S&Nshopnlu@gmail.com\n");
		sb.append("Hotline: 0325 556 718\n");

		return sb.toString();
	}

	private static boolean isBlank(String v) {
		return v == null || v.trim().isEmpty();
	}
}
