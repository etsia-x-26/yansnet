import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            onPressed: () {},
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
              labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14),
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
        children: [
          _buildDirectMessagesList(),
          _buildChannelsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1313EC),
        child: const Icon(Icons.add_comment_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildDirectMessagesList() {
    return ListView.separated(
      itemCount: 12,
      separatorBuilder: (c, i) => const Divider(height: 1, indent: 72, color: Color(0xFFEFF3F4)),
      itemBuilder: (context, index) {
        final bool isUnread = index < 2;
        return InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    if (index % 3 == 0) // Online status simulation
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                  ],
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
                            'User Name $index',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '12:30 PM',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isUnread ? 'Did you get the notes from the lecture?' : 'See you tomorrow!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: isUnread ? Colors.black : Colors.grey[600],
                          fontSize: 13,
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1313EC),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelsList() {
    final List<Map<String, String>> channels = [
      {'name': 'General Announcements', 'members': '2.4k', 'tag': 'general'},
      {'name': 'Computer Science 2024', 'members': '450', 'tag': 'cs24'},
      {'name': 'Design Club', 'members': '128', 'tag': 'design'},
      {'name': 'Internship Alerts', 'members': '890', 'tag': 'jobs'},
      {'name': 'Study Group: Algorithms', 'members': '15', 'tag': 'algo'},
      {'name': 'Campus Events', 'members': '1.2k', 'tag': 'events'},
    ];

    return ListView.separated(
      itemCount: channels.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (c, i) => const Divider(height: 1, indent: 72, color: Color(0xFFEFF3F4)),
      itemBuilder: (context, index) {
        final channel = channels[index];
        return InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1313EC).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12), // Squircle for channels
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
                        '#${channel['tag']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${channel['name']} • ${channel['members']} members',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
