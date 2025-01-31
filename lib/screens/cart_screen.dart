import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/models/product_data.dart';
import 'package:luxnewyork_flutter_app/screens/main_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProductWithQuantity> cartProducts = [
    ProductWithQuantity(
      product: products[0],
      quantity: 1,
    ),
    ProductWithQuantity(
      product: products[1],
      quantity: 1,
    ),
  ];

  // Increase Quantity
  void _increaseQuantity(int index) {
    setState(() {
      cartProducts[index].quantity++;
    });
  }

  // Decrease Quantity
  void _decreaseQuantity(int index) {
    setState(() {
      if (cartProducts[index].quantity > 1) {
        cartProducts[index].quantity--;
      }
    });
  }

  // Show Snackbar when an item is deleted
  void _showDeleteMessage(String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName deleted successfully'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Remove Item from Cart message
  void _removeItem(int index) {
    String productName = cartProducts[index].product.name;
    _showDeleteMessage(productName);
  }

  // Calculate Total Price
  double _calculateTotal() {
    double total = 0.0;
    for (var item in cartProducts) {
      total += double.parse(item.product.price.substring(1)) * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Cart Title
              Text("Your Cart", style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),

              // Display Cart Products
              ...cartProducts.map((cartItem) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      cartItem.product.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cartItem.product.name,
                        style: theme.textTheme.bodyLarge),
                    subtitle: Text(
                      '${cartItem.product.price} | Quantity: ${cartItem.quantity}',
                      style: theme.textTheme.titleMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            _decreaseQuantity(cartProducts.indexOf(cartItem));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _increaseQuantity(cartProducts.indexOf(cartItem));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeItem(cartProducts.indexOf(cartItem));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Display Total Price

              Text(
                "Total Price: \$${_calculateTotal().toStringAsFixed(2)}",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Continue Shopping and Checkout Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Continue Shopping Button
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Continue Shopping"),
                  ),

                  // Checkout Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add Checkout Logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      "Checkout",
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wrapper class to add quantity to each product
class ProductWithQuantity {
  final Product product;
  int quantity;

  ProductWithQuantity({required this.product, required this.quantity});
}
