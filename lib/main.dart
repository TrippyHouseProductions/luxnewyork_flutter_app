import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'theme/theme.dart';
import 'utils/snackbar_service.dart';

// Providers
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/product_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/order_provider.dart';
import 'providers/navigation_provider.dart';

import 'services/store_proximity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storeService = StoreProximityService();
  await storeService.init();
  await storeService.checkNearbyStores();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: const SplashScreen(), // The splash screen can decide login vs home
    );
  }
}
