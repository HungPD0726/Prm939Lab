import 'package:flutter_test/flutter_test.dart';
import 'package:labprm393/lab1/controller/product_controller.dart';
import 'package:labprm393/lab1/entity/product.dart';

void main() {
  setUp(() {
    ProductController.resetProducts();
  });

  test('addProduct adds a new product', () {
    ProductController.addProduct(
      const Product(
        id: 'P11',
        name: 'Mit Thai',
        image: 'mit_thai.png',
        price: 90000,
      ),
    );

    final products = ProductController.getProducts();
    expect(products.length, 11);
    expect(products.any((item) => item.id == 'P11'), isTrue);
  });

  test('updateProduct updates existing product', () {
    final updated = ProductController.updateProduct(
      'P01',
      const Product(
        id: 'P01',
        name: 'Tao Envy',
        image: 'tao_envy.png',
        price: 70000,
      ),
    );

    final products = ProductController.getProducts();
    final product = products.firstWhere((item) => item.id == 'P01');

    expect(updated, isTrue);
    expect(product.name, 'Tao Envy');
    expect(product.price, 70000);
  });

  test('deleteProduct removes existing product', () {
    final deleted = ProductController.deleteProduct('P04');

    expect(deleted, isTrue);
    expect(ProductController.getProducts().length, 9);
    expect(
      ProductController.getProducts().any((item) => item.id == 'P04'),
      isFalse,
    );
  });

  test('searchProducts finds products by keyword', () {
    final results = ProductController.searchProducts('xoai');

    expect(results.length, 1);
    expect(results.first.name, 'Xoai Cat');
  });

  test('sortByPrice sorts ascending', () {
    ProductController.sortByPrice();

    final products = ProductController.getProducts();
    expect(products.first.name, 'Dua Hau');
    expect(products.last.name, 'Nho My');
  });
}
