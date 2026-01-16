import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/posts/presentation/providers/comments_provider.dart';
import '../features/posts/presentation/providers/feed_provider.dart';

class CommentsScreen extends StatefulWidget {
  final int postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentsProvider>().loadComments(widget.postId, refresh: true);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handlePostComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final success = await context.read<CommentsProvider>().addComment(content);
    if (success) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
      // Update local feed state
      if (mounted) {
        context.read<FeedProvider>().incrementCommentCount(widget.postId);
      }
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to post comment')),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Header for BottomSheet feel
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Comments', 
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black, 
              fontWeight: FontWeight.bold, 
              fontSize: 16
            )
          ),
          const Divider(height: 24, thickness: 0.5),

          // List
          Expanded(
            child: Consumer<CommentsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.comments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.comments.isEmpty) {
                   return Center(child: Text('Error: ${provider.error}'));
                }

                if (provider.comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          'Start the conversation.',
                          style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = provider.comments[index];
                    final user = comment.user;
                    final displayName = (user?.name != null && user!.name.isNotEmpty) 
                        ? user.name 
                        : (user?.username?.isNotEmpty == true ? user!.username : 'User');

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16, // Slightly smaller
                          backgroundColor: Colors.grey[200],
                          backgroundImage: user?.profilePictureUrl != null && user!.profilePictureUrl!.isNotEmpty
                             ? NetworkImage(user.profilePictureUrl!) 
                             : null,
                          child: (user?.profilePictureUrl == null || user!.profilePictureUrl!.isEmpty)
                              ? const Icon(Icons.person, color: Colors.grey, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: displayName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 13, 
                                        color: Colors.black
                                      ),
                                    ),
                                    const WidgetSpan(child: SizedBox(width: 8)),
                                    TextSpan(
                                      text: comment.content,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13, 
                                        color: Colors.black87, 
                                        height: 1.3
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    _formatDate(comment.createdAt),
                                    style: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Reply',
                                    style: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                         const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: SafeArea( // Use SafeArea to avoid system navigation overlap
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 12),
                child: Row(
                  children: [
                    // Current User Avatar
                     /* 
                      * Note: Ideally fetch current user from AuthProvider.
                      * For now, using a placeholder or we can access generic 'me'
                      */
                     const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                     ),
                     const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.transparent), 
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Add a comment...',
                                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600]),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: GoogleFonts.plusJakartaSans(fontSize: 14),
                                minLines: 1,
                                maxLines: 5,
                              ),
                            ),
                             ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _commentController,
                              builder: (context, value, child) {
                                 if (value.text.trim().isEmpty) return const SizedBox.shrink();
                                 return TextButton(
                                  onPressed: _handlePostComment,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Post',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple formatter, simpler than intl for now
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}
