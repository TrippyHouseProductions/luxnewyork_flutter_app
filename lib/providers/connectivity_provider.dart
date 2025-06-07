import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOffline = false;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  /// NOTE Creates a [ConnectivityProvider] that listens to connectivity changes.
  /// NOTE It uses [ConnectivityPlus] to monitor network status.
  /// NOTE The [isOffline] property indicates whether the device is offline.
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

    // NOTE Initial check to set the initial state
    Connectivity().checkConnectivity().then((results) {
      final offline = results.contains(ConnectivityResult.none);
      if (offline != _isOffline) {
        _isOffline = offline;
        notifyListeners();
      }
    });
  }

  bool get isOffline => _isOffline;

  /// NOTE Disposes the [ConnectivityProvider] and cancels the subscription.
  /// NOTE This should be called when the provider is no longer needed.
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
