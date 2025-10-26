import 'package:flutter/material.dart';
import 'package:yansnet/conversation/widgets/message_list_item.dart';

class MessagesListPage extends StatelessWidget {
  const MessagesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              home: DefaultTabController(
                length: 2, 
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
            Tab(text: 'Chats',),
            Tab(text: 'Groupes'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: const [
                MessageListItem(
                  avatarUrl: 'https://i.pravatar.cc/150?img=1',
                  name: 'Emmy',
                  lastMessage: "Bonjour, j'espère que tu vas bien",
                  isOnline: true,
                ),
                MessageListItem(
                  avatarUrl: 'https://i.pravatar.cc/150?img=2',
                  name: 'Pixsie',
                  lastMessage: '• •',
                  hasUnread: true,
                ),
                MessageListItem(
                  avatarUrl: 'https://i.pravatar.cc/150?img=3',
                  name: 'Victoire',
                  lastMessage: 'Hey !',
                  isOnline: true,
                ),
                MessageListItem(
                  avatarUrl: 'https://i.pravatar.cc/150?img=4',
                  name: 'Axelle',
                  lastMessage: 'Chalut cha va ?',
                ),
                MessageListItem(
                  avatarUrl: 'https://i.pravatar.cc/150?img=5',
                  name: 'Ax_Bakery',
                  lastMessage: 'Envoyé il y a une heure',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: const [
                MessageListItem(
                  avatarUrl: 'https://i.pravatar.cc/150?img=3',
                  name: 'X2026',
                  lastMessage: 'Hey !',
                  isOnline: true,
                ),
                MessageListItem(
                  avatarUrl: 'https://i.pravatar.cc/150?img=4',
                  name: 'COCFET',
                  lastMessage: 'Bonsoir à tous',
                ),
              ],
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
    )),
    );
  }
}