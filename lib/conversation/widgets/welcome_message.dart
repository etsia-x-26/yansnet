import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  final String message;

  const WelcomeMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}