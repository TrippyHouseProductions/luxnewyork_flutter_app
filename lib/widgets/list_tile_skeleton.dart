import 'package:flutter/material.dart';
import 'skeleton.dart';

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Skeleton(width: 50, height: 50, borderRadius: BorderRadius.circular(8)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(height: 16),
                SizedBox(height: 8),
                Skeleton(height: 14, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
