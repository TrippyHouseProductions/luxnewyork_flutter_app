import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:luxnewyork_flutter_app/providers/cart_provider.dart';
import 'package:luxnewyork_flutter_app/providers/connectivity_provider.dart';
import 'package:luxnewyork_flutter_app/providers/wishlist_provider.dart';
import 'package:luxnewyork_flutter_app/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:luxnewyork_flutter_app/screens/cart_screen.dart';
import 'package:luxnewyork_flutter_app/screens/wishlist_screen.dart';
import 'package:luxnewyork_flutter_app/utils/snackbar_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  void _showSnackbar(BuildContext context, String message, {VoidCallback? onView}) {
    showAppSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action:
            onView == null ? null : SnackBarAction(label: 'VIEW', onPressed: onView),
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
        title: Text(product.name, style: theme.textTheme.bodyMedium),
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

  Widget _buildProductImage() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: product.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
            errorWidget: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 100),
            placeholder: (context, url) => const SizedBox(
              height: 300,
              child: Skeleton(height: 300),
            ),
          ),
        ),
        if (product.stock == 0)
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'OUT OF STOCK',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

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
          Text('UAD${product.price}',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: colorScheme.primary)),
          const SizedBox(height: 8),
          Text(
            "Stock: ${product.stock}",
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Description', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(product.description, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    final cart = context.watch<CartProvider>();
    final isOffline = context.watch<ConnectivityProvider>().isOffline;
    final isOutOfStock = product.stock == 0;
    final inCart = cart.isInCart(product.id);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: isOutOfStock || isOffline
              ? null
              : () async {
                  if (inCart) {
                    _showSnackbar(context, 'Product is already in the cart');
                  } else {
                    try {
                      await cart.addItem(product);
                      _showSnackbar(
                        context,
                        '${product.name} added to cart',
                        onView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CartScreen()),
                          );
                        },
                      );
                    } catch (_) {
                      _showSnackbar(context, 'Failed to add to cart');
                    }
                  }
                },
          icon: const Icon(Icons.shopping_cart),
          label: Text(isOutOfStock
              ? 'Out of Stock'
              : inCart
                  ? 'Added to Cart'
                  : 'Add to Cart'),
          style: ElevatedButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: isOutOfStock ? Colors.grey : colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        IconButton(
          onPressed: isOffline
              ? null
              : () async {
                  final wishlist =
                      Provider.of<WishlistProvider>(context, listen: false);
                  final isFav = wishlist.isInWishlist(product.id);
                  await wishlist.toggleWishlist(product);
                  if (isFav) {
                    _showSnackbar(
                      context,
                      '${product.name} removed from wishlist',
                    );
                  } else {
                    _showSnackbar(
                      context,
                      '${product.name} added to wishlist',
                      onView: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WishlistScreen()),
                        );
                      },
                    );
                  }
                },
          icon: Consumer<WishlistProvider>(
            builder: (_, provider, __) {
              final fav = provider.isInWishlist(product.id);
              return Icon(
                fav ? Icons.favorite : Icons.favorite_border,
                color: fav ? colorScheme.primary : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
