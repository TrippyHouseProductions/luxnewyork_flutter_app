// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/widgets/category_filter.dart';
// import 'package:luxnewyork_flutter_app/widgets/product_card.dart';
// import 'package:luxnewyork_flutter_app/models/product_data.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSearchBar(colorScheme),
//             _buildCategoryFilter(),
//             _buildPromotionBanner(theme, colorScheme),
//             const SizedBox(height: 20),
//             _buildProductGrid(context),
//           ],
//         ),
//       ),
//     );
//   }

//   // Search Bar
//   Widget _buildSearchBar(ColorScheme colorScheme) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, bottom: 16),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search",
//           filled: true,
//           fillColor: colorScheme.surfaceContainerHighest,
//           prefixIcon: const Icon(Icons.search),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
//         ),
//       ),
//     );
//   }

//   // Category Filters
//   Widget _buildCategoryFilter() {
//     return const Padding(
//       padding: EdgeInsets.only(bottom: 16),
//       child: CategoryFilter(),
//     );
//   }

//   // Promotion Banner
//   Widget _buildPromotionBanner(ThemeData theme, ColorScheme colorScheme) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: colorScheme.primary,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               "20% discount on new season sunglasses",
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: colorScheme.onPrimary,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: Text("Shop Now »",
//                 style: TextStyle(color: colorScheme.onPrimary)),
//           ),
//         ],
//       ),
//     );
//   }

//   // ANCHOR - Use of scrolable list
//   // Widget _buildProductGrid(BuildContext context) {
//   //   return GridView.builder(
//   //     shrinkWrap: true,
//   //     physics: const BouncingScrollPhysics(), // Adds smooth scrolling effect
//   //     itemCount: products.length,
//   //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //       crossAxisCount: 2,
//   //       crossAxisSpacing: 10,
//   //       mainAxisSpacing: 10,
//   //       childAspectRatio: 0.6,
//   //     ),
//   //     itemBuilder: (context, index) {
//   //       return ProductCard(product: products[index]);
//   //     },
//   //   );
//   // }
//   Widget _buildProductGrid(BuildContext context) {
//     // Determine current orientation
//     Orientation orientation = MediaQuery.of(context).orientation;

//     // Set crossAxisCount based on orientation
//     int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const BouncingScrollPhysics(),
//       itemCount: products.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 0.6,
//       ),
//       itemBuilder: (context, index) {
//         return ProductCard(product: products[index]);
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luxnewyork_flutter_app/widgets/category_filter.dart';
import 'package:luxnewyork_flutter_app/widgets/product_card.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:luxnewyork_flutter_app/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return ApiService.fetchProducts(token);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(colorScheme),
            _buildCategoryFilter(),
            _buildPromotionBanner(theme, colorScheme),
            const SizedBox(height: 20),
            _buildProductGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: CategoryFilter(),
    );
  }

  Widget _buildPromotionBanner(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "20% discount on new season sunglasses",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Shop Now »",
                style: TextStyle(color: colorScheme.onPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

    return FutureBuilder<List<Product>>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text("No products available.")),
          );
        }

        final products = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}
