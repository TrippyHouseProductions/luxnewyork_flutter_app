import 'package:flutter/material.dart';

class PromotionBannerWidget extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const PromotionBannerWidget({
    super.key,
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: onAction,
            child: Text(actionText,
                style: TextStyle(color: colorScheme.onPrimary)),
          ),
        ],
      ),
    );
  }
}
