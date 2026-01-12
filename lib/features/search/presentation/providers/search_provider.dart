import 'package:flutter/material.dart';
import '../../domain/repositories/search_repository.dart';
import '../../../auth/domain/auth_domain.dart';
import '../../../posts/domain/entities/post_entity.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRepository searchRepository;

  SearchProvider({required this.searchRepository});

  List<User> _users = [];
  List<Post> _posts = [];
  bool _isLoading = false;

  List<User> get users => _users;
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> search(String query) async {
    if (query.isEmpty) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      // Parallel execution
      final results = await Future.wait([
        searchRepository.searchUsers(query),
        searchRepository.searchPosts(query),
      ]);

      _users = results[0] as List<User>;
      _posts = results[1] as List<Post>;
    } catch (e) {
      print("Search error: $e");
      _users = [];
      _posts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearHelper() {
    _users = [];
    _posts = [];
    notifyListeners();
  }
}
