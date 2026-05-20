// ignore_for_file: file_names

import '../entity/product.dart';

class ProductDAO {
  ProductDAO._();

  static List<Product> getAll() {
    return Product.products;
  }

  static void add(Product product) {
    Product.products.add(product);
  }

  static bool edit(Product product) {
    final index = Product.products.indexWhere(
      (item) => item.id.toLowerCase() == product.id.toLowerCase(),
    );

    if (index == -1) {
      return false;
    }

    Product.products[index] = product;
    return true;
  }

  static bool delete(String id) {
    final product = find(id);
    if (product == null) {
      return false;
    }

    Product.products.remove(product);
    return true;
  }

  static Product? find(String id) {
    final index = Product.products.indexWhere(
      (item) => item.id.toLowerCase() == id.toLowerCase(),
    );

    if (index == -1) {
      return null;
    }

    return Product.products[index];
  }

  static List<Product> search(String keyword) {
    final key = keyword.trim().toLowerCase();

    return Product.products
        .where(
          (item) =>
              item.id.toLowerCase().contains(key) ||
              item.name.toLowerCase().contains(key) ||
              item.image.toLowerCase().contains(key),
        )
        .toList();
  }

  static List<Product> searchByName(String name) {
    final key = name.trim().toLowerCase();

    return Product.products
        .where((item) => item.name.toLowerCase().contains(key))
        .toList();
  }

  static List<Product> searchByPrice(double minPrice, double maxPrice) {
    return Product.products
        .where((item) => item.price >= minPrice && item.price <= maxPrice)
        .toList();
  }

  static void increasePrice() {
    Product.products = Product.products
        .map((item) => item.copyWith(price: item.price * 1.1))
        .toList();
  }

  static void sortByName() {
    Product.products.sort((a, b) => a.name.compareTo(b.name));
  }

  static void sortByPrice() {
    Product.products.sort((a, b) => a.price.compareTo(b.price));
  }

  static void reset() {
    Product.products = List<Product>.from(Product.defaultProducts);
  }
}

class DAOProduct {
  DAOProduct._();

  static List<Product> getAll() => ProductDAO.getAll();

  static void add(Product product) => ProductDAO.add(product);

  static bool edit(Product product) => ProductDAO.edit(product);

  static bool delete(String id) => ProductDAO.delete(id);

  static Product? find(String id) => ProductDAO.find(id);

  static List<Product> search(String keyword) => ProductDAO.search(keyword);

  static List<Product> searchByName(String name) =>
      ProductDAO.searchByName(name);

  static List<Product> searchByPrice(double minPrice, double maxPrice) {
    return ProductDAO.searchByPrice(minPrice, maxPrice);
  }

  static void increasePrice() => ProductDAO.increasePrice();

  static void sortByName() => ProductDAO.sortByName();

  static void sortByPrice() => ProductDAO.sortByPrice();

  static void reset() => ProductDAO.reset();
}
