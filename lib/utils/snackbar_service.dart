import 'package:flutter/material.dart';

/// Global key to access the root [ScaffoldMessengerState].
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Convenience method to show a [SnackBar] using the root messenger.
void showAppSnackBar(SnackBar snackBar) {
  rootScaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
