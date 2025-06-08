import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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

    final token = await AuthService.getAuthToken();

    try {
      _orders = await ApiService.fetchOrders(token);
    } catch (_) {
      _orders = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Order?> fetchOrderDetail(int id) async {
    final token = await AuthService.getAuthToken();

    try {
      return await ApiService.fetchOrderDetail(token, id);
    } catch (_) {
      return null;
    }
  }

  Future<Order?> placeOrder(String fakeInfo) async {
    final token = await AuthService.getAuthToken();

    try {
      final order = await ApiService.placeOrder(token, fakeInfo);
      return order;
    } catch (_) {
      return null;
    }
  }
}
