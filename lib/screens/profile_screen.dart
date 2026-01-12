import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/feed/student_post_card.dart';

import 'package:provider/provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/posts/presentation/providers/feed_provider.dart';
import 'edit_profile_screen.dart';
import 'search_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > 200) {
          if (!_showTitle) setState(() => _showTitle = true);
        } else {
          if (!_showTitle) setState(() => _showTitle = false);
        }
      }
    });

    // Ensure we have the user data loaded if not already
    // context.read<AuthProvider>().tryAutoLogin(); // Or reload
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildStat(int count, String label) {
    return Row(
      children: [
        Text(
          '$count',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        if (user == null) {
           return const Scaffold(body: Center(child: Text("Not logged in")));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 390.0,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {}, // TODO: Navigation pop
                  ),
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _showTitle ? 1.0 : 0.0,
                    child: Text(
                      user.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                      },
                    ),
                    IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () {}),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // 1. Banner Image (Fixed Height)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 130,
                          child: Image.asset(
                            'assets/images/onboarding_collaborate.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        // 2. Avatar (Overlapping)
                        Positioned(
                          top: 90,
                          left: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage: user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty
                                ? NetworkImage(user.profilePictureUrl!)
                                : const AssetImage('assets/images/onboarding_welcome.png') as ImageProvider,
                            ),
                          ),
                        ),

                        // 3. Edit Profile Button
                        Positioned(
                          top: 138,
                          right: 16,
                          child: OutlinedButton(
                             onPressed: (){
                               Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                             },
                             style: OutlinedButton.styleFrom(
                               side: BorderSide(color: Colors.grey[300]!),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                               foregroundColor: Colors.black,
                               padding: const EdgeInsets.symmetric(horizontal: 16),
                               backgroundColor: Colors.white,
                             ),
                             child: Text('Edit Profile', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)),
                           ),
                        ),

                        // 4. Content Body (Text)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 180, 16, 0),
                          child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 user.name,
                                 style: GoogleFonts.plusJakartaSans(
                                   fontWeight: FontWeight.w800,
                                   fontSize: 20,
                                   color: Colors.black,
                                 ),
                               ),
                               const SizedBox(height: 4),
                               Text(
                                 '@${user.username ?? "unknown"}', // Username display
                                 style: GoogleFonts.plusJakartaSans(
                                   fontSize: 13,
                                   color: Colors.grey[600],
                                 ),
                               ),
                               const SizedBox(height: 8),
                               Text(
                                 user.bio ?? 'No bio yet.',
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                                 style: GoogleFonts.plusJakartaSans(
                                   fontSize: 13,
                                   color: Colors.black87,
                                   height: 1.4,
                                 ),
                               ),
                               const SizedBox(height: 12),
                               // ... Extra metadata placeholder ...
                               const SizedBox(height: 12),
                               Row(
                                 children: [
                                   _buildStat(0, 'Following'),
                                   const SizedBox(width: 16),
                                   _buildStat(0, 'Followers'),
                                 ],
                               ),
                             ],
                           ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFF1DA1F2),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13),
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'Replies'),
                        Tab(text: 'Media'),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // Posts
                _UserPostsTab(userId: user.id),
                // Replies
                const Center(child: Text("No replies yet")),
                 // Media
                const Center(child: Text("No media yet")),
              ],
            ),
          ),
        );
      }
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEFF3F4))),
      ),
      child: _tabBar,
    );
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class _UserPostsTab extends StatefulWidget {
  final int userId;
  const _UserPostsTab({required this.userId});

  @override
  State<_UserPostsTab> createState() => _UserPostsTabState();
}

class _UserPostsTabState extends State<_UserPostsTab> {
  late Future<List<dynamic>> _postsFuture; // List<Post> usually

  @override
  void initState() {
    super.initState();
    _postsFuture = context.read<FeedProvider>().getUserPosts(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No posts yet",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "When you post, it'll show up here.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: StudentPostCard(
                avatarUrl: post.user?.profilePictureUrl ?? '',
                name: post.user?.name ?? 'Unknown User',
                headline: post.user?.username != null ? '@${post.user!.username}' : '',
                content: post.content,
                imageUrls: post.media.map((m) => m.url).toList().cast<String>(),
                likeCount: post.totalLikes,
                commentCount: post.totalComments,
              ),
            );
          },
        );
      },
    );
  }
}
