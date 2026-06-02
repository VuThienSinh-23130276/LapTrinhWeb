package model;

public class Product {
	private int id;
	private String name;
	private double price;
	private String image;
	private String type;
	private String description;

	// ✅ NEW: tồn kho (quantity)
	// Nếu bạn không muốn quản lý tồn kho thì có thể để -1 (coi như vô hạn)
	private int quantity;

	public Product() {
	}

	// Constructor cũ (giữ tương thích với code cũ)
	public Product(int id, String name, double price, String image, String type, String description) {
		this(id, name, price, image, type, description, -1);
	}

	// Constructor mới có quantity
	public Product(int id, String name, double price, String image, String type, String description, int quantity) {
		this.id = id;
		this.name = name;
		this.price = price;
		this.image = image;
		this.type = type;
		this.description = description;
		this.quantity = quantity;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
}
