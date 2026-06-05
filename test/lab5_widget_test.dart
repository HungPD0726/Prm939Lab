import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labprm393/lab5/dao/product_dao.dart';
import 'package:labprm393/lab5/lab5_app.dart';
import 'package:labprm393/lab5/model/lab5_product.dart';

void main() {
  testWidgets('Lab5 app shows navigation, tabs, and opens detail', (
    tester,
  ) async {
    final repository = _FakeProductDAO();

    await tester.pumpWidget(Lab5App(repository: repository));
    await _pumpUntilFound(tester, find.text('Home Jersey 2026'));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Home Jersey 2026'), findsOneWidget);

    await tester.tap(find.text('Home Jersey 2026'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Product Detail'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Home Jersey 2026'), findsWidgets);
  });
}

class _FakeProductDAO extends ProductDAO {
  _FakeProductDAO() {
    _products = [
      for (var i = 0; i < Lab5Product.seedProducts().length; i++)
        Lab5Product.seedProducts()[i].copyWith(id: i + 1),
    ];
  }

  late List<Lab5Product> _products;

  @override
  Future<List<String>> getCategories() async {
    return Lab5Product.categories;
  }

  @override
  Future<List<Lab5Product>> getAll({
    String? category,
    String? query,
    bool favoritesOnly = false,
  }) async {
    final keyword = query?.trim().toLowerCase() ?? '';

    return _products.where((product) {
      final matchesFavorite = !favoritesOnly || product.isFavorite;
      final matchesCategory =
          category == null ||
          category.isEmpty ||
          category == Lab5Product.allCategory ||
          product.category == category;
      final matchesQuery =
          keyword.isEmpty ||
          product.name.toLowerCase().contains(keyword) ||
          product.category.toLowerCase().contains(keyword) ||
          product.description.toLowerCase().contains(keyword);

      return matchesFavorite && matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Future<Lab5Product?> getById(int id) async {
    for (final product in _products) {
      if (product.id == id) {
        return product;
      }
    }

    return null;
  }

  @override
  Future<int> insert(Lab5Product product) async {
    final nextId = _products.length + 1;
    _products.add(product.copyWith(id: nextId));

    return nextId;
  }

  @override
  Future<int> update(Lab5Product product) async {
    final id = product.id;
    if (id == null) {
      return 0;
    }

    final index = _products.indexWhere((item) => item.id == id);
    if (index < 0) {
      return 0;
    }

    _products[index] = product;
    return 1;
  }

  @override
  Future<int> delete(int id) async {
    final before = _products.length;
    _products.removeWhere((product) => product.id == id);

    return before == _products.length ? 0 : 1;
  }

  @override
  Future<Lab5Product?> toggleFavorite(int id) async {
    final index = _products.indexWhere((product) => product.id == id);
    if (index < 0) {
      return null;
    }

    final updated = _products[index].copyWith(
      isFavorite: !_products[index].isFavorite,
    );
    _products[index] = updated;

    return updated;
  }
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxFrames = 20,
}) async {
  for (var frame = 0; frame < maxFrames; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  final visibleTexts = tester
      .widgetList<Text>(find.byType(Text))
      .map((widget) => widget.data ?? widget.textSpan?.toPlainText())
      .whereType<String>()
      .join(', ');

  fail(
    'Expected finder to match before timeout: $finder. Texts: $visibleTexts',
  );
}
