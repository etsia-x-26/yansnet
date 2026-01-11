import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/feed/job_offer_card.dart';
import '../widgets/feed/student_post_card.dart';
import '../widgets/feed/alumni_spotlight_card.dart';
import 'package:provider/provider.dart';
import '../features/posts/presentation/providers/feed_provider.dart';
import 'create_post_screen.dart';
import 'comments_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Fetch posts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadPosts(refresh: true);
    });
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
              leading: IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.black, size: 28),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 28),
                  onPressed: () {},
                ),
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
            // For You Tab
            RefreshIndicator(
              onRefresh: () => context.read<FeedProvider>().loadPosts(refresh: true),
              child: CustomScrollView(
                slivers: [
                   // Stories Rail (Static for now)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 100, 
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                           return CircleAvatar(radius: 28, backgroundColor: Colors.grey[200]);
                        },
                      ),
                    ),
                  ),

                  Consumer<FeedProvider>(
                    builder: (context, feedProvider, child) {
                      if (feedProvider.isLoading && feedProvider.posts.isEmpty) {
                        return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                      }

                      if (feedProvider.error != null && feedProvider.posts.isEmpty) {
                        return SliverFillRemaining(child: Center(child: Text('Error: ${feedProvider.error}')));
                      }
                      
                      if (feedProvider.posts.isEmpty) {
                         return const SliverFillRemaining(child: Center(child: Text('No posts yet.')));
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = feedProvider.posts[index];
                            final user = post.user;
                            
                            // Basic mapping to StudentPostCard
                            return Column(
                              children: [
                                StudentPostCard(
                                  avatarUrl: user?.profilePictureUrl ?? '',
                                  name: user?.name ?? 'Unknown User',
                                  headline: user?.bio ?? 'Student', // Fallback
                                  content: post.content,
                                  imageUrls: post.media.where((m) => m.type == 'IMAGE').map((m) => m.url).toList(),
                                  likeCount: post.totalLikes,
                                  commentCount: post.totalComments,
                                  onLike: () {
                                     feedProvider.toggleLike(post.id);
                                  },
                                  onComment: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentsScreen(postId: post.id),
                                      ),
                                    );
                                  },
                                ),
                                const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
                              ],
                            );
                          },
                          childCount: feedProvider.posts.length,
                        ),
                      );
                    },
                  ),
                   
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),

            // Following Tab (Placeholder)
            const Center(child: Text("Following Feed")),
          ],
        ),
      ),
    );
  }
}
