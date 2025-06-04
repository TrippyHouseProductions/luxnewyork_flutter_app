import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

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
  }
}
