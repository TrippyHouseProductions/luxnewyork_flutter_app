// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/models/product_data.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final Product product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: colorScheme.surface,
//         elevation: 0,
//         title: Text(
//           product.name,
//           style: theme.textTheme.bodyMedium,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildProductImage(),
//             _buildProductInfo(theme, colorScheme),
//             _buildProductDescription(theme),
//             _buildActionButtons(colorScheme),
//           ],
//         ),
//       ),
//     );
//   }

//   // Product Image Widget
//   Widget _buildProductImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Image.asset(
//         product.imagePath,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: 300,
//       ),
//     );
//   }

//   // Product Information
//   Widget _buildProductInfo(ThemeData theme, ColorScheme colorScheme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(product.name, style: theme.textTheme.headlineLarge),
//           const SizedBox(height: 8),
//           Text(product.category,
//               style: theme.textTheme.bodyMedium
//                   ?.copyWith(color: colorScheme.onSurfaceVariant)),
//           const SizedBox(height: 16),
//           Text(product.price,
//               style: theme.textTheme.headlineMedium
//                   ?.copyWith(color: colorScheme.primary)),
//         ],
//       ),
//     );
//   }

//   // Product Description
//   Widget _buildProductDescription(ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Product Description', style: theme.textTheme.bodyLarge),
//         const SizedBox(height: 8),
//         Text(product.description, style: theme.textTheme.bodyMedium),
//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   // Action Buttons
//   Widget _buildActionButtons(ColorScheme colorScheme) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () {
//             // TODO - Logic for add to cart
//           },
//           icon: const Icon(Icons.shopping_cart),
//           label: const Text("Add to Cart"),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: colorScheme.onPrimary,
//             backgroundColor: colorScheme.primary,
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             // TODO - Logic for add to wishkist
//           },
//           icon: const Icon(Icons.favorite_border),
//           color: colorScheme.primary,
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/models/product_data.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  // Show a Snackbar message
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          product.name,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductInfo(theme, colorScheme),
            _buildProductDescription(theme),
            _buildActionButtons(context, colorScheme),
          ],
        ),
      ),
    );
  }

  // Product Image Widget
  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        product.imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300,
      ),
    );
  }

  // Product Information
  Widget _buildProductInfo(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(product.category,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Text(product.price,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: colorScheme.primary)),
        ],
      ),
    );
  }

  // Product Description
  Widget _buildProductDescription(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Description', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text(product.description, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 30),
      ],
    );
  }

  // Action Buttons
  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Show message
            _showSnackbar(context, '${product.name} added to cart');
            // TODO - Logic for add to cart
          },
          icon: const Icon(Icons.shopping_cart),
          label: const Text("Add to Cart"),
          style: ElevatedButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: () {
            // Show message
            _showSnackbar(context, '${product.name} added to wishlist');
            // TODO - Logic for add to wishlist
          },
          icon: const Icon(Icons.favorite_border),
          color: colorScheme.primary,
        ),
      ],
    );
  }
}
