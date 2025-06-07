// NOTE Added WishlistScreen to display products added to the wishlist using provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luxnewyork_flutter_app/providers/wishlist_provider.dart';
import 'package:luxnewyork_flutter_app/widgets/product_card.dart';

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

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final wishlist = Provider.of<WishlistProvider>(context, listen: false);
    try {
      await wishlist.loadWishlist();
    } catch (e) {
      setState(() => _error = 'Failed to load wishlist');
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
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          )
        ],
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
    } else if (wishlist.isEmpty) {
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 300,
            child: Center(
              child: Text(
                "Your wishlist is empty.",
                style: TextStyle(fontSize: 16),
              ),
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
