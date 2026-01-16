import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/posts/presentation/providers/feed_provider.dart';
import '../features/posts/domain/entities/post_entity.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isLoading = true);

    final success = await context.read<FeedProvider>().updatePost(widget.post.id, content);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context); // Return to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully')),
      );
    } else if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update post')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Post', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updatePost,
            child: _isLoading 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('Save', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1313EC), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: widget.post.user?.profilePictureUrl != null && widget.post.user!.profilePictureUrl!.isNotEmpty
                      ? NetworkImage(widget.post.user!.profilePictureUrl!)
                      : const AssetImage('assets/images/placeholder_user.png') as ImageProvider,
                  radius: 20,
                  child: widget.post.user?.profilePictureUrl == null || widget.post.user!.profilePictureUrl!.isEmpty
                    ? Text(widget.post.user?.name[0] ?? '?', style: const TextStyle(fontWeight: FontWeight.bold))
                    : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.plusJakartaSans(fontSize: 16),
                  ),
                ),
              ],
            ),
            // TODO: Add media editing support if API allows media updates later.
          ],
        ),
      ),
    );
  }
}
