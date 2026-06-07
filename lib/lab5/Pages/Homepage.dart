import 'package:flutter/material.dart';
import 'package:labprm393/lab5/Entity/Product.dart';
import 'package:labprm393/lab5/Pages/Aboutpage.dart';
import 'package:labprm393/lab5/Repository/Product_Widget.dart';

// Trang chinh cua Lab 5.
// Trang nay ket hop 3 yeu cau lon:
// 1. Hien thi danh sach san pham dong.
// 2. Dieu huong bang BottomNavigationBar.
// 3. Mo trang About bang Router.
class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Chi so tab dang duoc chon o BottomNavigationBar.
  int _selectedIndex = 0;

  // Tong so lan nguoi dung bam them vao gio.
  int _cartCount = 0;

  // Luu lai san pham gan nhat duoc them vao gio de hien thi o trang Overview.
  Product? _lastAddedProduct;

  // Ham callback nhan Product tu card san pham.
  // Moi lan bam them vao gio, state cua HomePage se cap nhat.
  void _handleAddToCart(Product product) {
    setState(() {
      _cartCount++;
      _lastAddedProduct = product;
    });
  }

  // Dieu huong sang trang gioi thieu bang named route.
  void _openAboutPage() {
    Navigator.pushNamed(context, AboutPage.routeName);
  }

  // Tieu de AppBar thay doi theo tab dang chon.
  String get _title {
    switch (_selectedIndex) {
      case 1:
        return 'Featured products';
      case 2:
        return 'Lab 5 overview';
      default:
        return 'Product catalog';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loc nhom san pham co gia tu 50k tro len de dua vao tab Featured.
    final featuredProducts = Product.products
        .where((product) => product.price >= 50000)
        .toList();

    // Danh sach body ung voi tung muc cua BottomNavigationBar.
    // Su dung list nay giup viec doi man hinh gon hon, khong can viet switch trong body.
    final pages = <Widget>[
      ProductListWidget(onAddToCart: _handleAddToCart),
      FeaturedProductsSection(
        products: featuredProducts,
        cartCount: _cartCount,
        onAddToCart: _handleAddToCart,
      ),
      OverviewSection(
        cartCount: _cartCount,
        lastAddedProduct: _lastAddedProduct,
        onOpenAbout: _openAboutPage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: Text(_title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openAboutPage,
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
          ),
        ],
      ),
      // IndexedStack giu nguyen state cua cac tab khi chuyen qua lai.
      // Vi du: tab catalog co TabBar, khi quay lai se khong mat trang thai dang xem.
      body: IndexedStack(index: _selectedIndex, children: pages),
      // BottomNavigationBar la dieu kien bat buoc cua de bai lab.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            activeIcon: Icon(Icons.local_offer),
            label: 'Featured',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
        ],
      ),
    );
  }
}

class FeaturedProductsSection extends StatelessWidget {
  final List<Product> products;
  final int cartCount;
  final ValueChanged<Product> onAddToCart;

  const FeaturedProductsSection({
    super.key,
    required this.products,
    required this.cartCount,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              // The thong tin tong quan o dau man hinh Featured.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Highlighted collection',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${products.length} products are in the featured price range.',
                ),
                const SizedBox(height: 4),
                Text('Items added to cart: $cartCount'),
              ],
            ),
          ),
        ),
        // Phan con lai la luoi san pham responsive.
        Expanded(
          child: ResponsiveProductGrid(
            products: products,
            onAddToCart: onAddToCart,
          ),
        ),
      ],
    );
  }
}

class OverviewSection extends StatelessWidget {
  final int cartCount;
  final Product? lastAddedProduct;
  final VoidCallback onOpenAbout;

  const OverviewSection({
    super.key,
    required this.cartCount,
    required this.lastAddedProduct,
    required this.onOpenAbout,
  });

  @override
  Widget build(BuildContext context) {
    // Neu chua them san pham nao thi hien thong bao rong.
    // Neu da them thi hien ten san pham vua duoc them gan nhat.
    final infoText = lastAddedProduct == null
        ? 'No product has been added yet.'
        : 'Last added product: ${lastAddedProduct!.name}';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 3 card dau dung de tom tat cac yeu cau cua de bai.
        _OverviewCard(
          title: 'Dynamic product list',
          subtitle:
              'Products are rendered from the Product.products collection.',
          icon: Icons.view_list_outlined,
        ),
        _OverviewCard(
          title: 'BottomNavigationBar',
          subtitle:
              'The main page switches between catalog, featured, and overview.',
          icon: Icons.space_dashboard_outlined,
        ),
        _OverviewCard(
          title: 'TabBar and Router',
          subtitle:
              'The catalog uses tabs, and each product opens a detail page with named routes.',
          icon: Icons.route_outlined,
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              child: Icon(Icons.shopping_cart_outlined),
            ),
            // Card nay la bang thong ke mini lay du lieu tu state HomePage.
            title: Text('Items added to cart: $cartCount'),
            subtitle: Text(infoText),
          ),
        ),
        const SizedBox(height: 12),
        // Nut nay mo trang About bang Router de minh hoa dieu huong giua cac page.
        ElevatedButton.icon(
          onPressed: onOpenAbout,
          icon: const Icon(Icons.person_outline),
          label: const Text('Open about page'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OverviewCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        // Avatar icon giup tung card de nhan dien hon thay vi chi co text.
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          foregroundColor: Colors.orange.shade900,
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
