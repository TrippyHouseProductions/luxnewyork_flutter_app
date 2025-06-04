import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // or ngrok URL

  // NOTE fetching all the products from the api
  // static Future<List<Product>> fetchProducts(String token,
  //     {int? categoryId}) async {
  //   final uri = Uri.parse(
  //       '$baseUrl/api/products${categoryId != null ? '?category_id=$categoryId' : ''}');

  //   final response = await http.get(
  //     uri,
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Accept': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final body = jsonDecode(response.body);
  //     final List<dynamic> data = body['data'];
  //     return data.map((json) => Product.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  static Future<List<Product>> fetchProducts(
    String token, {
    int? categoryId,
    String? search,
  }) async {
    String query = '';
    if (categoryId != null) query += 'category_id=$categoryId';
    if (search != null && search.isNotEmpty) {
      if (query.isNotEmpty) query += '&';
      query += 'search=$search';
    }

    final uri =
        Uri.parse('$baseUrl/api/products${query.isNotEmpty ? '?$query' : ''}');

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // NOTE fetching all the categories from the api
  static Future<List<Category>> fetchCategories(String token) async {
    final url = Uri.parse("$baseUrl/api/categories");

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
