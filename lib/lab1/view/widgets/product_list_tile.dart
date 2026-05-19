import 'package:flutter/material.dart';

import '../../entity/product.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.product,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(product.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(product.name),
        subtitle: Text(product.displayInfo()),
        isThreeLine: true,
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
