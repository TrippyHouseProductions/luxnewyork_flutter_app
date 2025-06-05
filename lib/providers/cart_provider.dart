import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _items = [];

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
        _items = items
            .map((item) => Product.fromJson(item['product']))
            .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Cart load error: $e');
      throw Exception('Failed to load cart');
    }
  }

  /// Add a product to the cart if it isn't already there
  void addItem(Product product) {
    if (isInCart(product.id)) return;
    _items.add(product);
    notifyListeners();
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.id == productId);
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  int get itemCount => _items.length;
}
