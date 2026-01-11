import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/feed/student_post_card.dart';

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
          if (_showTitle) setState(() => _showTitle = false);
        }
      }
    });
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 390.0, // Calculated 390px fit
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {},
              ),
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showTitle ? 1.0 : 0.0,
                child: Text(
                  'Alex Johnson',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
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
                      height: 130, // Reduced height
                      child: Image.asset(
                        'assets/images/onboarding_collaborate.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    // 2. Avatar (Overlapping)
                    Positioned(
                      top: 90, // 130 - 40 (half radius) -> Overlaps
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: AssetImage('assets/images/onboarding_welcome.png'),
                        ),
                      ),
                    ),

                    // 3. Edit Profile Button
                    Positioned(
                      top: 138, // Slightly below banner edge
                      right: 16,
                      child: OutlinedButton(
                         onPressed: (){},
                         style: OutlinedButton.styleFrom(
                           side: BorderSide(color: Colors.grey[300]!),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                           foregroundColor: Colors.black,
                           padding: const EdgeInsets.symmetric(horizontal: 16),
                           backgroundColor: Colors.white, // Ensure it stands out
                         ),
                         child: Text('Edit Profile', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)),
                       ),
                    ),

                    // 4. Content Body (Text)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 180, 16, 0), // Clear the avatar
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             'Alex Johnson',
                             style: GoogleFonts.plusJakartaSans(
                               fontWeight: FontWeight.w800,
                               fontSize: 20,
                               color: Colors.black,
                             ),
                           ),
                           const SizedBox(height: 4),
                           Text(
                             'Computer Science Student @ University',
                             style: GoogleFonts.plusJakartaSans(
                               fontSize: 13,
                               color: Colors.grey[600],
                             ),
                           ),
                           const SizedBox(height: 8),
                           Text(
                             'Building the future with Flutter. Passionate about Clean Architecture.',
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                             style: GoogleFonts.plusJakartaSans(
                               fontSize: 13,
                               color: Colors.black87,
                               height: 1.4,
                             ),
                           ),
                           const SizedBox(height: 12),
                           Row(
                             children: [
                                const Icon(Icons.link, size: 14, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text('github.com/alex', style: GoogleFonts.plusJakartaSans(color: Colors.blue, fontSize: 13)),
                                const SizedBox(width: 12),
                                const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('Joined 2021', style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12)),
                           ],
                           ),
                           const SizedBox(height: 12),
                           Row(
                             children: [
                               _buildStat(542, 'Following'),
                               const SizedBox(width: 16),
                               _buildStat(1843, 'Followers'),
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
                  indicatorColor: const Color(0xFF1DA1F2), // Twitter Blue underline
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
            ListView.separated(
              padding: EdgeInsets.zero, // Frameless
              itemCount: 5,
              separatorBuilder: (c,i) => const Divider(height: 1, color: Color(0xFFEFF3F4)),
              itemBuilder: (context, index) {
                return const StudentPostCard(
                    avatarUrl: '',
                    name: 'Alex Johnson',
                    headline: '@alex_dev',
                    content: 'Just managed to optimize the build time by 50%! 🚀 #Flutter #DevLife',
                    imageUrls: [], 
                    likeCount: 21,
                    commentCount: 4,
                  );
              },
            ),
            // Replies
            const Center(child: Text("No replies yet")),
             // Media
            GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[200],
                  child: Image.asset('assets/images/onboarding_collaborate.png', fit: BoxFit.cover),
                );
              },
            ),
          ],
        ),
      ),
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
