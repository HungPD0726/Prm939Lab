import '../Repository/DAOProduct.dart';
import '../entity/product.dart';

class ProductController {
  ProductController._();

  static List<Product> getProducts() {
    return DAOProduct.getAll();
  }

  static void addProduct(Product product) {
    DAOProduct.add(product);
  }

  static bool updateProduct(String id, Product product) {
    return DAOProduct.edit(product.copyWith(id: id));
  }

  static bool deleteProduct(String id) {
    return DAOProduct.delete(id);
  }

  static Product? findProduct(String id) {
    return DAOProduct.find(id);
  }

  static List<Product> searchProducts(String keyword) {
    return DAOProduct.search(keyword);
  }

  static List<Product> searchProductsByName(String name) {
    return DAOProduct.searchByName(name);
  }

  static List<Product> searchProductsByPrice(double minPrice, double maxPrice) {
    return DAOProduct.searchByPrice(minPrice, maxPrice);
  }

  static void increaseProductPrice() {
    DAOProduct.increasePrice();
  }

  static void sortByName() {
    DAOProduct.sortByName();
  }

  static void sortByPrice() {
    DAOProduct.sortByPrice();
  }

  static void resetProducts() {
    DAOProduct.reset();
  }
}
