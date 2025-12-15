// lib/conversation/views/groups_list_page.dart
import 'package:flutter/material.dart';
import 'group_chat_page.dart';

class GroupsListPage extends StatelessWidget {
  const GroupsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Données mockées des groupes
    final List<Map<String, dynamic>> groups = [
      {
        'groupAvatar': 'https://i.pravatar.cc/150?img=10',
        'groupName': 'Famille 👨‍👩‍👧‍👦',
        'lastMessage': 'Papa: On se voit ce weekend ?',
        'lastMessageTime': '14:30',
        'unreadCount': 5,
        'memberCount': 8,
      },
      {
        'groupAvatar': 'https://i.pravatar.cc/150?img=11',
        'groupName': 'Équipe Dev 💻',
        'lastMessage': 'Marie: Le bug est corrigé !',
        'lastMessageTime': '12:15',
        'unreadCount': 12,
        'memberCount': 15,
      },
      {
        'groupAvatar': 'https://i.pravatar.cc/150?img=12',
        'groupName': 'Amis du lycée 🎓',
        'lastMessage': 'Jean: Qui vient à la réunion ?',
        'lastMessageTime': 'Hier',
        'unreadCount': 0,
        'memberCount': 25,
      },
      {
        'groupAvatar': 'https://i.pravatar.cc/150?img=13',
        'groupName': 'Club de lecture 📚',
        'lastMessage': 'Sophie: J\'ai adoré ce livre !',
        'lastMessageTime': 'Lun',
        'unreadCount': 3,
        'memberCount': 12,
      },
      {
        'groupAvatar': 'https://i.pravatar.cc/150?img=14',
        'groupName': 'Voisins 🏘️',
        'lastMessage': 'Marc: Quelqu\'un a vu mon chat ?',
        'lastMessageTime': 'Mar',
        'unreadCount': 0,
        'memberCount': 20,
      },
      {
        'groupAvatar': 'https://i.pravatar.cc/150?img=15',
        'groupName': 'Projet ETSIA 🎓',
        'lastMessage': 'Réunion demain à 10h',
        'lastMessageTime': '16:45',
        'unreadCount': 8,
        'memberCount': 18,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Groupes',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Action recherche
            },
          ),
        ],
      ),
      body: groups.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun groupe',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return GroupListItem(
            groupAvatar: group['groupAvatar'] as String,
            groupName: group['groupName'] as String,
            lastMessage: group['lastMessage'] as String,
            lastMessageTime: group['lastMessageTime'] as String,
            unreadCount: group['unreadCount'] as int,
            memberCount: group['memberCount'] as int,
            onTap: () {
              // Navigation vers la page de discussion du groupe
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChatPage(
                    groupName: group['groupName'] as String,
                    groupAvatar: group['groupAvatar'] as String,
                    memberCount: group['memberCount'] as int,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour créer un nouveau groupe
        },
        backgroundColor: const Color(0xFF5D1A1A),
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Widget pour chaque item de la liste des groupes
class GroupListItem extends StatelessWidget {
  final String groupAvatar;
  final String groupName;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final int memberCount;
  final VoidCallback onTap;

  const GroupListItem({
    Key? key,
    required this.groupAvatar,
    required this.groupName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.memberCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            // Avatar du groupe avec badge
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(groupAvatar),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D1A1A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.groups,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Informations du groupe
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          groupName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        lastMessageTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: unreadCount > 0
                              ? const Color(0xFF5D1A1A)
                              : Colors.grey[600],
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5D1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$memberCount membres',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}