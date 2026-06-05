import 'package:flutter/material.dart';

import '../dao/product_dao.dart';
import '../model/lab5_product.dart';
import '../routes.dart';
import '../util/lab5_formatters.dart';
import '../widgets/lab5_product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.repository,
    required this.product,
  });

  final ProductDAO repository;
  final Lab5Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Lab5Product?> _future;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _future = _loadProduct();
  }

  Future<Lab5Product?> _loadProduct() {
    final id = widget.product.id;
    if (id == null) {
      return Future.value(widget.product);
    }

    return widget.repository.getById(id);
  }

  void _reload() {
    setState(() {
      _future = _loadProduct();
    });
  }

  void _close() {
    Navigator.pop(context, _changed);
  }

  Future<void> _toggleFavorite(Lab5Product product) async {
    final id = product.id;
    if (id == null) {
      return;
    }

    final updated = await widget.repository.toggleFavorite(id);

    if (!mounted || updated == null) {
      return;
    }

    setState(() {
      _changed = true;
      _future = Future.value(updated);
    });
  }

  Future<void> _editProduct(Lab5Product product) async {
    final changed = await Navigator.pushNamed(
      context,
      Lab5Routes.productForm,
      arguments: ProductFormArguments(product: product),
    );

    if (!mounted) {
      return;
    }

    if (changed == true) {
      _changed = true;
      _reload();
    }
  }

  Future<void> _deleteProduct(Lab5Product product) async {
    final id = product.id;
    if (id == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete product'),
          content: Text('Delete "${product.name}" from the database?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    await widget.repository.delete(id);

    if (!mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lab5Product?>(
      future: _future,
      builder: (context, snapshot) {
        final product = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: _close),
            title: const Text('Product Detail'),
            actions: [
              if (product != null) ...[
                Tooltip(
                  message: product.isFavorite
                      ? 'Remove favorite'
                      : 'Add favorite',
                  child: IconButton(
                    onPressed: () => _toggleFavorite(product),
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Edit',
                  child: IconButton(
                    onPressed: () => _editProduct(product),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
                Tooltip(
                  message: 'Delete',
                  child: IconButton(
                    onPressed: () => _deleteProduct(product),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              ],
            ],
          ),
          body: _buildBody(snapshot),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<Lab5Product?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text(snapshot.error.toString()));
    }

    final product = snapshot.data;
    if (product == null) {
      return const Center(child: Text('Product not found.'));
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _DetailBanner(product: product),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.category_outlined, size: 18),
                    label: Text(product.category),
                  ),
                  Chip(
                    avatar: const Icon(Icons.star_rounded, size: 18),
                    label: Text(product.rating.toStringAsFixed(1)),
                  ),
                  Chip(
                    avatar: const Icon(Icons.inventory_2_outlined, size: 18),
                    label: Text('${product.quantity} in stock'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
              const SizedBox(height: 22),
              _DetailActions(
                product: product,
                onFavorite: () => _toggleFavorite(product),
                onEdit: () => _editProduct(product),
                onDelete: () => _deleteProduct(product),
              ),
              const SizedBox(height: 22),
              _DetailInfo(product: product),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailBanner extends StatelessWidget {
  const _DetailBanner({required this.product});

  final Lab5Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 270,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Lab5ProductImage(
            imageAsset: product.imageAsset,
            radius: 0,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.72),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatLab5Currency(product.price),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailActions extends StatelessWidget {
  const _DetailActions({
    required this.product,
    required this.onFavorite,
    required this.onEdit,
    required this.onDelete,
  });

  final Lab5Product product;
  final VoidCallback onFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton.icon(
          onPressed: onFavorite,
          icon: Icon(
            product.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
          ),
          label: Text(product.isFavorite ? 'Favorited' : 'Favorite'),
        ),
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit'),
        ),
        OutlinedButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
        ),
      ],
    );
  }
}

class _DetailInfo extends StatelessWidget {
  const _DetailInfo({required this.product});

  final Lab5Product product;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Database ID', product.id?.toString() ?? 'New'),
      ('Category', product.category),
      ('Price', formatLab5Currency(product.price)),
      ('Quantity', product.quantity.toString()),
      ('Rating', product.rating.toStringAsFixed(1)),
      ('Created', product.createdAt.toIso8601String().split('T').first),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var index = 0; index < rows.length; index++) ...[
              _InfoRow(label: rows[index].$1, value: rows[index].$2),
              if (index < rows.length - 1) const Divider(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
