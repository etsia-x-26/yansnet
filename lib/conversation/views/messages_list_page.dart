import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yansnet/conversation/api/groups_client.dart';
import 'package:yansnet/conversation/cubit/groups_cubit.dart';
import 'package:yansnet/conversation/cubit/groups_state.dart';
import 'package:yansnet/conversation/models/group.dart';
import 'package:yansnet/conversation/models/message_filter.dart' as model;
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/widgets/message_filter_tabs.dart';
import 'package:yansnet/conversation/widgets/message_list_item.dart';
import 'package:yansnet/core/network/dio_client.dart';

class MessagesListPage extends StatefulWidget {
  const MessagesListPage({super.key});

  @override
  State<MessagesListPage> createState() => _MessagesListPageState();
}

class _MessagesListPageState extends State<MessagesListPage> {
  model.MessageFilter _selectedFilter = model.MessageFilter.all;

  // Données mockées pour les chats (conversations individuelles)
  final List<Map<String, dynamic>> _mockChatMessages = [
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
  ];

  // Données mockées pour les chaînes
  final List<Map<String, dynamic>> _mockChannelMessages = [];

  /// Convertit les groupes du backend en format d'affichage
  List<Map<String, dynamic>> _convertGroupsToMessages(List<Group> groups) {
    return groups.map((group) {
      return {
        'id': group.id,
        'avatarUrl': group.profileImageUrl.isNotEmpty
            ? group.profileImageUrl
            : 'https://i.pravatar.cc/150?img=${group.id}',
        'name': group.name,
        'lastMessage': group.description,
        'lastMessageTime': _formatDate(group.updatedAt),
        'isOnline': false,
        'isFavorite': false,
        'isGroup': true,
        'isChannel': false,
        'unreadCount': 0,
        'memberCount': 0, // À implémenter avec une API dédiée plus tard
      };
    }).toList();
  }

  /// Formate la date en format lisible
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Aujourd'hui : affiche l'heure
      return '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      // Cette semaine : affiche le jour
      const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      return days[date.weekday - 1];
    } else {
      // Plus ancien : affiche la date complète
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Filtre les messages selon le filtre sélectionné
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

  /// Construit la liste des messages
  Widget _buildMessagesList(
      List<Map<String, dynamic>> messages, {
        bool isGroupTab = false,
      }) {
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
          groupsCount: messages.where((msg) => msg['isGroup'] == true).length,
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
              : RefreshIndicator(
            onRefresh: () async {
              if (isGroupTab) {
                await context.read<GroupsCubit>().refreshGroups();
              }
              // TODO: Implémenter refresh pour chats et chaînes
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
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
        ),
      ],
    );
  }

  /// Construit l'onglet des groupes avec les données réelles du backend
  Widget _buildGroupsTab() {
    return BlocBuilder<GroupsCubit, GroupsState>(
      builder: (context, state) {
        return state.when(
          // État initial : on charge les groupes
          initial: () {
            context.read<GroupsCubit>().loadGroups();
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          // État loading : affichage du spinner
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          // État loaded : affichage des groupes
          loaded: (groups) {
            if (groups.isEmpty) {
              return const MessagesEmptyPage();
            }
            final groupMessages = _convertGroupsToMessages(groups);
            return _buildMessagesList(groupMessages, isGroupTab: true);
          },
          // État error : affichage de l'erreur avec bouton retry
          error: (message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<GroupsCubit>().loadGroups();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D1A1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Création du GroupsCubit avec injection du client API
      create: (context) => GroupsCubit(
        groupsClient: GroupsClient(dio: DioClient.createDio()),
      ),
      child: DefaultTabController(
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
                Tab(text: 'Chats'),
                Tab(text: 'Groupes'),
                Tab(text: 'Chaînes'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Onglet Chats : données mockées
              _buildMessagesList(_mockChatMessages),

              // Onglet Groupes : données réelles du backend
              _buildGroupsTab(),

              // Onglet Chaînes : données mockées
              _buildMessagesList(_mockChannelMessages),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Implémenter création de nouveau message/groupe
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