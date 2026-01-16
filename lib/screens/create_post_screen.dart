import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_compress/video_compress.dart'; 
import '../features/posts/presentation/providers/feed_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../core/error/error_handler.dart';
import '../core/utils/dialog_utils.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<PickedMedia> _selectedMedia = [];
  bool _isPosting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedMedia.addAll(images.map((img) => PickedMedia(file: img)));
        });
      }
    } catch (e) {
      DialogUtils.showError(context, 'Error picking image: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> _pickVideo() async {
     try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      if (video != null) {
        // Start thumbnail generation immediately and cache the future
        final future = VideoCompress.getFileThumbnail(video.path);
        setState(() {
          _selectedMedia.add(PickedMedia(file: video, thumbnailFuture: future));
        });
      }
    } catch (e) {
      DialogUtils.showError(context, 'Error picking video: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  Future<void> _submitPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedMedia.isEmpty) return;

    setState(() {
      _isPosting = true;
    });

    try {
      List<String> uploadedUrls = [];
      final provider = context.read<FeedProvider>();

      // Upload media first
      if (_selectedMedia.isNotEmpty) {
        for (var item in _selectedMedia) {
          File fileToUpload = File(item.file.path);
          
          // Compress video if applicable
          final isVideo = item.file.path.toLowerCase().endsWith('.mp4') || 
                          item.file.path.toLowerCase().endsWith('.mov');
          if (isVideo) {
             try {
               final mediaInfo = await VideoCompress.compressVideo(
                  item.file.path,
                  quality: VideoQuality.MediumQuality, 
                  deleteOrigin: false,
               );
               if (mediaInfo?.file != null) {
                 fileToUpload = mediaInfo!.file!;
               }
             } catch (e) {
               print("Compression failed: $e, uploading original.");
             }
          }

          final url = await provider.uploadMedia(fileToUpload);
          if (url != null) {
            uploadedUrls.add(url);
          } else {
            if (mounted) { 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to upload some media')),
              );
            }
          }
        }
      }

      final success = await provider.createPost(content, mediaPaths: uploadedUrls);

      if (mounted) {
        if (success) {
          Navigator.pop(context);
          DialogUtils.showSuccess(context, 'Post published successfully!');
        } else {
          DialogUtils.showError(context, ErrorHandler.getErrorMessage(provider.error));
        }
      }
    } catch (e) {
      if (mounted) {
         DialogUtils.showError(context, ErrorHandler.getErrorMessage(e));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Fix lag
      appBar: AppBar(
        title: Text(
          'New Post',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[100], height: 1.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                height: 32,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _contentController,
                  builder: (context, value, child) {
                    final canPost = value.text.trim().isNotEmpty || _selectedMedia.isNotEmpty;
                    
                    return ElevatedButton(
                      onPressed: (canPost && !_isPosting) ? _submitPost : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1313EC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        disabledBackgroundColor: const Color(0xFFEFF3F4),
                        disabledForegroundColor: Colors.grey,
                      ),
                      child: _isPosting 
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                        : Text('Post', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: user?.profilePictureUrl != null 
                          ? NetworkImage(user!.profilePictureUrl!) as ImageProvider
                          : const AssetImage('assets/images/onboarding_welcome.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'User',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Anyone',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Text Input
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 2,
                    autofocus: true,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, 
                      height: 1.4, 
                      color: Colors.black,
                      fontWeight: FontWeight.w400
                    ),
                    decoration: InputDecoration(
                      hintText: 'What do you want to talk about?',
                      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Media Grid
                  if (_selectedMedia.isNotEmpty) 
                    _buildMediaPreview(),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: EdgeInsets.only(
              top: 12,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewPadding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              children: [
                 TextButton.icon(
                   onPressed: _pickImage,
                   icon: const Icon(Icons.image_outlined, color: Color(0xFF1313EC), size: 22),
                   label: Text('Photo', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1313EC), fontWeight: FontWeight.w600)),
                   style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                 ),
                 const SizedBox(width: 8),
                 TextButton.icon(
                   onPressed: _pickVideo,
                   icon: const Icon(Icons.videocam_outlined, color: Color(0xFF1313EC), size: 22),
                   label: Text('Video', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1313EC), fontWeight: FontWeight.w600)),
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                 ),
                 const Spacer(),
                 // Char count
                 SizedBox(
                   width: 20,
                   height: 20,
                   child: ValueListenableBuilder<TextEditingValue>(
                     valueListenable: _contentController,
                     builder: (context, value, _) {
                       return CircularProgressIndicator(
                         value: value.text.length / 280,
                         backgroundColor: Colors.grey[100],
                         color: value.text.length > 280 ? Colors.red : const Color(0xFF1313EC),
                         strokeWidth: 3,
                       );
                     },
                   ),
                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        child: _selectedMedia.length == 1 
          ? _buildSingleMedia(_selectedMedia[0], 0)
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: _selectedMedia.length,
              itemBuilder: (context, index) => _buildSingleMedia(_selectedMedia[index], index),
            ),
      ),
    );
  }

  Widget _buildSingleMedia(PickedMedia item, int index) {
      final isVideo = item.file.path.toLowerCase().endsWith('.mp4') || 
                      item.file.path.toLowerCase().endsWith('.mov');
      
      return Stack(
        fit: StackFit.expand,
        children: [
          if (isVideo && item.thumbnailFuture != null)
             FutureBuilder<File>(
               future: item.thumbnailFuture, // Use cached future
               builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                   return Image.file(snapshot.data!, fit: BoxFit.cover);
                 }
                 return Container(color: Colors.black12, child: const Center(child: CircularProgressIndicator()));
               },
             )
          else
            Image.file(File(item.file.path), fit: BoxFit.cover),
            
          if (isVideo)
            const Center(child: Icon(Icons.play_circle_fill, size: 48, color: Colors.white70)),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => _removeMedia(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      );
  }
}

class PickedMedia {
  final XFile file;
  final Future<File>? thumbnailFuture;

  PickedMedia({required this.file, this.thumbnailFuture});
}


