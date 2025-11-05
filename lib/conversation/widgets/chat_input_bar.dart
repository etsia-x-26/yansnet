import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    required this.controller,
    required this.hintText,
    required this.onEmojiPressed,
    required this.onAddPressed,
    required this.onMicPressed,
    required this.onSendPressed,
    required this.hasText,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onEmojiPressed;
  final VoidCallback onAddPressed;
  final VoidCallback onMicPressed;
  final void Function(String) onSendPressed;
  final bool hasText;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(
          color: borderColor ?? Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            onPressed: onEmojiPressed,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              onSubmitted: onSendPressed, // Send when Enter is pressed
            ),
          ),
          IconButton(icon: const Icon(Icons.add), onPressed: onAddPressed),
          if (hasText) ...[
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => onSendPressed(controller.text),
            ),
          ] else
            IconButton(icon: const Icon(Icons.mic), onPressed: onMicPressed),
        ],
      ),
    );
  }
}
