import 'package:flutter/material.dart';
import 'package:labprm393/lab5/Entity/Product.dart';
import 'package:labprm393/lab5/Pages/Productdetail.dart';

// Widget hien thi danh sach san pham cho tab Catalog.
// Ben trong co TabBar + TabBarView de dap ung yeu cau de bai.
class ProductListWidget extends StatelessWidget {
  final ValueChanged<Product> onAddToCart;

  const ProductListWidget({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    // Danh sach goc duoc lay tu model.
    final products = Product.products;

    // Tab New lay 4 san pham cuoi de mo phong hang moi.
    final newProducts = products.reversed.take(4).toList();

    // Tab Best price loc cac san pham co gia de tiep can nhat.
    final bestPriceProducts = products
        .where((product) => product.price <= 45000)
        .toList();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            // TabBar nam o dau trang Catalog.
            child: const TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'New'),
                Tab(text: 'Best price'),
              ],
            ),
          ),
          Expanded(
            // Moi tab se hien thi mot GridView san pham rieng.
            child: TabBarView(
              children: [
                ResponsiveProductGrid(
                  products: products,
                  onAddToCart: onAddToCart,
                ),
                ResponsiveProductGrid(
                  products: newProducts,
                  onAddToCart: onAddToCart,
                ),
                ResponsiveProductGrid(
                  products: bestPriceProducts,
                  onAddToCart: onAddToCart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveProductGrid extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onAddToCart;

  const ResponsiveProductGrid({
    super.key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Lay be rong thuc te cua vung hien thi de quyet dinh so cot.
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 980
            ? 4
            : width >= 720
                ? 3
                : width >= 420
                    ? 2
                    : 1;
        // Chieu cao card co dinh giup tranh overflow tren test va man hinh hep.
        final mainAxisExtent = crossAxisCount == 1 ? 360.0 : 330.0;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: mainAxisExtent,
          ),
          // Render dong: so item phu thuoc du lieu danh sach duoc truyen vao.
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: products[index],
              onAddToCart: onAddToCart,
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final ValueChanged<Product> onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // So lan bam nut them gio tren rieng card nay.
  int count = 0;

  // Mo man hinh chi tiet va gui Product qua arguments.
  void _openDetail() {
    Navigator.pushNamed(
      context,
      ProductDetailPage.routeName,
      arguments: widget.product,
    );
  }

  // Tang count local, thong bao len HomePage qua callback
  // va hien SnackBar de nguoi dung thay hanh dong da duoc ghi nhan.
  void _addToCart() {
    setState(() => count++);
    widget.onAddToCart(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: _openDetail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nua tren card la khu vuc anh san pham.
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: Colors.orange.shade50,
                child: Image.asset(
                  product.assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Neu anh loi thi hien icon thay the.
                    return const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Nua duoi card la ten, ma, gia va thao tac.
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${product.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price.toStringAsFixed(0)} VND',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          // Nut View cung dieu huong sang chi tiet,
                          // phong truong hop nguoi dung khong muon bam ca card.
                          child: OutlinedButton(
                            onPressed: _openDetail,
                            child: const Text('View'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Nut them gio tren card.
                        IconButton.filledTonal(
                          onPressed: _addToCart,
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                        ),
                        const SizedBox(width: 6),
                        // Hien thi count local cua card hien tai.
                        Text(
                          '$count',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
