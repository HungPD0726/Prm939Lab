// Model san pham duoc dung chung cho toan bo Lab 5.
// Muc dich:
// 1. Chua cau truc du lieu san pham.
// 2. Cung cap helper cho JSON.
// 3. Cung cap danh sach mau de hien thi UI dong.
class Product {
  // Ten san pham hien thi tren card va trang detail.
  final String name;

  // Ma san pham de phan biet tung item.
  final String id;

  // Ten file anh, khong kem duoi .jpg.
  final String? image;

  // Gia duoc de mutable de sau nay co the cap nhat neu can.
  double price;

  Product({
    required this.name,
    required this.id,
    this.image,
    required this.price,
  });

  // Tao Product tu map, huu ich khi doc JSON hoac database.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      id: json['id'] as String,
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
    );
  }

  // Chuyen object ve map de luu hoac truyen du lieu.
  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id, 'image': image, 'price': price};
  }

  // Tao ban sao va cho phep ghi de tung field can thay doi.
  Product copyWith({String? name, String? id, String? image, double? price}) {
    return Product(
      name: name ?? this.name,
      id: id ?? this.id,
      image: image ?? this.image,
      price: price ?? this.price,
    );
  }

  // Ghep duong dan anh thuc te tu ten file.
  // Neu image null thi fallback ve anh1.jpg.
  String get assetPath => 'assets/${image ?? 'anh1'}.jpg';

  // Danh sach du lieu mau cho bai lab.
  // UI se render dong theo danh sach nay.
  static final List<Product> products = [
    Product(id: 'P01', name: 'Cam', price: 20000, image: 'anh1'),
    Product(id: 'P02', name: 'Chanh', price: 30000, image: 'anh2'),
    Product(id: 'P03', name: 'Mit', price: 40000, image: 'anh3'),
    Product(id: 'P04', name: 'Buoi', price: 50000, image: 'anh4'),
    Product(id: 'P05', name: 'Xoai', price: 60000, image: 'anh5'),
    Product(id: 'P06', name: 'Dua hau', price: 70000, image: 'anh6'),
    Product(id: 'P07', name: 'Chom chom', price: 70000, image: 'anh7'),
    Product(id: 'P08', name: 'Nhan', price: 70000, image: 'anh8'),
    Product(id: 'P09', name: 'Man', price: 70000, image: 'anh9'),
    Product(id: 'P10', name: 'Ot', price: 70000, image: 'anh10'),
    Product(id: 'P11', name: 'Chuoi', price: 15000, image: 'anh11'),
    Product(id: 'P12', name: 'Tao', price: 45000, image: 'anh12'),
  ];
}
