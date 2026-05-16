class Product {
  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  final String id;
  final String name;
  final String image;
  final double price;

  static const List<Product> _seedProducts = [
    Product(id: 'P01', name: 'Tao Fuji', image: 'tao_fuji.png', price: 45000),
    Product(id: 'P02', name: 'Cam Sanh', image: 'cam_sanh.png', price: 35000),
    Product(id: 'P03', name: 'Xoai Cat', image: 'xoai_cat.png', price: 60000),
    Product(id: 'P04', name: 'Nho My', image: 'nho_my.png', price: 120000),
  ];

  static final List<Product> _products = List<Product>.from(_seedProducts);

  Product copyWith({String? id, String? name, String? image, double? price}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
    );
  }

  String displayInfo() {
    return 'ID: $id\nTen: $name\nAnh: $image\nGia: ${price.toStringAsFixed(0)} VND';
  }

  static List<Product> displayProducts({List<Product>? source}) {
    return List<Product>.unmodifiable(source ?? _products);
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
      return displayProducts();
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
