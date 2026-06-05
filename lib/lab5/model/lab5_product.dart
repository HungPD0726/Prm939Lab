class Lab5Product {
  const Lab5Product({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.quantity,
    required this.rating,
    required this.imageAsset,
    required this.isFavorite,
    required this.createdAt,
  });

  static const tableName = 'products';
  static const allCategory = 'All';
  static const categories = ['Jerseys', 'Shoes', 'Accessories'];

  final int? id;
  final String name;
  final String category;
  final String description;
  final double price;
  final int quantity;
  final double rating;
  final String imageAsset;
  final bool isFavorite;
  final DateTime createdAt;

  Lab5Product copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    double? price,
    int? quantity,
    double? rating,
    String? imageAsset,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Lab5Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
      imageAsset: imageAsset ?? this.imageAsset,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap({bool includeId = true}) {
    final map = <String, Object?>{
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'quantity': quantity,
      'rating': rating,
      'image_asset': imageAsset,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };

    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Lab5Product.fromMap(Map<String, Object?> map) {
    return Lab5Product(
      id: _toNullableInt(map['id']),
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? categories.first,
      description: map['description']?.toString() ?? '',
      price: _toDouble(map['price']),
      quantity: _toInt(map['quantity']),
      rating: _toDouble(map['rating']),
      imageAsset: map['image_asset']?.toString() ?? 'assets/cr7.jpg',
      isFavorite: _toInt(map['is_favorite']) == 1,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  static List<Lab5Product> seedProducts() {
    final baseDate = DateTime(2026, 6);

    return [
      Lab5Product(
        name: 'Home Jersey 2026',
        category: 'Jerseys',
        description:
            'Premium home jersey with breathable fabric and classic trim.',
        price: 450000,
        quantity: 24,
        rating: 4.9,
        imageAsset: 'assets/cr7.jpg',
        isFavorite: true,
        createdAt: baseDate,
      ),
      Lab5Product(
        name: 'Away Jersey Black',
        category: 'Jerseys',
        description:
            'Lightweight away jersey made for match day and daily training.',
        price: 420000,
        quantity: 18,
        rating: 4.7,
        imageAsset: 'assets/cr7.jpg',
        isFavorite: false,
        createdAt: baseDate.add(const Duration(days: 1)),
      ),
      Lab5Product(
        name: 'Pro Running Shoes',
        category: 'Shoes',
        description:
            'Responsive shoes with soft cushioning for long training runs.',
        price: 1250000,
        quantity: 10,
        rating: 4.8,
        imageAsset: 'assets/cr7.jpg',
        isFavorite: false,
        createdAt: baseDate.add(const Duration(days: 2)),
      ),
      Lab5Product(
        name: 'Indoor Court Shoes',
        category: 'Shoes',
        description:
            'Grip-focused shoes for indoor courts and fast direction changes.',
        price: 980000,
        quantity: 14,
        rating: 4.6,
        imageAsset: 'assets/cr7.jpg',
        isFavorite: true,
        createdAt: baseDate.add(const Duration(days: 3)),
      ),
      Lab5Product(
        name: 'Training Backpack',
        category: 'Accessories',
        description:
            'Compact backpack with separate zones for shoes, kit, and bottle.',
        price: 350000,
        quantity: 32,
        rating: 4.5,
        imageAsset: 'assets/cr7.jpg',
        isFavorite: false,
        createdAt: baseDate.add(const Duration(days: 4)),
      ),
      Lab5Product(
        name: 'Match Ball',
        category: 'Accessories',
        description:
            'Durable stitched football with balanced flight and soft touch.',
        price: 280000,
        quantity: 27,
        rating: 4.4,
        imageAsset: 'assets/cr7.jpg',
        isFavorite: false,
        createdAt: baseDate.add(const Duration(days: 5)),
      ),
    ];
  }

  static int? _toNullableInt(Object? value) {
    if (value == null) {
      return null;
    }

    return _toInt(value);
  }

  static int _toInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.parse(value?.toString() ?? '0');
  }

  static double _toDouble(Object? value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.parse(value?.toString() ?? '0');
  }
}
