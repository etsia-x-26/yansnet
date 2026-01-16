import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/create_post_usecase.dart';

import 'dart:io';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../../media/domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';

import '../../domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/unlike_post_usecase.dart';

import '../../domain/usecases/get_user_posts_usecase.dart';

import '../../domain/usecases/get_following_feed_usecase.dart';

class FeedProvider extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;
  final GetFollowingFeedUseCase getFollowingFeedUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final LikePostUseCase likePostUseCase;
  final UnlikePostUseCase unlikePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final UploadFileUseCase uploadFileUseCase;

  List<Post> _posts = [];
  List<Post> _followingPosts = [];
  bool _isLoading = false;
  String? _error;
  
  // Pagination State
  int _currentPage = 0;
  int _currentFollowingPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool _hasMoreFollowing = true;

  // Video State
  bool _isMuted = true;

  FeedProvider({
    required this.getPostsUseCase,
    required this.getFollowingFeedUseCase,
    required this.getUserPostsUseCase,
    required this.createPostUseCase,
    required this.updatePostUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.deletePostUseCase,
    required this.uploadFileUseCase,
  });

  List<Post> get posts => _posts;
  List<Post> get followingPosts => _followingPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get hasMoreFollowing => _hasMoreFollowing;
  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      _error = null;
      if (_posts.isEmpty) _isLoading = true;
      notifyListeners();
    } else {
      if (!_hasMore || _isLoading) return;
      _isLoading = true;
      notifyListeners();
    }

    try {
      final newPosts = await getPostsUseCase(page: _currentPage, size: _pageSize);
      
      if (refresh) {
        _posts = newPosts;
      } else {
        final existingIds = _posts.map((p) => p.id).toSet();
        final uniqueNewPosts = newPosts.where((p) => !existingIds.contains(p.id)).toList();
        _posts.addAll(uniqueNewPosts);
      }

      if (newPosts.length < _pageSize) {
        _hasMore = false;
      } else {
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFollowingPosts({bool refresh = false}) async {
    if (refresh) {
      _currentFollowingPage = 0;
      _hasMoreFollowing = true;
      _error = null;
      if (_followingPosts.isEmpty) _isLoading = true;
      notifyListeners();
    } else {
      if (!_hasMoreFollowing || _isLoading) return;
      _isLoading = true;
      notifyListeners();
    }

    try {
      final newPosts = await getFollowingFeedUseCase(page: _currentFollowingPage, size: _pageSize);
      
      if (refresh) {
        _followingPosts = newPosts;
      } else {
        final existingIds = _followingPosts.map((p) => p.id).toSet();
        final uniqueNewPosts = newPosts.where((p) => !existingIds.contains(p.id)).toList();
        _followingPosts.addAll(uniqueNewPosts);
      }

      if (newPosts.length < _pageSize) {
        _hasMoreFollowing = false;
      } else {
        _currentFollowingPage++;
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

  Future<bool> updatePost(int postId, String content) async {
    try {
      final updatedPost = await updatePostUseCase(postId, content);
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = updatedPost;
        notifyListeners();
      }
      return true;
    } catch (e) {
      print("Update failed: $e");
      return false;
    }
  }
  
  Future<String?> uploadMedia(File file) async {
    return await uploadFileUseCase(file);
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
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final isLiked = post.isLiked;
      
      // Optimistic update
      final updatedPost = Post(
        id: post.id,
        content: post.content,
        createdAt: post.createdAt,
        user: post.user,
        channel: post.channel,
        media: post.media,
        totalLikes: isLiked ? post.totalLikes - 1 : post.totalLikes + 1,
        totalComments: post.totalComments,
        isLiked: !isLiked,
      );
      
      _posts[index] = updatedPost;
      notifyListeners();

      try {
        if (isLiked) {
          await unlikePostUseCase(postId); // Assuming unlikePostUseCase exists or use repo directly if usecase missing
        } else {
          await likePostUseCase(postId);
        }
      } catch (e) {
        // Revert on failure
        _posts[index] = post;
        notifyListeners();
        print('Like error: $e');
      }
    }
  }

  void incrementCommentCount(int postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      // Create a new copy of the post with incremented comment count
      // Assumes Post constructor is available and fields match
      final updatedPost = Post(
        id: post.id,
        content: post.content,
        createdAt: post.createdAt,
        user: post.user,
        channel: post.channel,
        media: post.media,
        totalLikes: post.totalLikes,
        totalComments: post.totalComments + 1,
      );
      _posts[index] = updatedPost;
      notifyListeners();
    }
  }

  // Duplicates removed

  Future<List<Post>> getUserPosts(int userId) async {
    try {
      return await getUserPostsUseCase(userId);
    } catch (e) {
      print('Error fetching user posts: $e');
      return [];
    }
  }
}
