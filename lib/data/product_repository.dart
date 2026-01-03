import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'package:flutter/foundation.dart';

ValueNotifier<List<Product>> productNotifier = ValueNotifier([]);

class ProductRepository {
  static const String _baseUrl = "http://tasneemchaheen.atwebpages.com";

  // Fetch products from PHP
  static Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/get_products.php"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          final List<Product> loadedProducts = [];

          for (var p in data['products']) {
            loadedProducts.add(
              Product(
                id: int.parse(p['id']),
                name: p['name'],
                seller: p['seller'],
                price: double.parse(p['price']),
                image: p['image'],
                description: p['description'],
              ),
            );
          }

          productNotifier.value = loadedProducts;
        } else {
          if (kDebugMode) {
            print("Error fetching products: ${data['message']}");
          }
        }
      } else {
        if (kDebugMode) {
          print("HTTP error: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception fetching products: $e");
      }
    }
  }

  // Add a product to the database
  static Future<Map<String, dynamic>> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/add_product.php"),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'name': product.name,
          'seller': product.seller,
          'price': product.price.toString(),
          'image': product.image,
          'description': product.description,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) print("Add product error: $e");
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
