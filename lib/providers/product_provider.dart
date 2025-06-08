import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/auth_service.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// NOTE ProductProvider is a ChangeNotifier that manages the state of products.
/// NOTE It fetches products from the API, supports pagination, and handles offline storage.
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

  // NOTE Fetches products from the API or local storage based on the provided category ID and search query.
  // NOTE Resets the pagination and clears the product list before fetching.
  Future<void> fetchProducts({int? categoryId, String search = ''}) async {
    _page = 1;
    _hasMore = true;
    _products = [];
    _categoryId = categoryId;
    _searchQuery = search;
    _isLoading = true;
    notifyListeners();

    final token = await AuthService.getAuthToken();

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _products = await StorageService
          .loadProducts(); // NOTE Load from local storage if offline
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
      await StorageService.saveProducts(
          _products); // NOTE Save fetched products to local storage
    } catch (_) {
      final cached = await StorageService
          .loadProducts(); // NOTE Load from local storage if API fails
      _products = cached;
      _hasMore = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// NOTE Loads more products for pagination.
  /// NOTE It checks if there are more products to load and if a loading operation is already in progress.
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();
    _page++;

    final token = await AuthService.getAuthToken();
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
