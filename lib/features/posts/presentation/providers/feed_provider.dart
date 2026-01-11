import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/create_post_usecase.dart';

import 'dart:io';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../../media/domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';

class FeedProvider extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final LikePostUseCase likePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final UploadFileUseCase uploadFileUseCase;

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  FeedProvider({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.likePostUseCase,
    required this.deletePostUseCase,
    required this.uploadFileUseCase,
  });

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _posts = [];
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPosts = await getPostsUseCase(); // default page 0
      if (refresh) {
        _posts = newPosts;
      } else {
        _posts.addAll(newPosts);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPost(String content, {List<String>? mediaPaths}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final post = await createPostUseCase(content, mediaPaths: mediaPaths);
      _posts.insert(0, post); // Add to top
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<String?> uploadMedia(File file) async {
    try {
      return await uploadFileUseCase(file);
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }

  Future<bool> deletePost(int postId) async {
    try {
      await deletePostUseCase(postId);
      _posts.removeWhere((p) => p.id == postId);
      notifyListeners();
      return true;
    } catch (e) {
      print("Delete failed: $e");
      return false;
    }
  }
  
  Future<void> toggleLike(int postId) async {
    try {
      await likePostUseCase(postId);
      // Optimistic update or reload if needed. 
      // Current API doesn't return updated post, so we might need to manually increment
      // For now, just print success
      print('Liked post $postId');
    } catch (e) {
      print('Like error: $e');
    }
  }
}
