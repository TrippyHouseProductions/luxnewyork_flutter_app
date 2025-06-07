// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/providers/wishlist_provider.dart';
// import 'package:luxnewyork_flutter_app/screens/profile_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/wishlist_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/cart_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/home_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/my_orders_screen.dart';
// import 'package:provider/provider.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const WishlistScreen(),
//     // TODO CartScreen(),
//     // TODO const MyOrdersScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return WillPopScope(
//       onWillPop: () async {
//         if (_selectedIndex != 0) {
//           setState(() {
//             _selectedIndex = 0;
//           });
//           return false; // Stay in app
//         }
//         return true; // Allow app to exit
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: Text("LUXNEWYORK", style: theme.textTheme.bodyMedium),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.account_circle),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ProfileScreen(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             const SizedBox(height: 10),
//             Expanded(
//               child: IndexedStack(
//                 index: _selectedIndex,
//                 children: _screens,
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: colorScheme.surface,
//           selectedItemColor: colorScheme.primary,
//           unselectedItemColor: colorScheme.onSurfaceVariant,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite), label: "Wishlist"),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.shopping_bag), label: "Cart"),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.receipt_long), label: "My Orders"),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/screens/profile_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/wishlist_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/cart_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/home_screen.dart';
// import 'package:luxnewyork_flutter_app/screens/my_orders_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:luxnewyork_flutter_app/providers/cart_provider.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   StreamSubscription<ConnectivityResult>? _connectivitySub;
//   bool _isOffline = false;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const WishlistScreen(),
//     const CartScreen(),
//     const MyOrdersScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Load cart items after the first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CartProvider>(context, listen: false).loadCart();
//     });

//     _connectivitySub = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       final offline = result == ConnectivityResult.none;
//       if (offline != _isOffline) {
//         _isOffline = offline;
//         final message = offline ? 'You are offline' : 'Back online';
//         final color = offline ? Colors.red : Colors.green;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message), backgroundColor: color),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _connectivitySub?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return WillPopScope(
//       onWillPop: () async {
//         if (_selectedIndex != 0) {
//           setState(() {
//             _selectedIndex = 0;
//           });
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: Text("LUXNEWYORK", style: theme.textTheme.bodyMedium),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.account_circle),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ProfileScreen(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: _screens,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: colorScheme.surface,
//           selectedItemColor: colorScheme.primary,
//           unselectedItemColor: colorScheme.onSurfaceVariant,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: [
//             const BottomNavigationBarItem(
//                 icon: Icon(Icons.home), label: 'Home'),
//             const BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite), label: 'Wishlist'),
//             BottomNavigationBarItem(
//               icon: Stack(
//                 children: [
//                   const Icon(Icons.shopping_bag),
//                   if (context.watch<CartProvider>().itemCount > 0)
//                     Positioned(
//                       right: 0,
//                       top: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: colorScheme.primary,
//                           shape: BoxShape.circle,
//                         ),
//                         constraints:
//                             const BoxConstraints(minWidth: 16, minHeight: 16),
//                         child: Text(
//                           '${context.watch<CartProvider>().itemCount}',
//                           style: TextStyle(
//                             color: colorScheme.onPrimary,
//                             fontSize: 10,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               label: 'Cart',
//             ),
//             const BottomNavigationBarItem(
//                 icon: Icon(Icons.receipt_long), label: 'My Orders'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/profile_screen.dart';
import 'package:luxnewyork_flutter_app/screens/wishlist_screen.dart';
import 'package:luxnewyork_flutter_app/screens/cart_screen.dart';
import 'package:luxnewyork_flutter_app/screens/home_screen.dart';
import 'package:luxnewyork_flutter_app/screens/my_orders_screen.dart';
import 'package:provider/provider.dart';
import 'package:luxnewyork_flutter_app/providers/cart_provider.dart';
import 'package:luxnewyork_flutter_app/providers/theme_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySub;
  bool _isOffline = false;
  final Battery _battery = Battery();

  final List<Widget> _screens = [
    const HomeScreen(),
    const WishlistScreen(),
    const CartScreen(),
    const MyOrdersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _checkBattery() async {
    final level = await _battery.batteryLevel;
    if (!mounted || level == -1) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.read<ThemeProvider>();

    final snackBar = SnackBar(
      content: Text(
          isDark ? 'Dark mode helps you save battery.' :
              'Enabling dark mode helps you save battery.'),
      action: isDark
          ? null
          : SnackBarAction(
              label: 'ENABLE',
              onPressed: () {
                themeProvider.setThemeMode(ThemeMode.dark);
              },
            ),
    );

    if (level < 15) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();

    // Load cart items after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCart();
      _checkBattery();
    });

    // Listen to connectivity changes (for connectivity_plus v6+)
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final offline =
          results.isEmpty || results.first == ConnectivityResult.none;

      if (offline != _isOffline) {
        setState(() {
          _isOffline = offline;
        });

        final message = offline ? 'You are offline' : 'Back online';
        final color = offline ? Colors.red : Colors.green;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: color,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("LUXNEWYORK", style: theme.textTheme.bodyMedium),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Wishlist'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_bag),
                  if (context.watch<CartProvider>().itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${context.watch<CartProvider>().itemCount}',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: 'My Orders'),
          ],
        ),
      ),
    );
  }
}
