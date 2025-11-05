import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.text,
    required this.isMe,
    required this.time,
    super.key,
  });
  final String text;
  final bool isMe;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: !isMe
            ? MainAxisAlignment.start
            : MainAxisAlignment.end, // Swapped alignment
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) ...[
            const SizedBox(width: 40), // Space for balance on the right
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: !isMe
                    ? Colors.grey[300]
                    : const Color(
                        0xFF5D1A1A,
                      ), // Swapped colors to match new alignment
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: !isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                  bottomRight: !isMe
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: !isMe
                      ? Colors.black87
                      : Colors.white, // Swapped text colors
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (!isMe) ...[
            const SizedBox(width: 40), // Space for balance on the left
          ],
        ],
      ),
    );
  }
}
