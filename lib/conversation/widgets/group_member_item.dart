import 'package:flutter/material.dart';
import 'package:yansnet/conversation/models/group_member.dart';

class GroupMemberItem extends StatelessWidget {
  const GroupMemberItem({
    required this.member,
    required this.isUserAdmin,
    required this.isMainAdmin,
    required this.currentUserId,
    this.onPromoteToAdmin,
    this.onRevokeAdminRights,
    this.onRemoveMember,
    super.key,
  });

  final GroupMember member;
  final bool isUserAdmin;
  final bool isMainAdmin;
  final String currentUserId;
  final VoidCallback? onPromoteToAdmin;
  final VoidCallback? onRevokeAdminRights;
  final VoidCallback? onRemoveMember;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(member.avatarUrl),
              ),
              if (member.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    if (member.isAdmin) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5D1A1A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (member.isOnline)
                  Text(
                    'En ligne',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          // Menu contextuel pour les admins
          if (isUserAdmin && member.id != currentUserId)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                if (value == 'make_admin' && onPromoteToAdmin != null) {
                  onPromoteToAdmin!();
                } else if (value == 'remove_admin' && onRevokeAdminRights != null) {
                  onRevokeAdminRights!();
                } else if (value == 'remove' && onRemoveMember != null) {
                  onRemoveMember!();
                }
              },
              itemBuilder: (context) {
                final items = <PopupMenuItem<String>>[];

                // Si c'est un membre normal, on peut le promouvoir
                if (!member.isAdmin) {
                  items.add(
                    const PopupMenuItem(
                      value: 'make_admin',
                      child: Text('Promouvoir admin'),
                    ),
                  );
                }

                // Si c'est un admin et que l'utilisateur est l'admin principal, on peut révoquer ses droits
                if (member.isAdmin && isMainAdmin) {
                  items.add(
                    const PopupMenuItem(
                      value: 'remove_admin',
                      child: Text('Révoquer les droits d\'admin'),
                    ),
                  );
                }

                // On peut toujours retirer un membre (sauf soi-même)
                items.add(
                  const PopupMenuItem(
                    value: 'remove',
                    child: Text('Retirer du groupe'),
                  ),
                );

                return items;
              },
            ),
        ],
      ),
    );
  }
}

