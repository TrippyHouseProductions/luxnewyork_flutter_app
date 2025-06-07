import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOffline = false;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final offline = results.contains(ConnectivityResult.none);
      if (offline != _isOffline) {
        _isOffline = offline;
        notifyListeners();
      }
    });

    Connectivity().checkConnectivity().then((results) {
      final offline = results.contains(ConnectivityResult.none);
      if (offline != _isOffline) {
        _isOffline = offline;
        notifyListeners();
      }
    });
  }

  bool get isOffline => _isOffline;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
