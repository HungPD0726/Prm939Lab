import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labprm393/lab5/lab5_app.dart';

void main() {
  // Bai test nay kiem tra 3 yeu cau quan trong:
  // 1. Home co BottomNavigationBar va TabBar.
  // 2. Bam vao san pham thi mo duoc trang detail.
  // 3. Bam icon info thi mo duoc trang About.
  testWidgets('Lab5 app shows bottom navigation, tabs and detail route', (
    tester,
  ) async {
    // Render toan bo app.
    await tester.pumpWidget(const Lab5App());
    await tester.pumpAndSettle();

    // Xac nhan giao dien goc da hien dung cac thanh dieu huong.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Cam'), findsOneWidget);

    // Bam vao ten san pham dau tien de mo detail.
    await tester.tap(find.text('Cam').first);
    await tester.pumpAndSettle();

    // Sau khi dieu huong, man hinh detail phai co title va vung Overview.
    expect(find.text('Product Detail'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Cam'), findsWidgets);

    // Quay lai Home roi mo trang About.
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    // Kiem tra trang About da hien thong tin can thiet.
    expect(find.text('About page'), findsOneWidget);
    expect(find.text('Student information'), findsOneWidget);
  });
}
