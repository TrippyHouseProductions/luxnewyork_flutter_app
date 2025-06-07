import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/list_tile_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/skeleton.dart';
import '../widgets/connection_error_widget.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/empty_state_widget.dart';
import 'main_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  String? _error;

  Future<void> _refreshCart() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await _loadCart();
  }

  void _handleConnectivityChange() {
    final offline = context.read<ConnectivityProvider>().isOffline;
    if (!offline && _error != null && !_isLoading) {
      _refreshCart();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCart();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ConnectivityProvider>()
          .addListener(_handleConnectivityChange);
    });
  }

  @override
  void dispose() {
    context
        .read<ConnectivityProvider>()
        .removeListener(_handleConnectivityChange);
    super.dispose();
  }

  Future<void> _loadCart() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    try {
      await cart.loadCart();
    } catch (e) {
      setState(() => _error = 'Connection lost. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget body;
    if (_isLoading) {
      body = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (_, __) => const ListTileSkeleton(),
      );
    } else if (_error != null) {
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: ConnectionErrorWidget(
              message: _error!,
              onRetry: _refreshCart,
            ),
          )
        ],
      );
    } else if (items.isEmpty) {
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: EmptyStateWidget(
              message: 'Your cart is empty.',
              actionText: 'Shop Now',
              onAction: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              icon: Icons.shopping_bag_outlined,
            ),
          )
        ],
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: product.imagePath.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: product.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Skeleton(
                          width: 50,
                          height: 50,
                          borderRadius: BorderRadius.circular(8)),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    )
                  : Image.asset(
                      product.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
              title: Text(product.name),
              subtitle: Text(product.price),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await cartProvider.removeItem(product.id);
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to remove item')),
                    );
                  }
                },
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: colorScheme.surface,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCart,
        child: body,
      ),
      bottomNavigationBar: !_isLoading && items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
