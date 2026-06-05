import 'package:flutter/material.dart';

import '../dao/product_dao.dart';
import '../model/lab5_product.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, required this.repository, this.product});

  final ProductDAO repository;
  final Lab5Product? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageController = TextEditingController(text: 'assets/cr7.jpg');

  late Future<List<String>> _categoriesFuture;
  late String _category;
  late double _rating;
  bool _saving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;
    _category = product?.category ?? Lab5Product.categories.first;
    _rating = product?.rating ?? 4.5;
    _categoriesFuture = _loadCategories();

    if (product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toStringAsFixed(0);
      _quantityController.text = product.quantity.toString();
      _imageController.text = product.imageAsset;
    }
  }

  Future<List<String>> _loadCategories() async {
    try {
      final categories = await widget.repository.getCategories();
      final merged = {
        ...categories.where((category) => category.trim().isNotEmpty),
        _category,
      }.toList();

      return merged.isEmpty ? Lab5Product.categories : merged;
    } catch (_) {
      return [
        ...Lab5Product.categories,
        if (!Lab5Product.categories.contains(_category)) _category,
      ];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final existing = widget.product;
    final product = Lab5Product(
      id: existing?.id,
      name: _nameController.text.trim(),
      category: _category,
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      quantity: int.parse(_quantityController.text.trim()),
      rating: _rating,
      imageAsset: _imageController.text.trim(),
      isFavorite: existing?.isFavorite ?? false,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );

    try {
      if (_isEditing) {
        await widget.repository.update(product);
      } else {
        await widget.repository.insert(product);
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save product: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit product' : 'Add product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Product name',
                prefixIcon: Icon(Icons.sell_outlined),
              ),
              validator: _requiredText,
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<String>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                final categories = snapshot.data ?? [_category];

                return DropdownButtonFormField<String>(
                  initialValue: categories.contains(_category)
                      ? _category
                      : categories.first,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: [
                    for (final category in categories)
                      DropdownMenuItem(value: category, child: Text(category)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              validator: _requiredText,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(Icons.payments_outlined),
                suffixText: 'VND',
              ),
              validator: _positiveDouble,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              validator: _positiveInt,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Image asset',
                prefixIcon: Icon(Icons.image_outlined),
              ),
              validator: _requiredText,
            ),
            const SizedBox(height: 18),
            Text(
              'Rating: ${_rating.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 8,
              label: _rating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _saving ? null : _saveProduct,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isEditing ? 'Save changes' : 'Create product'),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  String? _positiveDouble(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a price greater than 0.';
    }

    return null;
  }

  String? _positiveInt(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 0) {
      return 'Enter a quantity of 0 or more.';
    }

    return null;
  }
}
