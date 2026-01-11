import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/posts/presentation/providers/comments_provider.dart';

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
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to post comment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments', style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
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
                  return const Center(child: Text('No comments yet. Be the first!'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = provider.comments[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18, 
                          backgroundImage: comment.user?.profilePictureUrl != null 
                             ? NetworkImage(comment.user!.profilePictureUrl!) 
                             : const AssetImage('assets/images/onboarding_welcome.png') as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment.user?.name ?? 'Unknown',
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(comment.createdAt),
                                    style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment.content,
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _commentController,
                    builder: (context, value, child) {
                       return TextButton(
                        onPressed: value.text.trim().isEmpty ? null : _handlePostComment,
                        child: Text(
                          'Post',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: value.text.trim().isEmpty ? Colors.grey : Theme.of(context).primaryColor,
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
