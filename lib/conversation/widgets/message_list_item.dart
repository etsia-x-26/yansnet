import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageListItem extends StatelessWidget {
  const MessageListItem({
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.isGroup,
    this.unreadCount = 0,
    this.memberCount = 0,
    this.isOnline = false,
    super.key,
  });

  final String avatarUrl;
  final String name;
  final String lastMessage;
  final int unreadCount;
  final int? memberCount;
  final bool isGroup;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;
    final unreadCountText = unreadCount.toString();

    return GestureDetector(
      onTap: () {
        context.push(
          '/chat/$name',
          extra: {
            'userAvatar': avatarUrl,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isGroup) {
                      context.push(
                        '/group/$name',
                        extra: {
                          'groupAvatar': avatarUrl,
                          'memberCount': memberCount,
                        },
                      );
                    } else {
                      context.push(
                        '/profile/$name',
                        extra: {
                          'groupAvatar': avatarUrl,
                          'memberCount': memberCount,
                        },
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ListTile(
                title: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  lastMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: hasUnread
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 189, 25, 25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            unreadCountText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
