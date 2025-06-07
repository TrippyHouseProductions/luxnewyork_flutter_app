// NOTE Added WishlistScreen to display products added to the wishlist using provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luxnewyork_flutter_app/providers/wishlist_provider.dart';
import 'package:luxnewyork_flutter_app/widgets/product_card.dart';
import 'package:luxnewyork_flutter_app/widgets/product_card_skeleton.dart';
import 'package:luxnewyork_flutter_app/widgets/connection_error_widget.dart';
import 'package:luxnewyork_flutter_app/providers/connectivity_provider.dart';
import 'package:luxnewyork_flutter_app/widgets/empty_state_widget.dart';
import 'main_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isLoading = true;
  String? _error;

  Future<void> _refreshWishlist() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await _loadWishlist();
  }

  void _handleConnectivityChange() {
    final offline = context.read<ConnectivityProvider>().isOffline;
    if (!offline && _error != null && !_isLoading) {
      _refreshWishlist();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWishlist();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectivityProvider>().addListener(_handleConnectivityChange);
    });
  }

  @override
  void dispose() {
    context.read<ConnectivityProvider>().removeListener(_handleConnectivityChange);
    super.dispose();
  }

  Future<void> _loadWishlist() async {
    final wishlist = Provider.of<WishlistProvider>(context, listen: false);
    try {
      await wishlist.loadWishlist();
    } catch (e) {
      setState(() => _error = 'Connection lost. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>().wishlist;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final orientation = MediaQuery.of(context).orientation;
    final crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

    Widget body;
    if (_isLoading) {
      body = Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (_, __) => const ProductCardSkeleton(),
        ),
      );
    } else if (_error != null) {
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: ConnectionErrorWidget(
              message: _error!,
              onRetry: _refreshWishlist,
            ),
          )
        ],
      );
    } else if (wishlist.isEmpty) {
      final emptyHeight = MediaQuery.of(context).size.height -
          kToolbarHeight -
          kBottomNavigationBarHeight -
          MediaQuery.of(context).padding.top;

      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: emptyHeight,
            child: EmptyStateWidget(
              message: 'Your wishlist is empty.',
              actionText: 'Browse Products',
              onAction: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              icon: Icons.favorite_border,
            ),
          )
        ],
      );
    } else {
      body = Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: wishlist.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: wishlist[index]);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: colorScheme.surface,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWishlist,
        child: body,
      ),
    );
  }
}
