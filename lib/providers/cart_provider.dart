import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../models/product.dart';
import '../config.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _items = [];
  final Map<int, int> _cartItemIds = {}; // productId -> cart item id

  List<Product> get items => _items;

  /// NOTE Load cart items for the logged-in user from the API
  Future<void> loadCart() async {
    final token = await AuthService.getAuthToken();

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/cart'),
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

  /// NOTE Add a product to the cart via the API if it isn't already there
  Future<void> addItem(Product product) async {
    if (isInCart(product.id)) return;

    final token = await AuthService.getAuthToken();

    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'product_id': product.id,
        'quantity': 1, // Default quantity to 1
      }),
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
      // NOTE Log the error for debugging
      debugPrint(
          'Add to cart failed: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to add to cart');
    }
  }

  /// NOTE Check if a product is already in the cart
  /// NOTE Returns true if the product is in the cart, false otherwise.
  bool isInCart(int productId) {
    return _items.any((item) => item.id == productId);
  }

  /// NOTE Remove a product from the cart via the API
  /// NOTE If the product is not in the cart, it does nothing.
  Future<void> removeItem(int productId) async {
    final token = await AuthService.getAuthToken();

    final itemId = _cartItemIds[productId];

    if (itemId == null) {
      throw Exception('Failed to remove from cart');
    }

    final response = await http.delete(
      Uri.parse('$apiBaseUrl/api/cart/$itemId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      _items.removeWhere((item) => item.id == productId);
      _cartItemIds.remove(productId);
      notifyListeners();
    } else {
      throw Exception('Failed to remove from cart');
    }
  }

  int get itemCount => _items.length;

  /// NOTE Compute total price of items in the cart
  double get totalPrice {
    double sum = 0;
    for (final item in _items) {
      sum += double.tryParse(item.price) ?? 0;
    }
    return sum;
  }
  void clearCart() {
    _items.clear();
    _cartItemIds.clear();
    notifyListeners();
  }

  }
