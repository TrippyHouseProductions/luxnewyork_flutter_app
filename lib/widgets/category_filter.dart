// import 'package:flutter/material.dart';

// class CategoryFilter extends StatefulWidget {
//   const CategoryFilter({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CategoryFilterState createState() => _CategoryFilterState();
// }

// class _CategoryFilterState extends State<CategoryFilter> {
//   final List<String> _categories = [
//     "All",
//     "New Season",
//     "Popular",
//     "Men's",
//     "Women's",
//     "Signature Glasses"
//   ];

//   int _selectedIndex = 0; // Tracks selected category

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return SizedBox(
//       height: 50, // fixed height
//       //ANCHOR - Use of scrollable list
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal, // scrollable
//         physics: const BouncingScrollPhysics(), // Adds smooth scrolling effect
//         itemCount: _categories.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedIndex = index; // Updates selected category
//               });
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               margin: const EdgeInsets.symmetric(horizontal: 6),
//               child: Text(
//                 _categories[index],
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight: _selectedIndex == index
//                       ? FontWeight.bold
//                       : FontWeight.normal,
//                   color: _selectedIndex == index
//                       ? theme.colorScheme.primary
//                       : theme.colorScheme.onSurfaceVariant,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'category_filter_skeleton.dart';

class CategoryFilter extends StatefulWidget {
  final Function(int? categoryId)? onCategorySelected;

  const CategoryFilter({super.key, this.onCategorySelected});

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  List<Category> _categories = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      final cached = await StorageService.loadCategories();
      setState(() {
        _categories = [Category(id: 0, name: 'All'), ...cached];
      });
      return;
    }

    try {
      final loaded = await ApiService.fetchCategories(token);
      await StorageService.saveCategories(loaded);
      setState(() {
        _categories = [Category(id: 0, name: 'All'), ...loaded];
      });
    } catch (_) {
      final cached = await StorageService.loadCategories();
      if (cached.isNotEmpty) {
        setState(() {
          _categories = [Category(id: 0, name: 'All'), ...cached];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 50,
      child: _categories.isEmpty
          ? const CategoryFilterSkeleton()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    final selectedCategoryId = _categories[index].id;
                    if (widget.onCategorySelected != null) {
                      widget.onCategorySelected!(
                          selectedCategoryId == 0 ? null : selectedCategoryId);
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      _categories[index].name,
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
