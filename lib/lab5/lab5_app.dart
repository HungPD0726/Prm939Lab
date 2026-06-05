import 'package:flutter/material.dart';

import 'dao/product_dao.dart';
import 'model/lab5_product.dart';
import 'routes.dart';
import 'screens/lab5_home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_form_screen.dart';

class Lab5App extends StatefulWidget {
  const Lab5App({super.key, this.repository});

  final ProductDAO? repository;

  @override
  State<Lab5App> createState() => _Lab5AppState();
}

class _Lab5AppState extends State<Lab5App> {
  late final ProductDAO _repository =
      widget.repository ?? ProductDAO.defaultDao();

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 5 Product App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: Lab5Routes.home,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<Object?> _onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<Object?>(
      settings: settings,
      builder: (context) {
        switch (settings.name) {
          case Lab5Routes.home:
            return Lab5HomeScreen(repository: _repository);
          case Lab5Routes.productDetail:
            final product = _productFromDetailArguments(settings.arguments);
            if (product == null) {
              return const _RouteErrorScreen(message: 'Product not found.');
            }

            return ProductDetailScreen(
              repository: _repository,
              product: product,
            );
          case Lab5Routes.productForm:
            return ProductFormScreen(
              repository: _repository,
              product: _productFromFormArguments(settings.arguments),
            );
          default:
            return const _RouteErrorScreen(message: 'Unknown route.');
        }
      },
    );
  }

  Lab5Product? _productFromDetailArguments(Object? arguments) {
    if (arguments is ProductDetailArguments) {
      return arguments.product;
    }

    if (arguments is Lab5Product) {
      return arguments;
    }

    return null;
  }

  Lab5Product? _productFromFormArguments(Object? arguments) {
    if (arguments is ProductFormArguments) {
      return arguments.product;
    }

    if (arguments is Lab5Product) {
      return arguments;
    }

    return null;
  }
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 5')),
      body: Center(child: Text(message)),
    );
  }
}
