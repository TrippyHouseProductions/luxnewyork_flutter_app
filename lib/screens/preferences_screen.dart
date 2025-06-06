import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Preferences', style: textTheme.headlineSmall)),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                context.read<ThemeProvider>().setThemeMode(mode);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark Mode'),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                context.read<ThemeProvider>().setThemeMode(mode);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                context.read<ThemeProvider>().setThemeMode(mode);
              }
            },
          ),
        ],
      ),
    );
  }
}
