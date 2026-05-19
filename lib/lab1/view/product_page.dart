import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../entity/product.dart';
import 'product_dialog.dart';
import 'widgets/product_list_tile.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _sortLabel = 'Mac dinh';

  Future<void> _addProduct() async {
    final product = await showDialog<Product>(
      context: context,
      builder: (context) => const ProductDialog(),
    );

    if (!mounted || product == null) {
      return;
    }

    try {
      ProductController.addProduct(product);
      setState(() {});
      _showMessage('Da them ${product.name}.');
    } on ArgumentError catch (error) {
      _showMessage(error.message.toString());
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoa san pham'),
        content: Text('Ban co chac muon xoa ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ProductController.deleteProduct(product.id);
      setState(() {});
      _showMessage('Da xoa ${product.name}.');
    }
  }

  void _sortByName(bool ascending) {
    ProductController.sortByName(ascending: ascending);
    setState(() {
      _sortLabel = ascending ? 'Ten A-Z' : 'Ten Z-A';
    });
  }

  void _sortByPrice(bool ascending) {
    ProductController.sortByPrice(ascending: ascending);
    setState(() {
      _sortLabel = ascending ? 'Gia tang dan' : 'Gia giam dan';
    });
  }

  void _resetProducts() {
    ProductController.resetProducts();
    setState(() {
      _sortLabel = 'Mac dinh';
    });
    _showMessage('Da reset danh sach.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final products = ProductController.getProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sach san pham'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Them'),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'name_asc':
                        _sortByName(true);
                        break;
                      case 'name_desc':
                        _sortByName(false);
                        break;
                      case 'price_asc':
                        _sortByPrice(true);
                        break;
                      case 'price_desc':
                        _sortByPrice(false);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'name_asc',
                      child: Text('Sap xep ten A-Z'),
                    ),
                    PopupMenuItem(
                      value: 'name_desc',
                      child: Text('Sap xep ten Z-A'),
                    ),
                    PopupMenuItem(
                      value: 'price_asc',
                      child: Text('Gia tang dan'),
                    ),
                    PopupMenuItem(
                      value: 'price_desc',
                      child: Text('Gia giam dan'),
                    ),
                  ],
                  child: IgnorePointer(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sort),
                      label: Text('Sap xep: $_sortLabel'),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _resetProducts,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Tong so san pham: ${products.length}'),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductListTile(
                  product: product,
                  onDelete: () => _deleteProduct(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
