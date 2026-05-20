import 'package:flutter/material.dart';

import 'controller/product_controller.dart';

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProductScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ProductController.getProducts();

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sach san pham')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Tong so san pham: ${products.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final product in products)
            Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(product.image),
                trailing: Text('${product.price.toStringAsFixed(0)} VND'),
              ),
            ),
        ],
      ),
    );
  }
}
