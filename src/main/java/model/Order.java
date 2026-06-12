package model;

import java.sql.Timestamp;

public class Order {
	private int id;
	private String orderCode;
	private int userId;
	private String fullname;
	private String address;
	private String phone;
	private String email;
	private double total;
	private Timestamp createdAt;
	private String paymentMethod; // COD (Cash on Delivery) hoặc TRANSFER (Chuyển khoản)
	private boolean isPaid; // true nếu đã thanh toán, false nếu chưa

	public Order() {
	}

	public Order(int id, String orderCode, int userId, String fullname, double total, Timestamp createdAt) {
		this.id = id;
		this.orderCode = orderCode;
		this.userId = userId;
		this.fullname = fullname;
		this.total = total;
		this.createdAt = createdAt;
	}

	public Order(int id, String orderCode, int userId, String fullname, String address, String phone, String email, double total, Timestamp createdAt) {
		this.id = id;
		this.orderCode = orderCode;
		this.userId = userId;
		this.fullname = fullname;
		this.address = address;
		this.phone = phone;
		this.email = email;
		this.total = total;
		this.createdAt = createdAt;
		this.paymentMethod = "COD";
		this.isPaid = false;
	}

	public Order(int id, String orderCode, int userId, String fullname, String address, String phone, String email, double total, Timestamp createdAt, String paymentMethod, boolean isPaid) {
		this.id = id;
		this.orderCode = orderCode;
		this.userId = userId;
		this.fullname = fullname;
		this.address = address;
		this.phone = phone;
		this.email = email;
		this.total = total;
		this.createdAt = createdAt;
		this.paymentMethod = paymentMethod;
		this.isPaid = isPaid;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getOrderCode() {
		return orderCode;
	}

	public void setOrderCode(String orderCode) {
		this.orderCode = orderCode;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public double getTotal() {
		return total;
	}

	public void setTotal(double total) {
		this.total = total;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public boolean isPaid() {
		return isPaid;
	}

	public void setPaid(boolean isPaid) {
		this.isPaid = isPaid;
	}
}
