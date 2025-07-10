import 'package:flutter/material.dart';

class AddFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddFloatingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF5D4037), // Retained brown color
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
      shape: const CircleBorder(), // Explicitly ensures the button is round
    );
  }
}