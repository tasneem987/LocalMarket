import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import '../data/cart_data.dart'; // ✅ IMPORTANT
import '../data/auth_data.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!AuthData.isLoggedIn) {
      return const LoginScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Market'),
        centerTitle: true,
        elevation: 2,
      ),

      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        // ❌ removed const here
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Shop',
          ),

          BottomNavigationBarItem(
            icon: ValueListenableBuilder(
              valueListenable: cartNotifier,
              builder: (context, cart, _) {
                return Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cart.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            cart.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Cart',
          ),

        ],
      ),
    );
  }
}
