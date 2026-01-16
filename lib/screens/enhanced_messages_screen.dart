import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/chat/presentation/providers/chat_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/messages/conversation_tile.dart';
import '../widgets/messages/story_bar.dart';
import '../widgets/messages/quick_actions.dart';
import 'enhanced_chat_detail_screen.dart';
import 'create_group_chat_screen.dart';
import 'instagram_contact_selector_screen.dart';

class EnhancedMessagesScreen extends StatefulWidget {
  const EnhancedMessagesScreen({super.key});

  @override
  State<EnhancedMessagesScreen> createState() => _EnhancedMessagesScreenState();
}

class _EnhancedMessagesScreenState extends State<EnhancedMessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadConversations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: _isSearching ? _buildSearchField() : _buildTitle(),
            actions: _buildActions(),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  // Stories bar (Instagram style)
                  const StoryBar(),
                  // Tabs
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFEFF3F4),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF1313EC),
                      unselectedLabelColor: Colors.grey[600],
                      indicatorColor: const Color(0xFF1313EC),
                      indicatorWeight: 2,
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'Primary'),
                        Tab(text: 'General'),
                        Tab(text: 'Requests'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPrimaryTab(),
            _buildGeneralTab(),
            _buildRequestsTab(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Text(
          'Messages',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1313EC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '3',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search messages...',
        hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[500]),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: GoogleFonts.plusJakartaSans(fontSize: 16),
      onChanged: (value) {
        // Implement search logic
      },
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [
        TextButton(
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1313EC),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ];
    }

    return [
      IconButton(
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
        },
        icon: const Icon(Icons.search, color: Colors.black),
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.black),
        onSelected: (value) {
          switch (value) {
            case 'settings':
              // Navigate to message settings
              break;
            case 'archived':
              // Show archived conversations
              break;
            case 'requests':
              _tabController.animateTo(2);
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                const Icon(Icons.settings, size: 20),
                const SizedBox(width: 12),
                Text('Settings', style: GoogleFonts.plusJakartaSans()),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'archived',
            child: Row(
              children: [
                const Icon(Icons.archive, size: 20),
                const SizedBox(width: 12),
                Text('Archived', style: GoogleFonts.plusJakartaSans()),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'requests',
            child: Row(
              children: [
                const Icon(Icons.person_add, size: 20),
                const SizedBox(width: 12),
                Text('Message Requests', style: GoogleFonts.plusJakartaSans()),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildPrimaryTab() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingConversations) {
          return const Center(child: CircularProgressIndicator());
        }

        final primaryConversations = provider.conversations
            .where((conv) => !conv.isArchived && conv.unreadCount > 0)
            .toList();

        if (primaryConversations.isEmpty) {
          return _buildEmptyState(
            'No new messages',
            'Start a conversation to see it here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: primaryConversations.length,
          itemBuilder: (context, index) {
            final conversation = primaryConversations[index];
            return ConversationTile(
              conversation: conversation,
              onTap: () => _openConversation(conversation),
              onLongPress: () => _showConversationOptions(conversation),
            );
          },
        );
      },
    );
  }

  Widget _buildGeneralTab() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingConversations) {
          return const Center(child: CircularProgressIndicator());
        }

        final generalConversations = provider.conversations
            .where((conv) => !conv.isArchived)
            .toList();

        if (generalConversations.isEmpty) {
          return _buildEmptyState(
            'No conversations',
            'Start chatting with your connections',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: generalConversations.length,
          itemBuilder: (context, index) {
            final conversation = generalConversations[index];
            return ConversationTile(
              conversation: conversation,
              onTap: () => _openConversation(conversation),
              onLongPress: () => _showConversationOptions(conversation),
            );
          },
        );
      },
    );
  }

  Widget _buildRequestsTab() {
    return _buildEmptyState(
      'No message requests',
      'Message requests from people you don\'t follow will appear here',
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Ouvrir le sélecteur de contacts style Instagram
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InstagramContactSelectorScreen(),
          ),
        );
      },
      backgroundColor: const Color(0xFF1313EC),
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }

  void _showNewMessageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const QuickActions(),
    );
  }

  void _openConversation(conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedChatDetailScreen(
          conversationId: conversation.id,
          conversation: conversation,
        ),
      ),
    );
  }

  void _showConversationOptions(conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.push_pin),
              title: Text(
                conversation.isPinned ? 'Unpin' : 'Pin',
                style: GoogleFonts.plusJakartaSans(),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement pin/unpin logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off),
              title: Text(
                conversation.isMuted ? 'Unmute' : 'Mute',
                style: GoogleFonts.plusJakartaSans(),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement mute/unmute logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: Text('Archive', style: GoogleFonts.plusJakartaSans()),
              onTap: () {
                Navigator.pop(context);
                // Implement archive logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete',
                style: GoogleFonts.plusJakartaSans(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement delete logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
