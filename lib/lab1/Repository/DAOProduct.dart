// ignore_for_file: file_names

import '../entity/product.dart';

class ProductDAO {
  ProductDAO(this.l);

  List<Product> l;

  List<Product> getAllProduct() {
    l = Product.products;
    return l;
  }

  void addProduct(Product p) {
    var index = l.indexWhere((element) => element.id == p.id);
    if (index < 0) {
      l.add(p);
    }
  }

  void deleteProduct(String id) {
    l.removeWhere((element) => element.id == id);
  }

  bool updateProduct(Product pNew) {
    var index = l.indexWhere((element) => element.id == pNew.id);
    if (index < 0) {
      return false;
    }

    l[index] = pNew;
    return true;
  }

  Product? findProduct(String id) {
    var index = l.indexWhere((element) => element.id == id);
    if (index < 0) {
      return null;
    }

    return l[index];
  }

  List<Product> searchProduct(String keyword) {
    var key = keyword.trim().toLowerCase();

    return l
        .where(
          (element) =>
              element.id.toLowerCase().contains(key) ||
              element.name.toLowerCase().contains(key) ||
              element.image.toLowerCase().contains(key),
        )
        .toList();
  }

  List<Product> searchByName(String name) {
    var key = name.trim().toLowerCase();

    return l
        .where((element) => element.name.toLowerCase().contains(key))
        .toList();
  }

  List<Product> searchByPrice(double minPrice, double maxPrice) {
    return l
        .where(
          (element) => element.price >= minPrice && element.price <= maxPrice,
        )
        .toList();
  }

  void increasePrice() {
    l = l.map((element) {
      return element.copyWith(price: element.price * 1.1);
    }).toList();

    Product.products = l;
  }

  void sortByName() {
    l.sort((a, b) => a.name.compareTo(b.name));
  }

  void sortByPrice() {
    l.sort((a, b) => a.price.compareTo(b.price));
  }

  void reset() {
    l = List<Product>.from(Product.defaultProducts);
    Product.products = l;
  }

  static ProductDAO get _dao => ProductDAO(Product.products);

  static List<Product> getAll() => _dao.getAllProduct();

  static void add(Product product) => _dao.addProduct(product);

  static bool edit(Product product) => _dao.updateProduct(product);

  static bool delete(String id) {
    var dao = _dao;
    var product = dao.findProduct(id);
    if (product == null) {
      return false;
    }

    dao.deleteProduct(id);
    return true;
  }

  static Product? find(String id) => _dao.findProduct(id);

  static List<Product> search(String keyword) => _dao.searchProduct(keyword);

  static List<Product> searchName(String name) => _dao.searchByName(name);

  static List<Product> searchPrice(double minPrice, double maxPrice) {
    return _dao.searchByPrice(minPrice, maxPrice);
  }

  static void increaseAllPrice() => _dao.increasePrice();

  static void sortName() => _dao.sortByName();

  static void sortPrice() => _dao.sortByPrice();

  static void resetData() => _dao.reset();
}

class Productdao extends ProductDAO {
  Productdao(super.l);
}

class DAOProduct {
  DAOProduct._();

  static List<Product> getAll() => ProductDAO.getAll();

  static void add(Product product) => ProductDAO.add(product);

  static bool edit(Product product) => ProductDAO.edit(product);

  static bool delete(String id) => ProductDAO.delete(id);

  static Product? find(String id) => ProductDAO.find(id);

  static List<Product> search(String keyword) => ProductDAO.search(keyword);

  static List<Product> searchByName(String name) => ProductDAO.searchName(name);

  static List<Product> searchByPrice(double minPrice, double maxPrice) {
    return ProductDAO.searchPrice(minPrice, maxPrice);
  }

  static void increasePrice() => ProductDAO.increaseAllPrice();

  static void sortByName() => ProductDAO.sortName();

  static void sortByPrice() => ProductDAO.sortPrice();

  static void reset() => ProductDAO.resetData();
}
