import 'package:flutter/material.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  final List<String> _categories = [
    "All",
    "New Season",
    "Popular",
    "Men's",
    "Women's",
    "Signature Glasses"
  ];

  int _selectedIndex = 0; // Tracks selected category

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 50, // fixed height
      //ANCHOR - Use of scrollable list
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // scrollable
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index; // Updates selected category
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                _categories[index],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: _selectedIndex == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedIndex == index
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
