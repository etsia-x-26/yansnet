import 'package:flutter/material.dart';
import 'package:yansnet/conversation/models/message_filter.dart' as model;
import 'package:yansnet/conversation/widgets/message_list_item.dart';
import 'package:yansnet/conversation/widgets/message_filter_tabs.dart';

class MessagesListPage extends StatefulWidget {
  const MessagesListPage({Key? key}) : super(key: key);

  @override
  State<MessagesListPage> createState() => _MessagesListPageState();
}

class _MessagesListPageState extends State<MessagesListPage> {
  model.MessageFilter _selectedFilter = model.MessageFilter.all;

  // Données mockées pour démonstration
  final List<Map<String, dynamic>> _allMessages = [
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'name': 'Emmy',
      'lastMessage': 'Bonjour, j\'espère que tu vas bien',
      'isOnline': true,
      'hasUnread': false,
      'isFavorite': true,
      'isGroup': false,
      'unreadCount': 0,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=2',
      'name': 'Pixsie',
      'lastMessage': '• •',
      'isOnline': false,
      'hasUnread': true,
      'isFavorite': false,
      'isGroup': false,
      'unreadCount': 150,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=3',
      'name': 'Victoire',
      'lastMessage': 'Hey !',
      'isOnline': true,
      'hasUnread': false,
      'isFavorite': false,
      'isGroup': false,
      'unreadCount': 0,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=4',
      'name': 'Axelle',
      'lastMessage': 'Chalut cha va ?',
      'isOnline': false,
      'hasUnread': false,
      'isFavorite': true,
      'isGroup': false,
      'unreadCount': 0,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=5',
      'name': 'Ax_Bakery',
      'lastMessage': 'Envoyé il y a une heure',
      'isOnline': false,
      'hasUnread': false,
      'isFavorite': false,
      'isGroup': false,
      'unreadCount': 0,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=10',
      'name': 'Projet ETSIA',
      'lastMessage': 'Réunion demain à 10h',
      'isOnline': false,
      'hasUnread': true,
      'isFavorite': false,
      'isGroup': true,
      'unreadCount': 5,
    },
  ];

  // 🔧 Filtrage des messages
  List<Map<String, dynamic>> get _filteredMessages {
    switch (_selectedFilter) {
      case model.MessageFilter.all:
        return _allMessages;
      case model.MessageFilter.unread:
        return _allMessages.where((msg) => msg['hasUnread'] == true).toList();
      case model.MessageFilter.channel:
        return _allMessages
            .where((msg) => (msg['unreadCount'] as int) > 99)
            .toList();
      case model.MessageFilter.favorites:
        return _allMessages.where((msg) => msg['isFavorite'] == true).toList();
      case model.MessageFilter.groups:
        return _allMessages.where((msg) => msg['isGroup'] == true).toList();
    }
    return []; // ✅ Sécurité
  }

  int get _groupsCount {
    return _allMessages.where((msg) => msg['isGroup'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
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
          'Messages',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Onglets de filtrage
          MessageFilterTabs(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            groupsCount: _groupsCount,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
          // Liste des messages
          Expanded(
            child: _filteredMessages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun message',
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              itemCount: _filteredMessages.length,
              itemBuilder: (context, index) {
                final message = _filteredMessages[index];
                return MessageListItem(
                  avatarUrl: message['avatarUrl'] as String,
                  name: message['name'] as String,
                  lastMessage: message['lastMessage'] as String,
                  isOnline: message['isOnline'] as bool,
                  hasUnread: message['hasUnread'] as bool,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour créer un nouveau message
        },
        backgroundColor: const Color(0xFF5D1A1A),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}