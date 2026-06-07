import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labprm393/lab6/lab6_app.dart';

void main() {
  testWidgets('Lab6 renders heading, filters by search, and shows phone layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const Lab6App());
    await tester.pumpAndSettle();

    expect(find.text('Find a Movie'), findsOneWidget);
    expect(find.byType(FilterChip), findsWidgets);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('10 movies available'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'dune');
    await tester.pumpAndSettle();

    expect(find.text('Dune: Part Two'), findsOneWidget);
    expect(find.text('1 movie available'), findsOneWidget);
  });

  testWidgets('Lab6 switches to grid layout and filters by genre chip on wide screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const Lab6App());
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(DropdownButton<MovieSort>), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Romance'));
    await tester.pumpAndSettle();

    expect(find.text('Past Lives'), findsOneWidget);
    expect(find.text('Dune: Part Two'), findsNothing);
    expect(find.text('1 movie available'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Romance'));
    await tester.pumpAndSettle();

    expect(find.text('10 movies available'), findsOneWidget);
  });
}
