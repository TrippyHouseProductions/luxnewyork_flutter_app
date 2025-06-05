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

import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/profile_screen.dart';
import 'package:luxnewyork_flutter_app/screens/wishlist_screen.dart';
import 'package:luxnewyork_flutter_app/screens/cart_screen.dart';
import 'package:luxnewyork_flutter_app/screens/home_screen.dart';
import 'package:luxnewyork_flutter_app/screens/my_orders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WishlistScreen(),
    // const CartScreen(),
    // const MyOrdersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Wishlist"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: "My Orders"),
          ],
        ),
      ),
    );
  }
}
