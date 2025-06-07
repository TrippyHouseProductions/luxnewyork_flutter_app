import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:luxnewyork_flutter_app/providers/wishlist_provider.dart';
import 'package:luxnewyork_flutter_app/providers/connectivity_provider.dart';
import 'package:luxnewyork_flutter_app/screens/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'skeleton.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  void _showMessage(BuildContext context, String message) {
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
    final wishlist = Provider.of<WishlistProvider>(context);
    final isInWishlist = wishlist.isInWishlist(product.id);
    final isOffline =
        Provider.of<ConnectivityProvider>(context).isOffline;

    return GestureDetector(
      onTap: () {
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
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: product.imagePath.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: product.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            const Skeleton(height: double.infinity),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      )
                    : Image.asset(
                        product.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                        icon: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isInWishlist ? colorScheme.primary : null,
                        ),
                        onPressed: isOffline
                            ? null
                            : () {
                                wishlist.toggleWishlist(product);
                                _showMessage(
                                  context,
                                  isInWishlist
                                      ? '${product.name} removed from wishlist'
                                      : '${product.name} added to wishlist',
                                );
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
