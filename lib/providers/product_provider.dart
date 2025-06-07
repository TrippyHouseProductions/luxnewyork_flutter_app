import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ProductProvider extends ChangeNotifier {
  final int _perPage = 10;
  List<Product> _products = [];
  int _page = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int? _categoryId;
  String _searchQuery = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts({int? categoryId, String search = ''}) async {
    _page = 1;
    _hasMore = true;
    _products = [];
    _categoryId = categoryId;
    _searchQuery = search;
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _products = await StorageService.loadProducts();
      _isLoading = false;
      _hasMore = false;
      notifyListeners();
      return;
    }

    try {
      final fetched = await ApiService.fetchProducts(
        token,
        categoryId: categoryId,
        search: search,
        page: _page,
        limit: _perPage,
      );
      _products = fetched;
      if (fetched.length < _perPage) _hasMore = false;
      await StorageService.saveProducts(_products);
    } catch (_) {
      final cached = await StorageService.loadProducts();
      _products = cached;
      _hasMore = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();
    _page++;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    try {
      final fetched = await ApiService.fetchProducts(
        token,
        categoryId: _categoryId,
        search: _searchQuery,
        page: _page,
        limit: _perPage,
      );
      _products.addAll(fetched);
      if (fetched.length < _perPage) _hasMore = false;
    } catch (_) {
      _hasMore = false;
    }
    _isLoadingMore = false;
    notifyListeners();
  }
}
