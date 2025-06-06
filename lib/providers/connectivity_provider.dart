// <<<<<<< a7cyhf-codex/add-no-internet-message-with-retry-button
// import 'dart:io';

// =======
// >>>>>>> main
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    _isOnline = await _checkConnection();
    notifyListeners();
    _connectivity.onConnectivityChanged.listen((result) async {
      final wasOnline = _isOnline;
// <<<<<<< a7cyhf-codex/add-no-internet-message-with-retry-button
//       _isOnline = await _verifyInternet(result);
// =======
//       _isOnline = result != ConnectivityResult.none;
// >>>>>>> main
      if (wasOnline != _isOnline) {
        notifyListeners();
      }
    });
  }

  Future<bool> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
// <<<<<<< a7cyhf-codex/add-no-internet-message-with-retry-button
//     return _verifyInternet(result);
//   }

//   Future<bool> _verifyInternet(ConnectivityResult result) async {
//     if (result == ConnectivityResult.none) return false;
//     try {
//       final lookup = await InternetAddress.lookup('example.com');
//       return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
//     } on SocketException {
//       return false;
//     }
// =======
//     return result != ConnectivityResult.none;
// >>>>>>> main
  }

  Future<void> retry() async {
    _isOnline = await _checkConnection();
    notifyListeners();
  }
}
