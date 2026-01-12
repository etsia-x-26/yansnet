import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/search/presentation/providers/search_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/feed/student_post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    // Clear search results on exit? Maybe better to keep state. 
    // Usually clean on dispose is good for fresh search next time.
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<SearchProvider>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF3F4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearch,
            decoration: InputDecoration(
              hintText: 'Search YansNet',
              hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1DA1F2),
          tabs: const [
            Tab(text: "All"),
            Tab(text: "People"),
            Tab(text: "Posts"),
          ],
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.users.isEmpty && provider.posts.isEmpty && _searchController.text.isNotEmpty) {
             // Only show empty state if we searched something
             // But wait, initially it's empty too.
             // We can check if provider has ever searched or handle via logic.
             // For now assume empty list means no result IF not loading.
             return const Center(child: Text("No results found"));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildAllTab(provider),
              _buildPeopleTab(provider),
              _buildPostsTab(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAllTab(SearchProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (provider.users.isNotEmpty) ...[
          Text("People", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...provider.users.take(3).map((u) => _buildUserTile(u)),
          const SizedBox(height: 20),
        ],
        if (provider.posts.isNotEmpty) ...[
          Text("Posts", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
           ...provider.posts.take(3).map((p) =>                   StudentPostCard(
                    avatarUrl: p.user?.profilePictureUrl ?? '',
                    name: p.user?.name ?? 'Unknown User',
                    headline: p.user?.username != null ? '@${p.user!.username}' : '',
                    content: p.content,
                    imageUrls: p.media.map((m) => m.url).toList().cast<String>(),
                    likeCount: p.totalLikes,
                    commentCount: p.totalComments,
                  )),
        ]
      ],
    );
  }

  Widget _buildPeopleTab(SearchProvider provider) {
    if (provider.users.isEmpty) return const Center(child: Text("No people found"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.users.length,
      itemBuilder: (context, index) => _buildUserTile(provider.users[index]),
    );
  }

  Widget _buildPostsTab(SearchProvider provider) {
     if (provider.posts.isEmpty) return const Center(child: Text("No posts found"));
     return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: provider.posts.length,
      itemBuilder: (context, index) {
        final post = provider.posts[index];
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
  }

  Widget _buildUserTile(dynamic user) { // Using dynamic or importing User from auth domain
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        backgroundImage: user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty
            ? NetworkImage(user.profilePictureUrl!)
            : const AssetImage('assets/images/onboarding_welcome.png') as ImageProvider,
      ),
      title: Text(user.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
      subtitle: Text('@${user.username ?? ""}', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
      onTap: () {
        // Navigate to user profile?
        // Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfileScreen(id: user.id)));
      },
    );
  }
}
