import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userAvatar;
  final String lastSeen;
  final VoidCallback onBackPressed;
  final VoidCallback onCallPressed;
  final VoidCallback onVideoCallPressed;
  final VoidCallback onMorePressed;

  const ChatHeader({
    Key? key,
    required this.userName,
    required this.userAvatar,
    required this.lastSeen,
    required this.onBackPressed,
    required this.onCallPressed,
    required this.onVideoCallPressed,
    required this.onMorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 16,
          ),
        ),
        onPressed: onBackPressed,
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(userAvatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  lastSeen,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.call,
            color: Colors.black87,
          ),
          onPressed: onCallPressed,
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam,
            color: Colors.black87,
          ),
          onPressed: onVideoCallPressed,
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black87,
          ),
          onPressed: onMorePressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}