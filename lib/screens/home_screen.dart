import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import '../data/product_repository.dart';
import '../data/auth_data.dart';
import 'seller_profile_screen.dart';
import 'admin_add_product_screen.dart';
import 'login_screen.dart';
import '../models/product.dart';
import 'product_details_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color(0xFF2FA4A9); // teal

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  ValueNotifier<List<Product>> filteredProducts = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    ProductRepository.fetchProducts().then((_) {
      filteredProducts.value = List.from(productNotifier.value);
    });

    // Update filtered list when products change
    productNotifier.addListener(() {
      filterProducts(searchController.text);
    });

    // Update filtered list as user types
    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }

  void filterProducts(String query) {
    final lowerQuery = query.toLowerCase();
    filteredProducts.value = productNotifier.value
        .where((p) => p.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: filteredProducts,
      builder: (context, productList, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Local Market"),
            backgroundColor: HomeScreen.primaryColor,
            actions: [
              // ADMIN BUTTON
              if (AuthData.currentUserRole == 'admin' || AuthData.currentUserRole == 'seller')
                IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminAddProductScreen(),
                      ),
                    );
                  },
                ),

              // LOGOUT BUTTON
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  AuthData.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // 🔍 Search bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // 🛒 Product list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: productList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final product = productList[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            // 🖼 Image
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(14),
                              ),
                              child: Image.asset(
                                product.image,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 📦 Info (name, seller, price, add button)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SellerProfileScreen(
                                              sellerName: product.seller,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        product.seller,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: HomeScreen.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${product.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: HomeScreen.primaryColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            addToCart(product);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("${product.name} added"),
                                                duration: const Duration(seconds: 1),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: HomeScreen.primaryColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: HomeScreen.primaryColor,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    );

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    filteredProducts.dispose();
    super.dispose();
  }
}
