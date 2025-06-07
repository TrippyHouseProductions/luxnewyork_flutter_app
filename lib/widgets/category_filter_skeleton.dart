import 'package:flutter/material.dart';
import 'skeleton.dart';

class CategoryFilterSkeleton extends StatelessWidget {
  const CategoryFilterSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          child: Skeleton(
            width: 70,
            height: 20,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
