package model;

public class Product {
	private int id;
	private String name;
	private double price;
	private String image;
	private String type;
	private String description;

	public Product() {
	}

	public Product(int id, String name, double price, String image, String type, String description) {
		this.id = id;
		this.name = name;
		this.price = price;
		this.image = image;
		this.type = type;
		this.description = description;
	}

	public int getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public double getPrice() {
		return price;
	}

	public String getImage() {
		return image;
	}

	public String getType() {
		return type;
	}

	public String getDescription() {
		return description;
	}
}
