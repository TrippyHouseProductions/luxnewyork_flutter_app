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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Skeleton(
              height: double.infinity,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
