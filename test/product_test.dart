import 'package:flutter_test/flutter_test.dart';
import 'package:labprm393/lab1/entity/product.dart';

void main() {
  setUp(() {
    Product.resetProducts();
  });

  test('addProduct adds a new product', () {
    Product.addProduct(
      const Product(
        id: 'P05',
        name: 'Le Han Quoc',
        image: 'le_han_quoc.png',
        price: 90000,
      ),
    );

    final products = Product.displayProducts();
    expect(products.length, 5);
    expect(products.any((item) => item.id == 'P05'), isTrue);
  });

  test('updateProduct updates existing product', () {
    final updated = Product.updateProduct(
      'P01',
      const Product(
        id: 'P01',
        name: 'Tao Envy',
        image: 'tao_envy.png',
        price: 70000,
      ),
    );

    final products = Product.displayProducts();
    final product = products.firstWhere((item) => item.id == 'P01');

    expect(updated, isTrue);
    expect(product.name, 'Tao Envy');
    expect(product.price, 70000);
  });

  test('deleteProduct removes existing product', () {
    final deleted = Product.deleteProduct('P04');

    expect(deleted, isTrue);
    expect(Product.displayProducts().length, 3);
    expect(Product.displayProducts().any((item) => item.id == 'P04'), isFalse);
  });

  test('searchProducts finds products by keyword', () {
    final results = Product.searchProducts('xoai');

    expect(results.length, 1);
    expect(results.first.name, 'Xoai Cat');
  });

  test('sortByPrice sorts ascending', () {
    Product.sortByPrice();

    final products = Product.displayProducts();
    expect(products.first.name, 'Cam Sanh');
    expect(products.last.name, 'Nho My');
  });
}
