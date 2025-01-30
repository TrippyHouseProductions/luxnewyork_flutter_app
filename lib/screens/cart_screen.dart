import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/main_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Empty Cart Message
          Text("Your Cart is Empty!",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20), // Spacing

          // Continue Shopping Button
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            ),
            child: const Text("Continue Shopping"),
          ),
        ],
      ),
    );
  }
}
