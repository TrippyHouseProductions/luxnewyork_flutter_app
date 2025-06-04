import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // or ngrok URL

  static Future<List<Product>> fetchProducts(String token) async {
    final url = Uri.parse("$baseUrl/api/products");

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productsJson =
          jsonResponse['data']; // ✅ Correctly accessing the 'data' array

      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
