import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../config.dart';

class WishlistProvider extends ChangeNotifier {
  List<Product> _wishlist = [];
  final Map<int, int> _wishlistItemIds = {};

  /// NOTE productId -> wishlist item id

  List<Product> get wishlist => _wishlist;

  /// NOTE Fetch wishlist from API based on logged-in user (GET)
  Future<void> loadWishlist() async {
    final token = await AuthService.getAuthToken();

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/wishlist'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['data']['items'];

        _wishlist = [];
        _wishlistItemIds.clear();
        for (final item in items) {
          final product = Product.fromJson(item['product']);
          _wishlist.add(product);
          if (item['id'] != null) {
            _wishlistItemIds[product.id] = item['id'] as int;
          }
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load wishlist: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Wishlist load error: $e');
      throw Exception('Failed to load wishlist');
    }
  }

  /// NOTE Toggle wishlist status of [product] and update backend (POST/DELETE)
  Future<void> toggleWishlist(Product product) async {
    final token = await AuthService.getAuthToken();

    final index = _wishlist.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      final itemId = _wishlistItemIds[product.id];
      if (itemId == null) {
        throw Exception('Failed to remove from wishlist');
      }

      final response = await http.delete(
        Uri.parse('$apiBaseUrl/api/wishlist/$itemId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _wishlist.removeAt(index);
        _wishlistItemIds.remove(product.id);
      } else {
        throw Exception('Failed to remove from wishlist');
      }
    } else {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/wishlist'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'product_id': product.id}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final id = data['data']['id'];
        _wishlist.add(product);
        if (id is int) {
          _wishlistItemIds[product.id] = id;
        }
      } else {
        throw Exception('Failed to add to wishlist');
      }
    }

    notifyListeners();
  }

  /// NOTE Check if a product is in the wishlist
  bool isInWishlist(int productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}
