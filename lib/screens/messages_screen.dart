import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/chat/presentation/providers/chat_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/channels/presentation/providers/channels_provider.dart';
import 'search_screen.dart';
import 'instagram_new_message_screen.dart';
import 'instagram_chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadConversations();
      context.read<ChannelsProvider>().loadChannels();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Recharger les conversations quand on revient sur cette page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadConversations();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Messages',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEFF3F4))),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1313EC),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Direct'),
                Tab(text: 'Channels'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildDirectMessagesList(), _buildChannelsList()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewChatDialog,
        backgroundColor: const Color(0xFF1313EC),
        child: const Icon(Icons.add_comment_outlined, color: Colors.white),
      ),
    );
  }

  void _showNewChatDialog() {
    // Ouvrir l'écran de nouveau message style Instagram
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InstagramNewMessageScreen()),
    );
  }

  Widget _buildDirectMessagesList() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingConversations && provider.conversations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.conversations.isEmpty) {
          return const Center(child: Text("No conversations yet"));
        }

        return ListView.separated(
          itemCount: provider.conversations.length,
          separatorBuilder: (c, i) =>
              const Divider(height: 1, indent: 72, color: Color(0xFFEFF3F4)),
          itemBuilder: (context, index) {
            final conversation = provider.conversations[index];
            final currentUserId = Provider.of<AuthProvider>(
              context,
              listen: false,
            ).currentUser?.id;
            final otherUser = conversation.getOtherUser(currentUserId ?? 0);
            final lastMsg = conversation.lastMessage;

            return InkWell(
              onTap: () {
                if (otherUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InstagramChatScreen(
                        recipientUser: otherUser,
                        conversationId: conversation.id,
                        isGroup: false,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      backgroundImage: otherUser?.profilePictureUrl != null
                          ? NetworkImage(otherUser!.profilePictureUrl!)
                                as ImageProvider
                          : const AssetImage(
                              'assets/images/onboarding_welcome.png',
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                otherUser?.name ?? 'Unknown',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              if (lastMsg != null)
                                Text(
                                  _formatTime(lastMsg.createdAt),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lastMsg?.content ?? 'Start a conversation',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    // Simple formatter, can use intl package
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildChannelsList() {
    return Consumer<ChannelsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.channels.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.channels.isEmpty) {
          return const Center(child: Text('No channels joined yet.'));
        }

        final channels = provider.channels;

        return ListView.separated(
          itemCount: channels.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          separatorBuilder: (c, i) =>
              const Divider(height: 1, indent: 72, color: Color(0xFFEFF3F4)),
          itemBuilder: (context, index) {
            final channel = channels[index];
            return InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1313EC).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Squircle for channels
                      ),
                      child: Center(
                        child: Text(
                          '#',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF1313EC),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#${channel.title}',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${channel.title} • ${channel.totalFollowers} members',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
