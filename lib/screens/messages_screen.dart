import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/chat/presentation/providers/chat_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'chat_detail_screen.dart';
import '../features/channels/presentation/providers/channels_provider.dart';
import '../features/chat/presentation/screens/new_chat_screen.dart';
import 'user_search_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Off-white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'Messages',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A1D1E),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const UserSearchScreen()));
            },
            icon: const Icon(Icons.search, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF3F4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
                  ]
                ),
                labelColor: const Color(0xFF1A1D1E),
                unselectedLabelColor: Colors.grey[600],
                labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(text: 'Direct'),
                  Tab(text: 'Channels'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDirectMessagesList(),
          _buildChannelsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const NewChatScreen()));
        },
        backgroundColor: const Color(0xFF1313EC),
        elevation: 4,
        child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildDirectMessagesList() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingConversations && provider.conversations.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1313EC)));
        }

        if (provider.conversations.isEmpty) {
          return Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.chat_bubble_outline_rounded, size: 60, color: Colors.grey[300]),
                 const SizedBox(height: 16),
                 Text("No messages yet", style: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 18)),
                 const SizedBox(height: 8),
                 Container(
                   margin: const EdgeInsets.symmetric(horizontal: 40),
                   child: Text(
                     "Start a new chat by tapping the button below.", 
                     textAlign: TextAlign.center,
                     style: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 14)
                  ),
                 ),
               ],
             )
          );
        }

        return ListView.builder(
          itemCount: provider.conversations.length,
          padding: const EdgeInsets.symmetric(vertical: 0),
          itemBuilder: (context, index) {
            final conversation = provider.conversations[index];
            final currentUserId = context.watch<AuthProvider>().currentUser?.id;
            final otherUser = conversation.getOtherUser(currentUserId ?? 0);
            final lastMsg = conversation.lastMessage;
            
            // Determine Title and Image
            final title = conversation.type == 'GROUP' 
                ? (conversation.title ?? "Group Chat") 
                : (otherUser?.name ?? "Unknown");
            final imageUrl = conversation.type == 'GROUP' ? null : otherUser?.profilePictureUrl;

            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => 
                  ChatDetailScreen(
                    conversation: conversation,
                    otherUser: otherUser,
                  )
                ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null,
                      child: (imageUrl == null || imageUrl.isEmpty)
                        ? (conversation.type == 'GROUP' 
                            ? const Icon(Icons.group, color: Colors.grey)
                            : Text(title.isNotEmpty ? title[0].toUpperCase() : '?', 
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 18)))
                        : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 16,
                                    color: const Color(0xFF1A1D1E),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                                if (lastMsg != null)
                                  Text(
                                    _formatTime(lastMsg.createdAt),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: conversation.unreadCount > 0 ? const Color(0xFF1313EC) : Colors.grey[500],
                                      fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      if (lastMsg?.senderId == currentUserId)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Icon(Icons.done_all, size: 16, color: Colors.grey[400]), // Static double check
                                        ),
                                      Expanded(
                                        child: Text(
                                          lastMsg?.type == 'IMAGE' 
                                              ? "📷 Photo" 
                                              : (lastMsg?.content ?? 'Start a conversation'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (conversation.unreadCount > 0)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1313EC),
                                      shape: BoxShape.circle,
                                    ),
                                  constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                                  child: Center(
                                    child: Text(
                                      conversation.unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
          },
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    // Simple formatter, typically '12:30 PM' or 'Yesterday'
    // For now, HH:MM
    final now = DateTime.now();
    if (now.day == time.day && now.year == time.year && now.month == time.month) {
       return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    }
    return "${time.day}/${time.month}";
  }

  Widget _buildChannelsList() {
    return Consumer<ChannelsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.channels.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1313EC)));
        }
        if (provider.channels.isEmpty) {
           return Center(child: Text('No channels joined yet.', style: GoogleFonts.plusJakartaSans(color: Colors.grey)));
        }
        
        final channels = provider.channels;

        return ListView.separated(
          itemCount: channels.length,
          padding: const EdgeInsets.symmetric(vertical: 12),
          separatorBuilder: (c, i) => const SizedBox(height: 0),
          itemBuilder: (context, index) {
            final channel = channels[index];
            return InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3F4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '#',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF1313EC),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            channel.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF1A1D1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${channel.totalFollowers} members',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[300]),
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
