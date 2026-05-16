import 'package:flutter_test/flutter_test.dart';

import 'package:labprm393/lab1/entity/product.dart';
import 'package:labprm393/main.dart';

void main() {
  setUp(() {
    Product.resetProducts();
  });

  testWidgets('Product lab screen renders sample products', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Lab 1 - Product OOP'), findsOneWidget);
    expect(find.text('Tao Fuji'), findsOneWidget);
    expect(find.textContaining('Tong: 4 san pham'), findsOneWidget);
  });
}
