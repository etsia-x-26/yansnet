import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/feed/student_post_card.dart';
import 'package:provider/provider.dart';
import '../features/posts/presentation/providers/feed_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'create_post_screen.dart';
import 'comments_screen.dart';
import 'profile_screen.dart';
import '../core/utils/custom_dialogs.dart';
import 'edit_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _followingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    // Fetch posts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadPosts(refresh: true);
    });

    _scrollController.addListener(_onScroll);
    _followingScrollController.addListener(_onFollowingScroll);
  }

  void _handleTabChange() {
    if (_tabController.index == 1 && !_tabController.indexIsChanging) {
      final provider = context.read<FeedProvider>();
      if (provider.followingPosts.isEmpty) {
        provider.loadFollowingPosts();
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _scrollController.dispose();
    _followingScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<FeedProvider>();
      if (!provider.isLoading && provider.hasMore) {
        provider.loadPosts();
      }
    }
  }

  void _onFollowingScroll() {
    if (_followingScrollController.position.pixels >= _followingScrollController.position.maxScrollExtent - 200) {
      final provider = context.read<FeedProvider>();
      if (!provider.isLoading && provider.hasMoreFollowing) {
        provider.loadFollowingPosts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Image.asset(
                'assets/images/logo_placeholder.png', 
                height: 28, 
                errorBuilder: (c,e,s) => Text(
                  'YansNet',
                  style: GoogleFonts.outfit( 
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const ProfileScreen())
                    );
                  },
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final user = auth.currentUser;
                      return CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (user?.profilePictureUrl != null && user!.profilePictureUrl!.isNotEmpty)
                            ? NetworkImage(user.profilePictureUrl!)
                            : null,
                        child: (user?.profilePictureUrl == null || user!.profilePictureUrl!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      );
                    },
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined, color: Colors.black, size: 28), 
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold), 
                  tabs: const [
                    Tab(text: 'For You'),
                    Tab(text: 'Following'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFeedList(context, true), // For You Tab
            _buildFeedList(context, false), // Following Tab
          ],
        ),
      ),
    );
  }

  Widget _buildFeedList(BuildContext context, bool isForYou) {
    return Consumer<FeedProvider>(
      builder: (context, provider, _) {
        final posts = isForYou ? provider.posts : provider.followingPosts;
        final hasMore = isForYou ? provider.hasMore : provider.hasMoreFollowing;
        final controller = isForYou ? null : _followingScrollController; // NestedScrollView handles the main controller

        if (provider.isLoading && posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null && posts.isEmpty) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.feed_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  isForYou ? "No posts yet" : "No posts from people you follow",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => isForYou 
              ? provider.loadPosts(refresh: true) 
              : provider.loadFollowingPosts(refresh: true),
          child: CustomScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (isForYou) // Stories only on "For You"
                SliverToBoxAdapter(
                  child: _buildStoriesRail(),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == posts.length) {
                      return hasMore 
                          ? const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox(height: 100);
                    }
                    final post = posts[index];
                    final user = post.user;
                    return Column(
                      children: [
                        StudentPostCard(
                          userId: user?.id ?? 0,
                          avatarUrl: user?.profilePictureUrl ?? '',
                          name: user?.name ?? 'Unknown User',
                          headline: user?.bio ?? 'Student',
                          content: post.content,
                          imageUrls: post.media.map((m) => m.url).toList().cast<String>(),
                          likeCount: post.totalLikes,
                          commentCount: post.totalComments,
                          isLiked: post.isLiked,
                          showDelete: (context.read<AuthProvider>().currentUser != null && post.user?.id == context.read<AuthProvider>().currentUser!.id),
                          onDelete: () async {
                             final confirm = await CustomDialogs.showConfirmation(
                               context: context, 
                               title: 'Delete Post', 
                               message: 'Are you sure you want to delete this post? This action cannot be undone.',
                               confirmText: 'Delete',
                               confirmColor: Colors.red
                             );
                             
                             if (confirm) {
                               await context.read<FeedProvider>().deletePost(post.id);
                             }
                          },
                          onLike: () {
                             provider.toggleLike(post.id);
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditPostScreen(post: post)),
                            );
                          },
                          onComment: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                height: MediaQuery.of(context).size.height * 0.85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                  child: CommentsScreen(postId: post.id),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
                      ],
                    );
                  },
                  childCount: posts.length + 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoriesRail() {
    final user = context.read<AuthProvider>().currentUser;
    return Container(
      height: 125,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 28, 
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (user?.profilePictureUrl != null && user!.profilePictureUrl!.isNotEmpty) 
                           ? NetworkImage(user.profilePictureUrl!) 
                           : null,
                        child: (user?.profilePictureUrl == null || user!.profilePictureUrl!.isEmpty)
                           ? const Icon(Icons.person, color: Colors.grey, size: 28)
                           : null,
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.add, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Your Story", 
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
