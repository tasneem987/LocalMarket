import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // ✅ AwardSpace backend (NOT localhost)
  static const String baseUrl =
      'http://tasneemchaheen.atwebpages.com';

  // ---------- LOGIN ----------
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }

    return jsonDecode(response.body);
  }

  // ---------- GET PRODUCTS ----------
  static Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_products.php'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products');
    }

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      return (data['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch products');
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    return jsonDecode(response.body);
  }


}
