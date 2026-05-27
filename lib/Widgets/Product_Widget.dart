
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    'assets/cr7.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Product name, price, rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cristiano Ronaldo",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Price: 450\$",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    const Text(
                      "4.9",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " (41)",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Star Icons
            Row(
              children: [
                for (int i = 0; i < 5; i++)
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "(5.0)",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 24),
            // Product Description
            const Text(
              "Cristiano Ronaldo is one of the greatest football players of all time. This product represents his legacy and excellence on the field.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
