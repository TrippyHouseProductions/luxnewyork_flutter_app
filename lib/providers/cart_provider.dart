import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _items = [];
  final Map<int, int> _cartItemIds = {}; // productId -> cart item id

  List<Product> get items => _items;

  /// Load cart items for the logged-in user from the API
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/cart'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['data']['items'];
        _items = [];
        _cartItemIds.clear();
        for (final item in items) {
          final product = Product.fromJson(item['product']);
          _items.add(product);
          if (item['id'] != null) {
            _cartItemIds[product.id] = item['id'] as int;
          }
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Cart load error: $e');
      throw Exception('Failed to load cart');
    }
  }

  /// Add a product to the cart via the API if it isn't already there
  Future<void> addItem(Product product) async {
    if (isInCart(product.id)) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'product_id': product.id}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final id = data['data']['id'];
      _items.add(product);
      if (id is int) {
        _cartItemIds[product.id] = id;
      }
      notifyListeners();
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.id == productId);
  }

  Future<void> removeItem(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final itemId = _cartItemIds[productId];

    if (itemId != null) {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/cart/$itemId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to remove from cart');
      }
    }

    _items.removeWhere((item) => item.id == productId);
    _cartItemIds.remove(productId);
    notifyListeners();
  }

  int get itemCount => _items.length;

  /// Compute total price of items in the cart
  double get totalPrice {
    double sum = 0;
    for (final item in _items) {
      sum += double.tryParse(item.price) ?? 0;
    }
    return sum;
  }
}
