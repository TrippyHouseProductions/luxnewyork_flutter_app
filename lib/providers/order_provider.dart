import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      _orders = await ApiService.fetchOrders(token);
    } catch (_) {
      _orders = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Order?> fetchOrderDetail(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      return await ApiService.fetchOrderDetail(token, id);
    } catch (_) {
      return null;
    }
  }
}
