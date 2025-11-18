import 'package:flutter/material.dart';

class GroupProfileSection extends StatelessWidget {
  const GroupProfileSection({
    required this.groupName,
    required this.groupAvatar,
    required this.memberCount,
    required this.isUserAdmin,
    this.onAvatarTap,
    super.key,
  });

  final String groupName;
  final String groupAvatar;
  final int memberCount;
  final bool isUserAdmin;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Avatar du groupe
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(groupAvatar),
              ),
              if (isUserAdmin)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: onAvatarTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5D1A1A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Nom du groupe
          Text(
            groupName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Nombre de membres
          Text(
            '$memberCount membres',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

