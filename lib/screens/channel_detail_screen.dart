import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChannelDetailScreen extends StatefulWidget {
  final dynamic channel;

  const ChannelDetailScreen({super.key, required this.channel});

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;
  bool _isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isFollowing = widget.channel.isFollowing ?? false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  switch (value) {
                    case 'share':
                      _shareChannel();
                      break;
                    case 'report':
                      _reportChannel();
                      break;
                    case 'block':
                      _blockChannel();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        const Icon(Icons.share, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Share Channel',
                          style: GoogleFonts.plusJakartaSans(),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'report',
                    child: Row(
                      children: [
                        const Icon(Icons.report, size: 20),
                        const SizedBox(width: 12),
                        Text('Report', style: GoogleFonts.plusJakartaSans()),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'block',
                    child: Row(
                      children: [
                        const Icon(Icons.block, size: 20, color: Colors.red),
                        const SizedBox(width: 12),
                        Text(
                          'Block Channel',
                          style: GoogleFonts.plusJakartaSans(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(background: _buildChannelHeader()),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFEFF3F4), width: 0.5),
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
                    Tab(text: 'Posts'),
                    Tab(text: 'About'),
                    Tab(text: 'Members'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildPostsTab(), _buildAboutTab(), _buildMembersTab()],
        ),
      ),
    );
  }

  Widget _buildChannelHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Channel Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: Colors.white, width: 4),
              image: widget.channel.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(widget.channel.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.channel.imageUrl == null
                ? Icon(Icons.campaign, size: 50, color: Colors.grey[600])
                : null,
          ),
          const SizedBox(height: 16),

          // Channel Name and Verification
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.channel.name ?? 'Channel Name',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (widget.channel.isVerified == true) ...[
                const SizedBox(width: 8),
                const Icon(Icons.verified, size: 24, color: Color(0xFF1313EC)),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Follower Count
          Text(
            '${_formatFollowerCount(widget.channel.followersCount ?? 0)} followers',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFollowing
                        ? Colors.grey[200]
                        : const Color(0xFF1313EC),
                    foregroundColor: _isFollowing
                        ? Colors.grey[700]
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _isFollowing ? 'Following' : 'Follow',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  onPressed: _toggleNotifications,
                  icon: Icon(
                    _isNotificationsEnabled
                        ? Icons.notifications
                        : Icons.notifications_off,
                    color: _isNotificationsEnabled
                        ? const Color(0xFF1313EC)
                        : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  onPressed: _shareChannel,
                  icon: Icon(Icons.share, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 10, // Mock data
      itemBuilder: (context, index) {
        return _buildPostItem(index);
      },
    );
  }

  Widget _buildPostItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  widget.channel.imageUrl ??
                      'https://picsum.photos/200/200?random=1',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.channel.name ?? 'Channel Name',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '2h ago',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This is a sample post from the channel. It could contain text, images, or other media content.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPostAction(Icons.favorite_border, '24'),
              const SizedBox(width: 16),
              _buildPostAction(Icons.comment_outlined, '5'),
              const SizedBox(width: 16),
              _buildPostAction(Icons.share_outlined, '2'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostAction(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          count,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutSection(
            'Description',
            widget.channel.description ?? 'No description available',
          ),
          const SizedBox(height: 24),
          _buildAboutSection(
            'Created',
            'January 15, 2024', // Mock date
          ),
          const SizedBox(height: 24),
          _buildAboutSection(
            'Category',
            'Technology', // Mock category
          ),
          const SizedBox(height: 24),
          _buildAboutSection(
            'Language',
            'English', // Mock language
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 20, // Mock data
      itemBuilder: (context, index) {
        return _buildMemberItem(index);
      },
    );
  }

  Widget _buildMemberItem(int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://picsum.photos/200/200?random=${index + 50}',
        ),
      ),
      title: Text(
        'Member ${index + 1}',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        '@member${index + 1}',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: index == 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1313EC).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Admin',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1313EC),
                ),
              ),
            )
          : null,
    );
  }

  String _formatFollowerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? 'Following ${widget.channel.name}'
              : 'Unfollowed ${widget.channel.name}',
          style: GoogleFonts.plusJakartaSans(),
        ),
        backgroundColor: _isFollowing ? Colors.green : Colors.grey[600],
      ),
    );
  }

  void _toggleNotifications() {
    setState(() {
      _isNotificationsEnabled = !_isNotificationsEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isNotificationsEnabled
              ? 'Notifications enabled'
              : 'Notifications disabled',
          style: GoogleFonts.plusJakartaSans(),
        ),
      ),
    );
  }

  void _shareChannel() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing ${widget.channel.name}',
          style: GoogleFonts.plusJakartaSans(),
        ),
      ),
    );
  }

  void _reportChannel() {
    // Implement report functionality
  }

  void _blockChannel() {
    // Implement block functionality
  }
}
