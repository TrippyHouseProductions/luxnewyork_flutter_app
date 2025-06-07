import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ANCHOR widgets
import 'package:luxnewyork_flutter_app/widgets/category_filter.dart';
import 'package:luxnewyork_flutter_app/widgets/product_card.dart';
import 'package:luxnewyork_flutter_app/widgets/search_bar.dart';
import 'package:luxnewyork_flutter_app/widgets/product_card_skeleton.dart';
import 'package:luxnewyork_flutter_app/widgets/loading_widget.dart';

// ANCHOR providers
import 'package:luxnewyork_flutter_app/providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedCategoryId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadMore();
    }
  }

  Future<void> _refreshProducts() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(categoryId: _selectedCategoryId, search: _searchQuery);
  }

  void _onCategorySelected(int? categoryId) {
    _selectedCategoryId = categoryId;
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(categoryId: categoryId, search: _searchQuery);
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(categoryId: _selectedCategoryId, search: query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(onChanged: _onSearchChanged),
              _buildCategoryFilter(_onCategorySelected),
              _buildPromotionBanner(theme, colorScheme),
              const SizedBox(height: 20),
              _buildProductGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(Function(int?) onCategorySelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CategoryFilter(onCategorySelected: onCategorySelected),
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

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.products.isEmpty) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (_, __) => const ProductCardSkeleton(),
          );
        } else if (provider.products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text("No products available.")),
          );
        }

        return GridView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: provider.products.length +
              ((provider.isLoadingMore && provider.hasMore) ? 1 : 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            if (index < provider.products.length) {
              return ProductCard(product: provider.products[index]);
            } else {
              return const LoadingWidget();
            }
          },
        );
      },
    );
  }
}
