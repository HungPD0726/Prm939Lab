import 'package:flutter/material.dart';

import '../dao/product_dao.dart';
import '../model/lab5_product.dart';
import '../routes.dart';
import '../util/lab5_formatters.dart';
import '../widgets/lab5_product_card.dart';
import '../widgets/lab5_product_image.dart';

class Lab5HomeScreen extends StatefulWidget {
  const Lab5HomeScreen({super.key, required this.repository});

  final ProductDAO repository;

  @override
  State<Lab5HomeScreen> createState() => _Lab5HomeScreenState();
}

class _Lab5HomeScreenState extends State<Lab5HomeScreen> {
  int _selectedIndex = 0;
  int _refreshToken = 0;

  void _refreshProducts() {
    setState(() {
      _refreshToken++;
    });
  }

  Future<void> _openProductForm([Lab5Product? product]) async {
    final changed = await Navigator.pushNamed(
      context,
      Lab5Routes.productForm,
      arguments: ProductFormArguments(product: product),
    );

    if (!mounted) {
      return;
    }

    if (changed == true) {
      _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Products', 'Favorites', 'Manage'];
    final pages = [
      _ProductsPage(
        repository: widget.repository,
        refreshToken: _refreshToken,
        onChanged: _refreshProducts,
      ),
      _FavoritesPage(
        repository: widget.repository,
        refreshToken: _refreshToken,
        onChanged: _refreshProducts,
      ),
      _ManagePage(
        repository: widget.repository,
        refreshToken: _refreshToken,
        onChanged: _refreshProducts,
        onAddPressed: () => _openProductForm(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lab 5 - ${titles[_selectedIndex]}'),
        actions: [
          Tooltip(
            message: 'Add product',
            child: IconButton(
              onPressed: () => _openProductForm(),
              icon: const Icon(Icons.add_box_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProductForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Manage',
          ),
        ],
      ),
    );
  }
}

class _ProductsPage extends StatefulWidget {
  const _ProductsPage({
    required this.repository,
    required this.refreshToken,
    required this.onChanged,
  });

  final ProductDAO repository;
  final int refreshToken;
  final VoidCallback onChanged;

  @override
  State<_ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<_ProductsPage> {
  final _searchController = TextEditingController();
  late Future<List<String>> _categoriesFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategories();
  }

  @override
  void didUpdateWidget(covariant _ProductsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      _categoriesFuture = _loadCategories();
    }
  }

  Future<List<String>> _loadCategories() async {
    final categories = await widget.repository.getCategories();

    if (categories.isEmpty) {
      return Lab5Product.categories;
    }

    return categories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _StateMessage(
            icon: Icons.error_outline,
            title: 'Could not load categories',
            message: snapshot.error.toString(),
            action: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _categoriesFuture = _loadCategories();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }

        final tabs = [
          Lab5Product.allCategory,
          ...(snapshot.data ?? Lab5Product.categories),
        ];

        return DefaultTabController(
          key: ValueKey(tabs.join('|')),
          length: tabs.length,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _query = '';
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                    labelText: 'Search products',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                ),
              ),
              Material(
                color: Theme.of(context).colorScheme.surface,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [for (final tab in tabs) Tab(text: tab)],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    for (final tab in tabs)
                      _ProductListSection(
                        repository: widget.repository,
                        category: tab,
                        query: _query,
                        favoritesOnly: false,
                        refreshToken: widget.refreshToken,
                        emptyTitle: 'No products found',
                        onChanged: widget.onChanged,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FavoritesPage extends StatelessWidget {
  const _FavoritesPage({
    required this.repository,
    required this.refreshToken,
    required this.onChanged,
  });

  final ProductDAO repository;
  final int refreshToken;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Text(
            'Favorite products',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Expanded(
          child: _ProductListSection(
            repository: repository,
            category: Lab5Product.allCategory,
            query: '',
            favoritesOnly: true,
            refreshToken: refreshToken,
            emptyTitle: 'No favorite products yet',
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _ProductListSection extends StatefulWidget {
  const _ProductListSection({
    required this.repository,
    required this.category,
    required this.query,
    required this.favoritesOnly,
    required this.refreshToken,
    required this.emptyTitle,
    required this.onChanged,
  });

  final ProductDAO repository;
  final String category;
  final String query;
  final bool favoritesOnly;
  final int refreshToken;
  final String emptyTitle;
  final VoidCallback onChanged;

  @override
  State<_ProductListSection> createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<_ProductListSection> {
  late Future<List<Lab5Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchProducts();
  }

  @override
  void didUpdateWidget(covariant _ProductListSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.category != widget.category ||
        oldWidget.query != widget.query ||
        oldWidget.favoritesOnly != widget.favoritesOnly ||
        oldWidget.refreshToken != widget.refreshToken) {
      _reload();
    }
  }

  Future<List<Lab5Product>> _fetchProducts() {
    return widget.repository.getAll(
      category: widget.category,
      query: widget.query,
      favoritesOnly: widget.favoritesOnly,
    );
  }

  void _reload() {
    setState(() {
      _future = _fetchProducts();
    });
  }

  Future<void> _refresh() async {
    _reload();
    await _future;
  }

  Future<void> _toggleFavorite(Lab5Product product) async {
    final id = product.id;
    if (id == null) {
      return;
    }

    await widget.repository.toggleFavorite(id);

    if (!mounted) {
      return;
    }

    widget.onChanged();
    _reload();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          product.isFavorite ? 'Removed from favorites' : 'Added favorite',
        ),
      ),
    );
  }

  Future<void> _openDetail(Lab5Product product) async {
    final changed = await Navigator.pushNamed(
      context,
      Lab5Routes.productDetail,
      arguments: ProductDetailArguments(product: product),
    );

    if (!mounted) {
      return;
    }

    if (changed == true) {
      widget.onChanged();
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lab5Product>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _StateMessage(
            icon: Icons.error_outline,
            title: 'Could not load products',
            message: snapshot.error.toString(),
            action: OutlinedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
                _StateMessage(
                  icon: Icons.inventory_2_outlined,
                  title: widget.emptyTitle,
                  message: 'Pull down to refresh the database list.',
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 96),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Lab5ProductCard(
                product: product,
                onTap: () => _openDetail(product),
                onFavoritePressed: () => _toggleFavorite(product),
              );
            },
          ),
        );
      },
    );
  }
}

class _ManagePage extends StatefulWidget {
  const _ManagePage({
    required this.repository,
    required this.refreshToken,
    required this.onChanged,
    required this.onAddPressed,
  });

  final ProductDAO repository;
  final int refreshToken;
  final VoidCallback onChanged;
  final VoidCallback onAddPressed;

  @override
  State<_ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<_ManagePage> {
  late Future<List<Lab5Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getAll();
  }

  @override
  void didUpdateWidget(covariant _ManagePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      _reload();
    }
  }

  void _reload() {
    setState(() {
      _future = widget.repository.getAll();
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
      widget.onChanged();
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

    widget.onChanged();
    _reload();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name} deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lab5Product>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _StateMessage(
            icon: Icons.error_outline,
            title: 'Could not load inventory',
            message: snapshot.error.toString(),
            action: OutlinedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }

        final products = snapshot.data ?? [];
        final totalStock = products.fold<int>(
          0,
          (sum, product) => sum + product.quantity,
        );
        final totalValue = products.fold<double>(
          0,
          (sum, product) => sum + product.price * product.quantity,
        );

        return RefreshIndicator(
          onRefresh: () async {
            _reload();
            await _future;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              _InventorySummary(
                totalProducts: products.length,
                totalStock: totalStock,
                totalValue: totalValue,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: widget.onAddPressed,
                icon: const Icon(Icons.add),
                label: const Text('Add product'),
              ),
              const SizedBox(height: 12),
              for (final product in products)
                _ManageProductTile(
                  product: product,
                  onEdit: () => _editProduct(product),
                  onDelete: () => _deleteProduct(product),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _InventorySummary extends StatelessWidget {
  const _InventorySummary({
    required this.totalProducts,
    required this.totalStock,
    required this.totalValue,
  });

  final int totalProducts;
  final int totalStock;
  final double totalValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 18,
          runSpacing: 14,
          children: [
            _SummaryValue(label: 'Products', value: '$totalProducts'),
            _SummaryValue(label: 'Stock', value: '$totalStock'),
            _SummaryValue(
              label: 'Inventory value',
              value: formatLab5Currency(totalValue),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 92),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ManageProductTile extends StatelessWidget {
  const _ManageProductTile({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final Lab5Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Lab5ProductImage(
          imageAsset: product.imageAsset,
          width: 52,
          height: 52,
        ),
        title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${product.category} - ${formatLab5Currency(product.price)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: 2,
          children: [
            Tooltip(
              message: 'Edit',
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
            Tooltip(
              message: 'Delete',
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
