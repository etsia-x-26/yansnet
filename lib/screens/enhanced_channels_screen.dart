import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/channels/presentation/providers/channels_provider.dart';
import '../widgets/channels/channel_card.dart';
import '../widgets/channels/trending_topics.dart';
import '../widgets/channels/suggested_channels.dart';
import 'create_channel_screen.dart';
import 'channel_detail_screen.dart';

class EnhancedChannelsScreen extends StatefulWidget {
  const EnhancedChannelsScreen({super.key});

  @override
  State<EnhancedChannelsScreen> createState() => _EnhancedChannelsScreenState();
}

class _EnhancedChannelsScreenState extends State<EnhancedChannelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChannelsProvider>().loadChannels();
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
                  // Trending Topics (Twitter style)
                  const TrendingTopics(),
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
                        Tab(text: 'Following'),
                        Tab(text: 'Discover'),
                        Tab(text: 'My Channels'),
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
            _buildFollowingTab(),
            _buildDiscoverTab(),
            _buildMyChannelsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateChannelScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1313EC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Channels',
      style: GoogleFonts.plusJakartaSans(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search channels...',
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
            case 'notifications':
              _showChannelNotifications();
              break;
            case 'settings':
              _showChannelSettings();
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'notifications',
            child: Row(
              children: [
                const Icon(Icons.notifications, size: 20),
                const SizedBox(width: 12),
                Text('Notifications', style: GoogleFonts.plusJakartaSans()),
              ],
            ),
          ),
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
        ],
      ),
    ];
  }

  Widget _buildFollowingTab() {
    return Consumer<ChannelsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final followingChannels = provider.channels
            .where((channel) => channel.isFollowing)
            .toList();

        if (followingChannels.isEmpty) {
          return _buildEmptyState(
            'No channels followed',
            'Discover and follow channels to see them here',
            Icons.campaign,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: followingChannels.length,
          itemBuilder: (context, index) {
            final channel = followingChannels[index];
            return ChannelCard(
              channel: channel,
              onTap: () => _openChannel(channel),
              onFollow: () => _toggleFollow(channel),
            );
          },
        );
      },
    );
  }

  Widget _buildDiscoverTab() {
    return Consumer<ChannelsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Suggested Channels
            const SliverToBoxAdapter(child: SuggestedChannels()),

            // All Channels
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final channels = provider.channels;
                if (channels.isEmpty) {
                  return _buildEmptyState(
                    'No channels available',
                    'Be the first to create a channel',
                    Icons.campaign,
                  );
                }

                final channel = channels[index];
                return ChannelCard(
                  channel: channel,
                  onTap: () => _openChannel(channel),
                  onFollow: () => _toggleFollow(channel),
                );
              }, childCount: provider.channels.length),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMyChannelsTab() {
    return Consumer<ChannelsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final myChannels = provider.channels
            .where((channel) => channel.isOwner)
            .toList();

        if (myChannels.isEmpty) {
          return _buildEmptyState(
            'No channels created',
            'Create your first channel to broadcast messages',
            Icons.add_circle_outline,
            actionText: 'Create Channel',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateChannelScreen(),
                ),
              );
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: myChannels.length,
          itemBuilder: (context, index) {
            final channel = myChannels[index];
            return ChannelCard(
              channel: channel,
              onTap: () => _openChannel(channel),
              onFollow: () => _toggleFollow(channel),
              showOwnerActions: true,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(
    String title,
    String subtitle,
    IconData icon, {
    String? actionText,
    VoidCallback? onAction,
  }) {
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
              child: Icon(icon, size: 40, color: Colors.grey[400]),
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
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1313EC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  actionText,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openChannel(channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelDetailScreen(channel: channel),
      ),
    );
  }

  void _toggleFollow(channel) {
    context.read<ChannelsProvider>().toggleFollowChannel(channel.id);
  }

  void _showChannelNotifications() {
    // Navigate to channel notifications screen
  }

  void _showChannelSettings() {
    // Navigate to channel settings screen
  }
}
