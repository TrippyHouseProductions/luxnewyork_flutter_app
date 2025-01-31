import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/models/product_data.dart';
import 'package:luxnewyork_flutter_app/screens/main_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get the first 2 products for now (demo purpose)
    final List<Product> wishlistProducts = products.take(2).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Wishlist Title
              Text("My Wishlist", style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),

              // Display Wishlist Products
              if (wishlistProducts.isNotEmpty)
                ...wishlistProducts.map((product) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        product.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        product.name,
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        product.price,
                        style: theme.textTheme.titleMedium,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // TODO: Logic to remove Item from Wishlist
                        },
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 20),

              // Continue Shopping Button
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Continue Shopping"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
