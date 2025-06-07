import 'package:flutter/material.dart';
import '../models/about_item.dart';
import '../services/external_json_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<List<AboutItem>> _loadItems() async {
    return ExternalJsonService.fetchAboutItems();
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
