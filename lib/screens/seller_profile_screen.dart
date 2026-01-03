import 'package:flutter/material.dart';
import '../data/dummy_products.dart';
import '../data/cart_data.dart';
import '../models/product.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({
    super.key,
    required this.sellerName,
  });

  final String sellerName;

  static const Color primaryColor = Color(0xFF2FA4A9);

  @override
  Widget build(BuildContext context) {
    final List<Product> sellerProducts =
    products.where((p) => p.seller == sellerName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(sellerName),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [

          // 🧑‍🌾 Seller Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Local home-based seller supporting the community.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                const Text(
                  "📍 Local Area\n📞 Contact available after order",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📦 Seller Products
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sellerProducts.length,
              itemBuilder: (context, index) {
                final product = sellerProducts[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product. image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: primaryColor,
                      onPressed: () {
                        addToCart(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${product.name} added to cart"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
