class Product {
  Product({
    String id,
    String name,
    String image,
    double price,
  }) {
    this.id = id;
    this.name = name;
    this.image = image;
    this.price = price;
  }

  String _id = '';
  String _name = '';
  String _image = '';
  double _price = 0;

  String get id => _id;
  String get name => _name;
  String get image => _image;
  double get price => _price;

  set id(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('ID khong duoc de trong.');
    }
    _id = value.trim();
  }

  set name(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Ten khong duoc de trong.');
    }
    _name = value.trim();
  }

  set image(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Anh khong duoc de trong.');
    }
    _image = value.trim();
  }

  set price(double value) {
    if (value <= 0) {
      throw ArgumentError('Gia phai > 0.');
    }
    _price = value;
  }

  String displayInfo() {
    return 'ID: $id\nTen: $name\nAnh: $image\nGia: ${price.toStringAsFixed(0)} VND';
  }
}
