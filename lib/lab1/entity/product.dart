class Product {
  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  const Product.constData({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'].toString(),
      image: json['image'].toString(),
      price: _toDouble(json['price']),
    );
  }

  final String id;
  final String name;
  final String image;
  final double price;

  static final List<Product> defaultProducts = [
    const Product.constData(
      id: 'P01',
      name: 'Tao Fuji',
      image: 'tao_fuji.png',
      price: 45000,
    ),
    const Product.constData(
      id: 'P02',
      name: 'Cam Sanh',
      image: 'cam_sanh.png',
      price: 35000,
    ),
    const Product.constData(
      id: 'P03',
      name: 'Xoai Cat',
      image: 'xoai_cat.png',
      price: 60000,
    ),
    const Product.constData(
      id: 'P04',
      name: 'Nho My',
      image: 'nho_my.png',
      price: 120000,
    ),
    const Product.constData(
      id: 'P05',
      name: 'Chuoi Cau',
      image: 'chuoi_cau.png',
      price: 28000,
    ),
    const Product.constData(
      id: 'P06',
      name: 'Le Han Quoc',
      image: 'le_han_quoc.png',
      price: 95000,
    ),
    const Product.constData(
      id: 'P07',
      name: 'Dua Hau',
      image: 'dua_hau.png',
      price: 22000,
    ),
    const Product.constData(
      id: 'P08',
      name: 'Kiwi Xanh',
      image: 'kiwi_xanh.png',
      price: 85000,
    ),
    const Product.constData(
      id: 'P09',
      name: 'Dau Tay',
      image: 'dau_tay.png',
      price: 110000,
    ),
    const Product.constData(
      id: 'P10',
      name: 'Thanh Long',
      image: 'thanh_long.png',
      price: 30000,
    ),
  ];

  static List<Product> products = List<Product>.from(defaultProducts);

  Product copyWith({String? id, String? name, String? image, double? price}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image, 'price': price};
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, image: $image, price: $price)';
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.parse(value.toString());
  }
}
