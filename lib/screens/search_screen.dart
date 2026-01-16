import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Add intl
import '../features/search/presentation/providers/search_provider.dart';
import '../features/chat/presentation/providers/chat_provider.dart';
import 'chat_detail_screen.dart';
import '../features/jobs/domain/entities/job_entity.dart';
import '../features/events/domain/entities/event_entity.dart';
import '../widgets/feed/student_post_card.dart';

class SearchScreen extends StatefulWidget {
  final int initialIndex;
  const SearchScreen({super.key, this.initialIndex = 0});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: widget.initialIndex); // All, People, Posts, Jobs, Events
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
          isScrollable: true, // Allow scrolling for 5 tabs
          tabs: const [
            Tab(text: "All"),
            Tab(text: "People"),
            Tab(text: "Posts"),
            Tab(text: "Jobs"),
            Tab(text: "Events"),
          ],
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.users.isEmpty && provider.posts.isEmpty && provider.jobs.isEmpty && provider.events.isEmpty && _searchController.text.isNotEmpty) {
             return const Center(child: Text("No results found"));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildAllTab(provider),
              _buildPeopleTab(provider),
              _buildPostsTab(provider),
              _buildJobsTab(provider),
              _buildEventsTab(provider),
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
        if (provider.jobs.isNotEmpty) ...[
          Text("Jobs", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...provider.jobs.take(3).map((j) => _buildJobTile(j)),
          const SizedBox(height: 20),
        ],
        if (provider.events.isNotEmpty) ...[
          Text("Events", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...provider.events.take(3).map((e) => _buildEventTile(e)),
          const SizedBox(height: 20),
        ],
        if (provider.posts.isNotEmpty) ...[
          Text("Posts", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
           ...provider.posts.take(3).map((p) => Padding(
             padding: const EdgeInsets.only(bottom: 8.0),
             child: StudentPostCard(
                    userId: p.user?.id ?? 0,
                    avatarUrl: p.user?.profilePictureUrl ?? '',
                    name: p.user?.name ?? 'Unknown User',
                    headline: p.user?.username != null ? '@${p.user!.username}' : '',
                    content: p.content,
                    imageUrls: p.media.map((m) => m.url).toList().cast<String>(),
                    likeCount: p.totalLikes,
                    commentCount: p.totalComments,
                  ),
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
            userId: post.user?.id ?? 0,
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

  Widget _buildJobsTab(SearchProvider provider) {
    if (provider.jobs.isEmpty) return const Center(child: Text("No jobs found"));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.jobs.length,
      separatorBuilder: (_,__) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildJobTile(provider.jobs[index]),
    );
  }

  Widget _buildEventsTab(SearchProvider provider) {
    if (provider.events.isEmpty) return const Center(child: Text("No events found"));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.events.length,
      separatorBuilder: (_,__) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildEventTile(provider.events[index]),
    );
  }

  Widget _buildUserTile(dynamic user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        backgroundImage: user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty
            ? NetworkImage(user.profilePictureUrl!)
            : const AssetImage('assets/images/onboarding_welcome.png') as ImageProvider,
      ),
      title: Text(user.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
      subtitle: Text('@${user.username ?? ""}', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
      trailing: IconButton(
        icon: const Icon(Icons.message_outlined, color: Color(0xFF1313EC)),
        onPressed: () async {
          // Start chat logic
          final conversation = await context.read<ChatProvider>().startChat(user.id);
          if (conversation != null && mounted) {
             Navigator.push(context, MaterialPageRoute(builder: (_) => 
               ChatDetailScreen(conversation: conversation)
             ));
          }
        },
      ),
    );
  }

  Widget _buildJobTile(Job job) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(job.companyName ?? 'Unknown Company', style: GoogleFonts.plusJakartaSans(color: Colors.grey[700], fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(job.location, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500])),
              const SizedBox(width: 12),
              Icon(Icons.work_outline, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(job.type.toString().split('.').last, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500])),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEventTile(Event event) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3F4),
              borderRadius: BorderRadius.circular(8),
              image: event.bannerUrl != null 
                ? DecorationImage(image: NetworkImage(event.bannerUrl!), fit: BoxFit.cover)
                : null,
            ),
             child: event.bannerUrl == null ? const Icon(Icons.event, color: Colors.grey) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd().format(event.eventDate),
                  style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1313EC), fontSize: 12, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
