import 'package:flutter/material.dart';

class AddFloatingButton extends StatelessWidget {
  const AddFloatingButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF5D4037),
      shape: const CircleBorder(), // Retained brown color
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ), // Explicitly ensures the button is round
    );
  }
}
