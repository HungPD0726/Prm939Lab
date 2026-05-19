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

  String displayInfo() {
    return 'ID: $id\nTen: $name\nAnh: $image\nGia: ${price.toStringAsFixed(0)} VND';
  }
}
