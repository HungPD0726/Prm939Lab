import 'package:flutter/material.dart';

import 'view/product_page.dart';

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product List',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ProductPage(),
    );
  }
}
