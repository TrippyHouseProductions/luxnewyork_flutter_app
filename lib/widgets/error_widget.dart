import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(child: Text(message)),
    );
  }
}
