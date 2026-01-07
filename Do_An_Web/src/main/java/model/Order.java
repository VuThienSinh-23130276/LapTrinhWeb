package model;

import java.sql.Timestamp;

public class Order {
	private int id;
	private String orderCode;
	private int userId;
	private String fullname;
	private double total;
	private Timestamp createdAt;

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
}
