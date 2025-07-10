import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onEmojiPressed;
  final VoidCallback onAddPressed;
  final VoidCallback onMicPressed;
  final VoidCallback onSendPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;

  const ChatInputBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onEmojiPressed,
    required this.onAddPressed,
    required this.onMicPressed,
    required this.onSendPressed,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(color: borderColor ?? Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.emoji_emotions), onPressed: onEmojiPressed),
          Expanded(child: TextField(controller: controller, decoration: InputDecoration(hintText: hintText))),
          IconButton(icon: const Icon(Icons.add), onPressed: onAddPressed),
          IconButton(icon: const Icon(Icons.mic), onPressed: onMicPressed),
          IconButton(icon: const Icon(Icons.send), onPressed: onSendPressed),
        ],
      ),
    );
  }
}