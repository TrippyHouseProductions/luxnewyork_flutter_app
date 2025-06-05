// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/models/product_data.dart';
// import 'package:luxnewyork_flutter_app/screens/main_screen.dart';

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({super.key});

//   // Show delete message
//   void _showDeleteMessage(BuildContext context, String productName) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$productName deleted successfully'),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // Get the first 2 products
//     final List<Product> wishlistProducts = products.take(2).toList();

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               // Wishlist Title
//               Text("My Wishlist", style: theme.textTheme.titleLarge),
//               const SizedBox(height: 20),

//               // Display Wishlist Products
//               if (wishlistProducts.isNotEmpty)
//                 ...wishlistProducts.map((product) {
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: ListTile(
//                       leading: Image.asset(
//                         product.imagePath,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       ),
//                       title: Text(
//                         product.name,
//                         style: theme.textTheme.bodyLarge,
//                       ),
//                       subtitle: Text(
//                         product.price,
//                         style: theme.textTheme.titleMedium,
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () {
//                           // Show message
//                           _showDeleteMessage(context, product.name);
//                           //TODO - Add delete product logic
//                         },
//                       ),
//                     ),
//                   );
//                 }),

//               const SizedBox(height: 20),

//               // Continue Shopping Button
//               ElevatedButton(
//                 onPressed: () => Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MainScreen()),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//                 child: const Text("Continue Shopping"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final wishlist =
        Provider.of<WishlistProvider>(context, listen: false);
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
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(child: Text(_error!));
    } else if (wishlist.isEmpty) {
      body = const Center(
        child: Text(
          "Your wishlist is empty.",
          style: TextStyle(fontSize: 16),
        ),
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
      body: body,
    );
  }
}
