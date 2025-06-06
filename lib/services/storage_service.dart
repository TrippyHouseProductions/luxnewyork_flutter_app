import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class StorageService {
  static const _wishlistKey = 'wishlist_items';
  static const _cartKey = 'cart_items';
  static const _productCacheKey = 'cached_products';

  static Future<void> saveWishlist(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_wishlistKey, encoded);
  }

  static Future<List<Product>> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_wishlistKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((json) => Product.fromJson(json)).toList();
  }

  static Future<void> saveCart(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_cartKey, encoded);
  }

  static Future<List<Product>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cartKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((json) => Product.fromJson(json)).toList();
  }

  /// Save fetched products locally so they can be displayed when offline.
  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_productCacheKey, encoded);
  }

  /// Load previously cached products. Returns an empty list if nothing saved.
  static Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_productCacheKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((json) => Product.fromJson(json)).toList();
  }
}
