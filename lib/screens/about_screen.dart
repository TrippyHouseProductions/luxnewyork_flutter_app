import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('About', style: textTheme.headlineSmall)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'LUXNEWYORK is a conceptual luxury eyewear company built for learning.',
          style: textTheme.bodyMedium,
        ),
      ),
    );
  }
}
