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

	public static void sendOrderEmail(ServletContext ctx, String toEmail, Order order, List<CartItem> items,
			String addressNote) {
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
			message.setSubject("Xác nhận đơn hàng " + order.getOrderCode());
			message.setText(buildBody(order, items, addressNote));

			Transport.send(message);
			System.out.println("✅ Đã gửi email đơn hàng tới " + toEmail);
		} catch (Exception e) {
			System.out.println("❌ Không gửi được email: " + e.getMessage());
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

	private static String buildBody(Order order, List<CartItem> items, String addressNote) {
		StringBuilder sb = new StringBuilder();
		sb.append("Xin chào ").append(order.getFullname() == null ? "" : order.getFullname()).append("\n\n");
		sb.append("Cảm ơn bạn đã đặt hàng. Thông tin đơn:\n");
		sb.append("- Mã đơn: ").append(order.getOrderCode()).append("\n");
		sb.append("- Tổng tiền: ").append(order.getTotal()).append("\n");
		if (!isBlank(addressNote)) {
			sb.append("- Địa chỉ/ghi chú: ").append(addressNote).append("\n");
		}
		sb.append("\nChi tiết sản phẩm:\n");

		if (items != null) {
			for (CartItem it : items) {
				sb.append("• ").append(it.getProduct().getName()).append(" x").append(it.getQuantity()).append(" - ")
						.append(it.getSubTotal()).append("\n");
			}
		}

		sb.append("\nCảm ơn bạn đã mua sắm!\n");

		return sb.toString();
	}

	private static boolean isBlank(String v) {
		return v == null || v.trim().isEmpty();
	}
}
