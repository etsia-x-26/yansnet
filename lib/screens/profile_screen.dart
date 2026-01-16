import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/feed/student_post_card.dart';

import 'package:provider/provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/domain/auth_domain.dart';
import '../features/posts/presentation/providers/feed_provider.dart';
import 'edit_profile_screen.dart';
import '../features/network/presentation/providers/network_provider.dart';
import 'login_screen.dart';
import '../core/utils/custom_dialogs.dart';
import '../features/chat/presentation/providers/chat_provider.dart';
import 'chat_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId; // If null, shows current user (My Profile)
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  bool _showTitle = false;
  User? _otherUser; // Stores data if viewing another user
  bool _isLoadingOtherUser = false;

  bool get isCurrentUser => widget.userId == null;

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

    if (!isCurrentUser) {
      _loadOtherUserProfile();
    }
    
  }

  Future<void> _loadOtherUserProfile() async {
    setState(() => _isLoadingOtherUser = true);
    try {
      // Assuming AuthProvider or a UserProvider has a method to get public user details
      // Since we don't have a dedicated public profile endpoint yet in the snippets,
      // we will rely on what we have or add a GetUserUseCase call here.
      // For now, let's assume we can fetch it via AuthProvider's user cache or similar.
      // Ideally: context.read<NetworkProvider>()... but Network provider does stats.
      // Let's use AuthProvider.getUserUseCase directly if possible or expose a method.
      // Wait, AuthProvider has `getUserUseCase`. We can use that!
      final user = await context.read<AuthProvider>().getUserUseCase(widget.userId!);
      setState(() => _otherUser = user);
    } catch (e) {
      print('Failed to load profile: $e');
    } finally {
      setState(() => _isLoadingOtherUser = false);
    }
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
    return Consumer2<AuthProvider, NetworkProvider>(
      builder: (context, authProvider, networkProvider, child) {
        final user = isCurrentUser ? authProvider.currentUser : _otherUser;

        if (_isLoadingOtherUser) {
           return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (user == null) {
           return const Scaffold(body: Center(child: Text("User not found or not logged in")));
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
                    onPressed: () => Navigator.pop(context),
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
                    if (!isCurrentUser)
                       IconButton(
                         icon: const Icon(Icons.message_outlined, color: Colors.black),
                         onPressed: () async {
                           final conversation = await context.read<ChatProvider>().startChat(user.id);
                           if (conversation != null && mounted) {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (_) => ChatDetailScreen(
                                   conversation: conversation,
                                   otherUser: user,
                                 ),
                               ),
                             );
                           }
                                                  },
                       ),
                    if (isCurrentUser)
                       IconButton(
                         icon: const Icon(Icons.logout, color: Colors.red),
                         onPressed: () async {
                           final shouldLogout = await showDialog<bool>(
                             context: context,
                             builder: (context) => AlertDialog(
                               title: const Text('Logout'),
                               content: const Text('Are you sure you want to logout?'),
                               actions: [
                                 TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                 TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout', style: TextStyle(color: Colors.red))),
                               ],
                             ),
                           );
                           
                           if (shouldLogout == true) {
                             await context.read<AuthProvider>().logout();
                             Navigator.of(context).pushAndRemoveUntil(
                               MaterialPageRoute(builder: (_) => const LoginScreen()),
                               (route) => false,
                             );
                           }
                         },
                       ),
                    // IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () {}),
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

                        // 3. Action Button (Edit Profile or Follow)
                        Positioned(
                          top: 138,
                          right: 16,
                          child: isCurrentUser 
                            ? OutlinedButton(
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
                             )
                            : ElevatedButton(
                                onPressed: () async {
                                  if (authProvider.currentUser != null) {
                                    await networkProvider.followUser(authProvider.currentUser!.id, user.id);
                                    // Update UI or show snackbar
                                    if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Followed ${user.name}')));
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                ),
                                child: Text('Follow', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13)),
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
                                   _buildStat(user.totalFollowing, 'Following'),
                                   const SizedBox(width: 16),
                                   _buildStat(user.totalFollowers, 'Followers'),
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
  List<dynamic> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final posts = await context.read<FeedProvider>().getUserPosts(widget.userId);
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deletePost(int postId) async {
    final confirmed = await CustomDialogs.showConfirmation(
      context: context,
      title: 'Delete Post',
      message: 'Are you sure you want to delete this post? This action cannot be undone.',
      confirmText: 'Delete',
      confirmColor: Colors.red,
    );

    if (confirmed == true) {
      final success = await context.read<FeedProvider>().deletePost(postId);
      if (success && mounted) {
        setState(() {
          _posts.removeWhere((p) => p.id == postId);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post deleted')));
      }
    }
  }

  Future<void> _editPost(dynamic post) async {
    final controller = TextEditingController(text: post.content);
    final newContent = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'What\'s on your mind?'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newContent != null && newContent.isNotEmpty && newContent != post.content) {
      final success = await context.read<FeedProvider>().updatePost(post.id, newContent);
      if (success && mounted) {
        setState(() {
          final index = _posts.indexWhere((p) => p.id == post.id);
          if (index != -1) {
            // Manually update the specific field locally to reflect change instantly
            // assuming Post is immutable, we might need to rely on the provider re-fetch
            // or if we trust the success, we re-load.
            // But better: construct new object if possible or just reload.
            // Reloading is safer for consistency.
             _loadPosts(); // Reload to get fresh data
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post updated')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    if (_posts.isEmpty) {
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

    final currentUserId = context.read<AuthProvider>().currentUser?.id;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        final isOwner = post.user?.id == currentUserId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: StudentPostCard(
            userId: post.user?.id ?? 0,
            avatarUrl: post.user?.profilePictureUrl ?? '',
            name: post.user?.name ?? 'Unknown User',
            headline: post.user?.username != null ? '@${post.user!.username}' : '',
            content: post.content,
            imageUrls: post.media.map((m) => m.url).toList().cast<String>(),
            likeCount: post.totalLikes,
            commentCount: post.totalComments,
            showDelete: isOwner,
            onDelete: isOwner ? () => _deletePost(post.id) : null,
            onEdit: isOwner ? () => _editPost(post) : null,
          ),
        );
      },
    );
  }
}
