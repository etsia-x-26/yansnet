import 'package:flutter/material.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/usecases/add_comment_usecase.dart';

class CommentsProvider extends ChangeNotifier {
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;

  int? _currentPostId;
  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _error;

  CommentsProvider({
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
  });

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadComments(int postId, {bool refresh = true}) async {
    if (postId != _currentPostId) {
      _comments = [];
      _currentPostId = postId;
      refresh = true;
    }

    if (refresh) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final newComments = await getCommentsUseCase(postId);
      _comments = newComments;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (refresh) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> addComment(String content) async {
    if (_currentPostId == null) return false;

    try {
      final comment = await addCommentUseCase(_currentPostId!, content);
      _comments.add(comment);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
