import 'package:flutter_test/flutter_test.dart';

import 'package:labprm393/lab1/controller/product_controller.dart';
import 'package:labprm393/lab1/lab1_app.dart';

void main() {
  setUp(() {
    ProductController.resetProducts();
  });

  testWidgets('Product lab screen renders sample products', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const Lab1App());
    await tester.pumpAndSettle();

    expect(find.text('Danh sach san pham'), findsOneWidget);
    expect(find.text('Tao Fuji'), findsOneWidget);
    expect(find.textContaining('Tong so san pham: 10'), findsOneWidget);
  });
}
