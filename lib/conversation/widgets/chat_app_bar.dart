import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback onCallPressed;
  final VoidCallback onVideoPressed;
  final VoidCallback onMorePressed;
  final VoidCallback onBackPressed;

  const ChatAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onCallPressed,
    required this.onVideoPressed,
    required this.onMorePressed,
    required this.onBackPressed, required Color backgroundColor, required int elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed,
      ),
      title: Row(
        children: [
          // Avatar de groupe
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.people,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Colors.black),
          onPressed: onCallPressed,
        ),
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.black),
          onPressed: onVideoPressed,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: onMorePressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}