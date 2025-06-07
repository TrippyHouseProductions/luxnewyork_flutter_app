import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AboutItem {
  final String title;
  final String description;

  AboutItem({required this.title, required this.description});

  factory AboutItem.fromJson(Map<String, dynamic> json) {
    return AboutItem(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<List<AboutItem>> _loadItems() async {
    final data = await rootBundle.loadString('assets/data/about_items.json');
    final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
    return jsonList
        .map((item) => AboutItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('About', style: textTheme.headlineSmall)),
      body: FutureBuilder<List<AboutItem>>(
        future: _loadItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error: \${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title, style: textTheme.bodyLarge),
                subtitle: Text(item.description, style: textTheme.bodyMedium),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
          );
        },
      ),
    );
  }
}
