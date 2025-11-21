package repository;

import java.util.ArrayList;
import java.util.List;

import model.Product;

public class ProductRepository {

	private static final List<Product> products = new ArrayList<>();

	static {
		products.add(new Product(1, "Sản phẩm A", 100.0));
		products.add(new Product(2, "Sản phẩm B", 200.0));
		products.add(new Product(3, "Sản phẩm C", 300.0));
	}

	public static List<Product> findAll() {
		return products;
	}

	public static Product findById(int id) {
		return products.stream().filter(p -> p.getId() == id).findFirst().orElse(null);
	}
}
