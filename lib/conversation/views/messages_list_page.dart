import 'package:flutter/material.dart';
import 'package:yansnet/conversation/models/message_filter.dart' as model;
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/views/channels_page.dart'; // 👈 AJOUTEZ CETTE LIGNE
import 'package:yansnet/conversation/widgets/message_filter_tabs.dart';
import 'package:yansnet/conversation/widgets/message_list_item.dart';


class MessagesListPage extends StatefulWidget {
  const MessagesListPage({super.key});

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
      'lastMessage': "Bonjour, j'espère que tu vas bien",
      'lastMessageTime': '14:30',
      'isOnline': true,
      'isFavorite': true,
      'isGroup': false,
      'isChannel': false,
      'unreadCount': 0,
      'memberCount': 2,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=2',
      'name': 'Pixsie',
      'lastMessage': '• •',
      'lastMessageTime': '14:30',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': false,
      'isChannel': false,
      'unreadCount': 150,
      'memberCount': 2,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=3',
      'name': 'Victoire',
      'lastMessage': 'Hey !',
      'lastMessageTime': '14:30',
      'isOnline': true,
      'isFavorite': false,
      'isGroup': false,
      'isChannel': false,
      'unreadCount': 7,
      'memberCount': 2,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=4',
      'name': 'Axelle',
      'lastMessage': 'Chalut cha va ?',
      'lastMessageTime': '14:30',
      'isOnline': false,
      'isFavorite': true,
      'isGroup': false,
      'isChannel': false,
      'unreadCount': 0,
      'memberCount': 2,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=5',
      'name': 'Ax_Bakery',
      'lastMessage': 'Envoyé il y a une heure',
      'lastMessageTime': '14:30',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': false,
      'isChannel': false,
      'unreadCount': 0,
      'memberCount': 2,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=10',
      'name': 'Projet ETSIA',
      'lastMessage': 'Réunion demain à 10h',
      'lastMessageTime': '14:30',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': true,
      'isChannel': false,
      'unreadCount': 5,
      'memberCount': 8,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=10',
      'name': 'Famille 👨‍👩‍👧‍👦',
      'lastMessage': 'Papa: On se voit ce weekend ?',
      'lastMessageTime': '14:30',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': true,
      'isChannel': false,
      'unreadCount': 5,
      'memberCount': 8,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'name': 'Équipe Dev 💻',
      'lastMessage': 'Marie: Le bug est corrigé !',
      'lastMessageTime': '12:15',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': true,
      'isChannel': false,
      'unreadCount': 12,
      'memberCount': 15,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=12',
      'name': 'Amis du lycée 🎓',
      'lastMessage': 'Jean: Qui vient à la réunion ?',
      'lastMessageTime': 'Hier',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': true,
      'isChannel': false,
      'unreadCount': 0,
      'memberCount': 25,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
      'name': 'Club de lecture 📚',
      'lastMessage': "Sophie: J'ai adoré ce livre !",
      'lastMessageTime': 'Lun',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': true,
      'isChannel': false,
      'unreadCount': 3,
      'memberCount': 12,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=14',
      'name': 'Voisins 🏘️',
      'lastMessage': "Marc: Quelqu'un a vu mon chat ?",
      'lastMessageTime': 'Mar',
      'isOnline': false,
      'isFavorite': false,
      'isGroup': true,
      'isChannel': false,
      'unreadCount': 0,
      'memberCount': 20,
    },
    {
      'avatarUrl': 'https://i.pravatar.cc/150?img=15',
      'name': 'Projet ETSIA 🎓',
      'lastMessage': 'Réunion demain à 10h',
      'lastMessageTime': '16:45',
      'isOnline': false,
      'isFavorite': true,
      'isGroup': true,
      'isChannel': false,
      'unreadCount': 8,
      'memberCount': 18,
    },
  ];

  // 🔧 Filtrage des messages par type de conversation
  List<Map<String, dynamic>> get _chatMessages {
    return _allMessages.where((msg) => msg['isGroup'] != true).toList();
  }

  List<Map<String, dynamic>> get _groupMessages {
    return _allMessages.where((msg) => msg['isGroup'] == true).toList();
  }

  List<Map<String, dynamic>> get _channelMessages {
    return _allMessages.where((msg) => msg['isChannel'] == true).toList();
  }

  // 🔧 Filtrage des messages avec filtres secondaires
  List<Map<String, dynamic>> _getFilteredMessages(
      List<Map<String, dynamic>> baseMessages,
      ) {
    switch (_selectedFilter) {
      case model.MessageFilter.all:
        return baseMessages;
      case model.MessageFilter.unread:
        return baseMessages
            .where((msg) => (msg['unreadCount'] as int) > 0)
            .toList();
      case model.MessageFilter.favorites:
        return baseMessages.where((msg) => msg['isFavorite'] == true).toList();
      case model.MessageFilter.groups:
        return baseMessages.where((msg) => msg['isGroup'] == true).toList();
      case model.MessageFilter.channel:
        return baseMessages
            .where((msg) => (msg['unreadCount'] as int) > 99)
            .toList();
    }
  }

  int get _groupsCount {
    return _allMessages.where((msg) => msg['isGroup'] == true).length;
  }

  Widget _buildMessagesList(List<Map<String, dynamic>> messages) {
    final filteredMessages = _getFilteredMessages(messages);

    return Column(
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
          child: filteredMessages.isEmpty
              ? const MessagesEmptyPage()
              : ListView.builder(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredMessages.length,
            itemBuilder: (context, index) {
              final message = filteredMessages[index];
              return MessageListItem(
                avatarUrl: message['avatarUrl'] as String,
                name: message['name'] as String,
                lastMessage: message['lastMessage'] as String,
                unreadCount: message['unreadCount'] as int,
                memberCount: message['memberCount'] as int,
                isGroup: message['isGroup'] as bool,
                isOnline: message['isOnline'] as bool,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
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
            centerTitle: false,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Chats',
                ),
                Tab(
                  text: 'Groupes',
                ),
                Tab(
                  text: 'Chaînes',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Onglet Chats
              _buildMessagesList(_chatMessages),
              // Onglet Groupes
              _buildMessagesList(_groupMessages),
              // Onglet Chaînes - 👈 REMPLACEZ CETTE LIGNE
              const ChannelsPage(), // 👈 NOUVELLE VUE POUR LES CHAÎNES
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
        ),
      ),
    );
  }
}