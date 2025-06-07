import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  List<Product> _wishlist = [];

  List<Product> get wishlist => _wishlist;

  // Fetch wishlist from API based on logged-in user
  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/wishlist'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['data']['items'];

        _wishlist =
            items.map((item) => Product.fromJson(item['product'])).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Wishlist load error: $e');
      throw Exception('Failed to load wishlist');
    }
  }

  void toggleWishlist(Product product) {
    final index = _wishlist.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();

    // NOTE: optionally you can send the add/remove to the API here
  }

  bool isInWishlist(int productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}
