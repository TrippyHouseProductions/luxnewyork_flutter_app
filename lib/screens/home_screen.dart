import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/widgets/category_filter.dart';
import 'package:luxnewyork_flutter_app/widgets/product_card.dart';
import 'package:luxnewyork_flutter_app/models/product_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  // Search Bar
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

  // Category Filters
  Widget _buildCategoryFilter() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: CategoryFilter(),
    );
  }

  // Promotion Banner
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

  // Product Grid - //ANCHOR - Use of scrolable list
  Widget _buildProductGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
