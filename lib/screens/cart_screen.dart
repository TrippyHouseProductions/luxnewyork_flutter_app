import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/list_tile_skeleton.dart';

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

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    try {
      await cart.loadCart();
    } catch (e) {
      setState(() => _error = 'Failed to load cart');
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
            child: Center(child: Text(_error!)),
          )
        ],
      );
    } else if (items.isEmpty) {
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 300,
            child: Center(child: Text('Your cart is empty.')),
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
              leading: Image(
                image: product.imagePath.startsWith('http')
                    ? NetworkImage(product.imagePath)
                    : AssetImage(product.imagePath) as ImageProvider,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product.name),
              subtitle: Text(product.price),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => cartProvider.removeItem(product.id),
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
