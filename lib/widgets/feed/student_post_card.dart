import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentPostCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String headline;
  final String content;
  final List<String> imageUrls;
  final int likeCount;
  final int commentCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  // TODO: Add isLiked boolean

  const StudentPostCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.headline,
    required this.content,
    this.imageUrls = const [],
    required this.likeCount,
    required this.commentCount,
    this.onLike,
    this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    // "Threads/Twitter" Layout: Avatar on left, content column on right. Containerless.
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Avatar
          Column(
            children: [
               CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey,
                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : const AssetImage('assets/images/onboarding_welcome.png') as ImageProvider,
              ),
              // Thread line could go here if threaded
            ],
          ),
          const SizedBox(width: 12),
          
          // Right: Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Name + Time)
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13, // Reduced to 13
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 12, color: Colors.blue), // Reduced icon
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        headline, 
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, // Reduced to 11
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.more_horiz, size: 18, color: Colors.grey),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Text Content
                Text(
                  content,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, // Reduced to 12
                    color: const Color(0xFF0F1419),
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Images
                if (imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                    child: Container(
                       constraints: const BoxConstraints(maxHeight: 300),
                       width: double.infinity,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(16),
                         border: Border.all(color: Colors.grey.withOpacity(0.2)),
                         image: const DecorationImage(
                           image: AssetImage('assets/images/onboarding_collaborate.png'),
                           fit: BoxFit.cover,
                         ),
                       ),
                    ),
                  ),

                const SizedBox(height: 12),
                
                // Action Row (Minimal)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _IconAction(icon: Icons.chat_bubble_outline_rounded, label: '$commentCount', onTap: onComment),
                    _IconAction(icon: Icons.cached_rounded, label: 'Repost'),
                    _IconAction(icon: Icons.favorite_border_rounded, label: '$likeCount', color: Colors.pink, onTap: onLike),
                    _IconAction(icon: Icons.share_outlined, label: ''),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _IconAction({required this.icon, required this.label, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4), // Hit area
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]), 
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600]),
              )
            ]
          ],
        ),
      ),
    );
  }
}
