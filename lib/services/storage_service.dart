import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/category.dart';

class StorageService {
  static const _wishlistKey = 'wishlist_items';
  static const _cartKey = 'cart_items';
  static const _productCacheKey = 'cached_products';
  static const _categoryCacheKey = 'cached_categories';

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

  /// Save fetched categories locally so they can be used when offline.
  static Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(categories
        .map((c) => {
              'id': c.id,
              'name': c.name,
            })
        .toList());
    await prefs.setString(_categoryCacheKey, encoded);
  }

  /// Load previously cached products. Returns an empty list if nothing saved.
  static Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_productCacheKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded.map((json) => Product.fromJson(json)).toList();
  }

  /// Load previously cached categories. Returns an empty list if nothing saved.
  static Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_categoryCacheKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List;
    return decoded
        .map((json) => Category.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
