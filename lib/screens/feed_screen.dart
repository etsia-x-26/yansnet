import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/feed/job_offer_card.dart';
import '../widgets/feed/student_post_card.dart';
import '../widgets/feed/alumni_spotlight_card.dart';
import 'create_post_screen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white for that "Open/Free" feel
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 1. Classic "Social" App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Image.asset(
                'assets/images/logo_placeholder.png', // Or Text
                height: 28, // Logo height
                errorBuilder: (c,e,s) => Text(
                  'YansNet',
                  style: GoogleFonts.outfit( // Switching to Outfit for a trendier look if possible, or sticking to PJS
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
                  icon: const Icon(Icons.add_box_outlined, color: Colors.black, size: 28), // Changed to Add Icon
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
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold), // Reduced to 13
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
            CustomScrollView(
              slivers: [
                // Stories Rail
                SliverToBoxAdapter(
                  child: Container(
                    height: 135, // Increased height to prevent overflow
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFFDE0046), Color(0xFFF7A34B)],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: AssetImage('assets/images/onboarding_welcome.png'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'User ${index + 1}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9, // Reduced to 9
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Feed Content
                SliverList(
                  delegate: SliverChildListDelegate([
                    const StudentPostCard(
                      avatarUrl: '',
                      name: 'Sarah Chen',
                      headline: 'Product Designer',
                      content: 'Working on a new design system. It is surprisingly hard to keep everything consistent across mobile and web! 🎨 #DesignSystem #UI',
                      imageUrls: ['assets/images/onboarding_collaborate.png'], 
                      likeCount: 245,
                      commentCount: 42,
                    ),
                    
                    const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)), // "Divider Strip" style

                    const JobOfferCard(
                      companyName: 'Airbnb', 
                      timePosted: '2h', 
                      description: 'We are looking for a Senior Flutter Developer to join our core experience team.', 
                      bannerImageUrl: 'assets/images/onboarding_opportunities.png',
                    ),
                    
                    const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),

                     const AlumniSpotlightCard(
                     name: 'Michael Chang', 
                     headline: 'Engineering Lead @ Tesla', 
                     classInfo: 'Class of 2018', 
                     quote: 'Focus on the fundamentals. Frameworks change, but computer science principles last forever.',
                   ),

                    const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),

                    const StudentPostCard(
                      avatarUrl: '',
                      name: 'David Miller',
                      headline: 'CS Student',
                      content: 'Just deployed my first app to the App Store! 🚀',
                      imageUrls: [], 
                      likeCount: 890,
                      commentCount: 120,
                    ),

                    const SizedBox(height: 100),
                  ]),
                ),
              ],
            ),

            // Following Tab (Placeholder)
            const Center(child: Text("Following Feed")),
          ],
        ),
      ),
    );
  }
}
