import 'package:flutter/material.dart';
import 'skeleton.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Skeleton(
              height: double.infinity,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(height: 16),
                SizedBox(height: 4),
                Skeleton(height: 14, width: 80),
                SizedBox(height: 4),
                Skeleton(height: 16, width: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
