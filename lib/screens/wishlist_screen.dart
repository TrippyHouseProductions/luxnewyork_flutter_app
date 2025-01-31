// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/screens/main_screen.dart';

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Empty Wishlist Message
//           Text("Your Wishlist is Empty!",
//               style: Theme.of(context).textTheme.bodyMedium),
//           const SizedBox(height: 20), // Spacing

//           // Continue Shopping Button
//           ElevatedButton(
//             onPressed: () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const MainScreen()),
//             ),
//             child: const Text("Continue Shopping"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/main_screen.dart';
import 'package:luxnewyork_flutter_app/models/product_data.dart'; // Import your product data

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the first 2 products from the products list
    final List<Product> wishlistProducts = products.take(2).toList();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Wishlist Title
          Text("Your Wishlist", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20), // Spacing

          // If Wishlist is empty, show message
          if (wishlistProducts.isEmpty)
            Text("Your Wishlist is Empty!",
                style: Theme.of(context).textTheme.bodyMedium),

          // Display Demo Products (if there are products in the wishlist)
          if (wishlistProducts.isNotEmpty)
            ...wishlistProducts.map((product) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Image.asset(
                    product.imagePath, // Load product image
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    product.price,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      //TODO - Logic to remove Item
                    },
                  ),
                ),
              );
            }).toList(),

          // Continue Shopping Button
          const SizedBox(height: 20),
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
