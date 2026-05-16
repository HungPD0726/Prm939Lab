import 'package:flutter/material.dart';

import 'lab1/entity/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 1 - Product OOP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F4EC),
      ),
      home: const ProductLabPage(),
    );
  }
}

class ProductLabPage extends StatefulWidget {
  const ProductLabPage({super.key});

  @override
  State<ProductLabPage> createState() => _ProductLabPageState();
}

class _ProductLabPageState extends State<ProductLabPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  String _sortLabel = 'Mac dinh';

  List<Product> get _visibleProducts => Product.searchProducts(_searchKeyword);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openProductDialog({Product? product}) async {
    final result = await showDialog<Product>(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );

    if (!mounted || result == null) {
      return;
    }

    try {
      if (product == null) {
        Product.addProduct(result);
        _showMessage('Da them san pham ${result.name}.');
      } else {
        final updated = Product.updateProduct(product.id, result);
        if (updated) {
          _showMessage('Da cap nhat san pham ${result.name}.');
        }
      }
      setState(() {});
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
      Product.deleteProduct(product.id);
      setState(() {});
      _showMessage('Da xoa san pham ${product.name}.');
    }
  }

  void _sortByName(bool ascending) {
    Product.sortByName(ascending: ascending);
    setState(() {
      _sortLabel = ascending ? 'Ten A-Z' : 'Ten Z-A';
    });
  }

  void _sortByPrice(bool ascending) {
    Product.sortByPrice(ascending: ascending);
    setState(() {
      _sortLabel = ascending ? 'Gia tang dan' : 'Gia giam dan';
    });
  }

  void _resetProducts() {
    Product.resetProducts();
    _searchController.clear();
    setState(() {
      _searchKeyword = '';
      _sortLabel = 'Mac dinh';
    });
    _showMessage('Da khoi phuc danh sach mau.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 1 - Product OOP'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F4EC), Color(0xFFE3F1EE)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _Toolbar(
                  searchController: _searchController,
                  sortLabel: _sortLabel,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchKeyword = value;
                    });
                  },
                  onAdd: () => _openProductDialog(),
                  onSortSelected: (value) {
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
                  onReset: _resetProducts,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tong: ${products.length} san pham | Sap xep: $_sortLabel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF12312E),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: products.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          itemCount: products.length,
                          separatorBuilder: (_, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _ProductCard(
                              product: product,
                              onEdit: () =>
                                  _openProductDialog(product: product),
                              onDelete: () => _deleteProduct(product),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.searchController,
    required this.sortLabel,
    required this.onSearchChanged,
    required this.onAdd,
    required this.onSortSelected,
    required this.onReset,
  });

  final TextEditingController searchController;
  final String sortLabel;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAdd;
  final ValueChanged<String> onSortSelected;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tim theo ma, ten hoac anh',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F7F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Them'),
                ),
                PopupMenuButton<String>(
                  onSelected: onSortSelected,
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
                      label: Text('Sap xep: $sortLabel'),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final currency = '${product.price.toStringAsFixed(0)} VND';

    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.96),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFD6ECE6),
              child: Text(
                product.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F766E),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.displayInfo(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: const Color(0xFF4C5A58),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F5F0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      currency,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F5B54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  tooltip: 'Sua',
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Xoa',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 60),
              SizedBox(height: 12),
              Text(
                'Khong tim thay san pham phu hop.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({super.key, this.product});

  final Product? product;

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _imageController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.product?.id ?? '');
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _imageController = TextEditingController(text: widget.product?.image ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      Product(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        image: _imageController.text.trim(),
        price: double.parse(_priceController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return AlertDialog(
      title: Text(isEdit ? 'Sua san pham' : 'Them san pham'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FormInput(
                  controller: _idController,
                  label: 'ID',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                _FormInput(
                  controller: _nameController,
                  label: 'Ten san pham',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                _FormInput(
                  controller: _imageController,
                  label: 'Ten anh / duong dan anh',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                _FormInput(
                  controller: _priceController,
                  label: 'Gia',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Khong duoc de trong.';
                    }

                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Gia phai la so > 0.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huy'),
        ),
        FilledButton(onPressed: _submit, child: Text(isEdit ? 'Luu' : 'Them')),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Khong duoc de trong.';
    }
    return null;
  }
}

class _FormInput extends StatelessWidget {
  const _FormInput({
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
