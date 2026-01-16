import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:provider/provider.dart';
import '../../features/posts/presentation/providers/feed_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class StudentPostCard extends StatefulWidget {
  final int userId; // Added userId
  final String avatarUrl;
  final String name;
  final String headline;
  final String content;
  final List<String> imageUrls;
  final int likeCount;
  final int commentCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final bool showDelete;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool isLiked;

  const StudentPostCard({
    super.key,
    required this.userId, // Required
    required this.avatarUrl,
    required this.name,
    required this.headline,
    required this.content,
    this.imageUrls = const [],
    required this.likeCount,
    required this.commentCount,
    this.onLike,
    this.onComment,
    this.showDelete = false,
    this.onDelete,
    this.onEdit,
    this.isLiked = false,
  });

  @override
  State<StudentPostCard> createState() => _StudentPostCardState();
}

class _StudentPostCardState extends State<StudentPostCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: Colors.grey[200],
                backgroundImage: widget.avatarUrl.isNotEmpty ? NetworkImage(widget.avatarUrl) : null,
                child: widget.avatarUrl.isEmpty 
                    ? const Icon(Icons.person, color: Colors.grey, size: 28) 
                    : null,
              ),
            ],
          ),
          const SizedBox(width: 12),
          
          // Right: Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 12, color: Colors.blue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.headline, 
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (widget.showDelete)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
                        onPressed: () {
                          _showOptionsBottomSheet(context);
                        },
                      )
                    else
                      // Only show report or minimal options if not owner (future enhancement)
                      const Icon(Icons.more_horiz, size: 20, color: Colors.transparent), // Hidden for non-owners for now or could be Report
                  ],
                ),
                
                // Content
                Text(
                  widget.content,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF0F1419),
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Images Carousel
                if (widget.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: widget.imageUrls.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final mediaUrl = widget.imageUrls[index];
                              
                              // More robust check: Remove query params before checking extension
                              final uri = Uri.tryParse(mediaUrl);
                              final path = uri?.path.toLowerCase() ?? mediaUrl.toLowerCase();
                              
                              final isVideo = path.endsWith('.mp4') || 
                                              path.endsWith('.mov') || 
                                              path.endsWith('.avi') || 
                                              path.endsWith('.webm') ||
                                              mediaUrl.contains('video'); // Fallback keywords
                              
                              if (isVideo) {
                                return _VideoPlayerItem(videoUrl: mediaUrl);
                              }
                              
                              /* Optimization: Use memCacheHeight/Width to reduce memory usage */
                              return CachedNetworkImage(
                                imageUrl: mediaUrl,
                                fit: BoxFit.cover,
                                memCacheHeight: 1000, 
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200], // Static placeholder instead of Shimmer for performance
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image_rounded, color: Colors.grey, size: 40),
                                      SizedBox(height: 8),
                                      Text("Image unavailable", style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Indicator
                          if (widget.imageUrls.length > 1)
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(widget.imageUrls.length, (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    width: _currentImageIndex == index ? 8 : 6,
                                    height: _currentImageIndex == index ? 8 : 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentImageIndex == index 
                                          ? Colors.white 
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          // Page Count Pill (Alternative/Additional)
                          if (widget.imageUrls.length > 1)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_currentImageIndex + 1}/${widget.imageUrls.length}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 12),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _IconAction(icon: Icons.chat_bubble_outline_rounded, label: '${widget.commentCount}', onTap: widget.onComment),
                    
                    // Repost Button: Hide if current user is the owner
                    if (context.read<AuthProvider>().currentUser?.id != widget.userId)
                      _IconAction(icon: Icons.cached_rounded, label: 'Repost'),

                    _IconAction(
                      icon: widget.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, 
                      label: '${widget.likeCount}', 
                      color: widget.isLiked ? Colors.pink : Colors.grey[600], // Correct color logic
                      onTap: widget.onLike
                    ),
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

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionItem(
              icon: Icons.edit_outlined,
              label: 'Edit Post',
              onTap: () {
                Navigator.pop(context);
                widget.onEdit?.call();
              },
            ),
            const SizedBox(height: 16),
            _buildOptionItem(
              icon: Icons.delete_outline,
              label: 'Delete Post',
              color: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                widget.onDelete?.call();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50], // Light background for contrast
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerItem({required this.videoUrl});

  @override
  State<_VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<_VideoPlayerItem> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isError = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
      
      _videoController = VideoPlayerController.file(file);
      await _videoController.initialize();
      
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false, // Managed by VisibilityDetector
        looping: true,
        showControls: false,
        showOptions: false,
        aspectRatio: _videoController.value.aspectRatio,
        allowFullScreen: false,
        allowMuting: false,
        placeholder: Container(color: Colors.black),
        errorBuilder: (context, errorMessage) {
          return const Center(child: Icon(Icons.error, color: Colors.white));
        },
      );
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Video initialization error: $e');
      if (mounted) setState(() => _isError = true);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _onTapVideo() {
    if (!_isInitialized) return;

    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Container(
          color: Colors.black12,
          child: const Center(child: Icon(Icons.error, color: Colors.grey)));
    }

    if (!_isInitialized || _chewieController == null || !_videoController.value.isInitialized) {
       return Container(
         color: Colors.black, // Dark background for video placeholder
         child: const Center(
           child: SizedBox(
             width: 30, height: 30,
             child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
           ),
         ),
       );
    }
    
    // Listen to global mute state
    final isMuted = context.select<FeedProvider, bool>((p) => p.isMuted);
    
    // Update volume
    _videoController.setVolume(isMuted ? 0 : 1);
    
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        if (!mounted || !_isInitialized) return;
        
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 50) {
          if (!_videoController.value.isPlaying) {
            _videoController.play();
          }
        } else {
          if (_videoController.value.isPlaying) {
            _videoController.pause();
          }
        }
      },
      child: GestureDetector(
        onTap: _onTapVideo,
        child: Stack(
          alignment: Alignment.center,
          children: [
              SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: Chewie(controller: _chewieController!),
                ),
              ),
            ),
            
            // Mute Icon
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                    context.read<FeedProvider>().toggleMute();
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: Icon(
                    isMuted ? Icons.volume_off : Icons.volume_up, 
                    color: Colors.white, 
                    size: 16
                  ),
                ),
              ),
            ),
          ],
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? Colors.grey[600]), 
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
