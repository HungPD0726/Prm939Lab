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
    final titles = ['Products', 'Favorites', 'Manage'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lab 5 - ${titles[_selectedIndex]}'),
        actions: [
          IconButton(
            tooltip: 'Add product',
            onPressed: () => _openProductForm(),
            icon: const Icon(Icons.add_box_outlined),
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
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
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
    _categoriesFuture = widget.repository.getCategories();
  }

  @override
  void didUpdateWidget(covariant _ProductsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      _categoriesFuture = widget.repository.getCategories();
    }
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
                  _categoriesFuture = widget.repository.getCategories();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }

        final tabs = [
          Lab5Product.allCategory,
          ...(snapshot.data?.isEmpty ?? true
              ? Lab5Product.categories
              : snapshot.data!),
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
                  decoration: InputDecoration(
                    labelText: 'Search products',
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
    return _ProductListSection(
      repository: repository,
      category: Lab5Product.allCategory,
      query: '',
      favoritesOnly: true,
      refreshToken: refreshToken,
      emptyTitle: 'No favorite products yet',
      onChanged: onChanged,
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
          return _StateMessage(
            icon: Icons.inventory_2_outlined,
            title: widget.emptyTitle,
            message: 'Add a product or change the current filter.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _reload();
            await _future;
          },
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
          content: Text('Delete "${product.name}"?'),
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lab5Product>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data ?? [];
        final totalStock = products.fold<int>(
          0,
          (sum, product) => sum + product.quantity,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text('${products.length} products'),
                subtitle: Text('$totalStock items in stock'),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: widget.onAddPressed,
              icon: const Icon(Icons.add),
              label: const Text('Add product'),
            ),
            const SizedBox(height: 12),
            for (final product in products)
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Lab5ProductImage(
                    imageAsset: product.imageAsset,
                    width: 52,
                    height: 52,
                  ),
                  title: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(formatLab5Currency(product.price)),
                  trailing: Wrap(
                    spacing: 2,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: () => _editProduct(product),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () => _deleteProduct(product),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
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
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
