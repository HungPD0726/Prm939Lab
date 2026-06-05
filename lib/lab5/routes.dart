import 'model/lab5_product.dart';

class Lab5Routes {
  const Lab5Routes._();

  static const home = '/';
  static const productDetail = '/product-detail';
  static const productForm = '/product-form';
}

class ProductDetailArguments {
  const ProductDetailArguments({required this.product});

  final Lab5Product product;
}

class ProductFormArguments {
  const ProductFormArguments({this.product});

  final Lab5Product? product;
}
