import 'package:flutter/material.dart';
import 'package:labprm393/lab5/Entity/Product.dart';

// Trang chi tiet san pham.
// Du lieu Product khong duoc tao tai day ma duoc truyen qua route arguments
// tu danh sach san pham khi nguoi dung bam vao 1 card.
class ProductDetailPage extends StatelessWidget {
  static const routeName = '/detail';

  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Doc object Product da gui kem khi Navigator.pushNamed.
    // Ep kieu Product? de tranh crash neu mo route ma khong truyen du lieu.
    final product = ModalRoute.of(context)?.settings.arguments as Product?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text('Product Detail'),
        centerTitle: true,
      ),
      // Neu route duoc mo sai cach va khong co arguments,
      // app van hien thong bao thay vi bi loi.
      body: product == null
          ? const Center(
              child: Text('Product data is not available.'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Anh lon cua san pham.
                // Duong dan duoc tao tu getter assetPath trong model Product.
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      product.assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback khi file anh khong ton tai.
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: ${product.price.toStringAsFixed(0)} VND',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                // Card tong hop thong tin quan trong cua san pham.
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        _DetailLine(label: 'Product ID', value: product.id),
                        const SizedBox(height: 8),
                        _DetailLine(
                          label: 'Image asset',
                          value: product.assetPath,
                        ),
                        const SizedBox(height: 8),
                        _DetailLine(
                          label: 'Description',
                          value:
                            '${product.name} is displayed from the dynamic product list in Lab 5.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Quay nguoc ve danh sach bang stack cua Navigator.
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to catalog'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cot trai co do rong co dinh de cac dong can deu nhau.
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
