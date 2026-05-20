import '../entity/product.dart';

class ProductController {
  ProductController._();

  static final List<Product> _seedProducts = [
    Product(id: 'P01', name: 'Tao Fuji', image: 'tao_fuji.png', price: 45000),
    Product(id: 'P02', name: 'Cam Sanh', image: 'cam_sanh.png', price: 35000),
    Product(id: 'P03', name: 'Xoai Cat', image: 'xoai_cat.png', price: 60000),
    Product(id: 'P04', name: 'Nho My', image: 'nho_my.png', price: 120000),
    Product(id: 'P05', name: 'Chuoi Cau', image: 'chuoi_cau.png', price: 28000),
    Product(id: 'P06',name: 'Le Han Quoc',image: 'le_han_quoc.png',price: 95000,),
    Product(id: 'P07', name: 'Dua Hau', image: 'dua_hau.png', price: 22000),
    Product(id: 'P08', name: 'Kiwi Xanh', image: 'kiwi_xanh.png', price: 85000),
    Product(id: 'P09', name: 'Dau Tay', image: 'dau_tay.png', price: 110000),
    Product(id: 'P10',name: 'Thanh Long',image: 'thanh_long.png',price: 30000,),
  ];

  static final List<Product> _products = List<Product>.from(_seedProducts);

  static List<Product> getProducts() {
    return List<Product>.unmodifiable(_products);
  }

  static void addProduct(Product product) {
    final exists = _products.any(
      (item) => item.id.toLowerCase() == product.id.toLowerCase(),
    );

    if (exists) {
      throw ArgumentError('ID ${product.id} da ton tai.');
    }

    _products.add(product);
  }

  static bool deleteProduct(String id) {
    final index = _products.indexWhere(
      (item) => item.id.toLowerCase() == id.toLowerCase(),
    );

    if (index == -1) {
      return false;
    }

    _products.removeAt(index);
    return true;
  }

  static bool updateProduct(String originalId, Product updatedProduct) {
    final duplicateId = _products.any(
      (item) =>
          item.id.toLowerCase() == updatedProduct.id.toLowerCase() &&
          item.id.toLowerCase() != originalId.toLowerCase(),
    );

    if (duplicateId) {
      throw ArgumentError('ID ${updatedProduct.id} da ton tai.');
    }

    final index = _products.indexWhere(
      (item) => item.id.toLowerCase() == originalId.toLowerCase(),
    );

    if (index == -1) {
      return false;
    }

    _products[index] = updatedProduct;
    return true;
  }

  static List<Product> searchProducts(String keyword) {
    final normalizedKeyword = keyword.trim().toLowerCase();
    if (normalizedKeyword.isEmpty) {
      return getProducts();
    }

    return _products
        .where(
          (item) =>
              item.id.toLowerCase().contains(normalizedKeyword) ||
              item.name.toLowerCase().contains(normalizedKeyword) ||
              item.image.toLowerCase().contains(normalizedKeyword),
        )
        .toList(growable: false);
  }

  static void sortByName({bool ascending = true}) {
    _products.sort(
      (first, second) => ascending
          ? first.name.toLowerCase().compareTo(second.name.toLowerCase())
          : second.name.toLowerCase().compareTo(first.name.toLowerCase()),
    );
  }

  static void sortByPrice({bool ascending = true}) {
    _products.sort(
      (first, second) => ascending
          ? first.price.compareTo(second.price)
          : second.price.compareTo(first.price),
    );
  }

  static void resetProducts() {
    _products
      ..clear()
      ..addAll(_seedProducts);
  }
}
