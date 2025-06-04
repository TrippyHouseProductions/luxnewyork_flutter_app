import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/profile_screen.dart';
import 'package:luxnewyork_flutter_app/screens/wishlist_screen.dart';
import 'package:luxnewyork_flutter_app/screens/cart_screen.dart';
import 'package:luxnewyork_flutter_app/screens/home_screen.dart';
import 'package:luxnewyork_flutter_app/screens/my_orders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to Home

  // List of screens for navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    const WishlistScreen(),
    const CartScreen(),
    const MyOrdersScreen(),
  ];

  // Handles BottomNavigationBar item selection
  void _onItemTapped(int index) => setState(() {
        _selectedIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // ANCHOR - Use of top navigation
      appBar: AppBar(
        elevation: 0,
        title: Text("LUXNEWYORK", style: theme.textTheme.bodyMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Use IndexedStack to keep all screens alive
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      // ANCHOR - Use of bottom navigation
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
    );
  }
}
