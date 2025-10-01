import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: FloatingActionButton(
        onPressed: () => context.push('/create'),
        backgroundColor: const Color(0xFF420C18), // Couleur #420C18
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
