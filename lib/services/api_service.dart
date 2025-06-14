import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../config.dart';

class ApiService {
  /// Base URL for API requests.
  ///
  /// This pulls the value from [apiBaseUrl] in `config.dart` so it can be
  /// easily changed in one place.
  static const String baseUrl = apiBaseUrl;

  /// NOTE fetching all the products from the api
  static Future<List<Product>> fetchProducts(
    String token, {
    int? categoryId,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    String query = 'page=$page&limit=$limit';
    if (categoryId != null) query += '&category_id=$categoryId';
    if (search != null && search.isNotEmpty) {
      query += '&search=$search';
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

  /// NOTE fetching all the categories from the api
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

  // NOTE fetch all orders for the authenticated user
  static Future<List<Order>> fetchOrders(String token) async {
    final uri = Uri.parse('$baseUrl/api/orders');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // NOTE fetch details of a single order
  static Future<Order> fetchOrderDetail(String token, int id) async {
    final uri = Uri.parse('$baseUrl/api/orders/$id');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'];
      return Order.fromJson(data);
    } else {
      throw Exception('Failed to load order details');
    }
  }

  // NOTE place a new order
  static Future<Order> placeOrder(String token, String fakeInfo) async {
    final uri = Uri.parse('$baseUrl/api/orders');

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fake_payment_info': fakeInfo}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final data = body['data'];
      return Order.fromJson(data);
    } else {
      throw Exception('Failed to place order');
    }
  }
}
