import 'package:flutter/material.dart';
// NOTE before loading products from the api this was used to load demo product data
// import 'package:luxnewyork_flutter_app/models/product_data.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:luxnewyork_flutter_app/screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  // Show a Snackbar message
  void _showAddToWishlistMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to wishlist'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        // Navigate to the Product Detail Screen when the product is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (using Expanded to take available space)
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image(
                  image: product.imagePath.startsWith('http')
                      ? NetworkImage(product.imagePath)
                      : AssetImage(product.imagePath) as ImageProvider,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Product Details (Pushed to the bottom of card)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: theme.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Product Category
                  Text(
                    product.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Price & Wishlist Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          _showAddToWishlistMessage(context);
                          //TODO - Add product add to wishlist logic
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
