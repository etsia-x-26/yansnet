import 'package:flutter/material.dart';
import '../../domain/repositories/search_repository.dart';
import '../../../auth/domain/auth_domain.dart';
import '../../../posts/domain/entities/post_entity.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../events/domain/entities/event_entity.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRepository searchRepository;

  SearchProvider({required this.searchRepository});

  List<User> _users = [];
  List<Post> _posts = [];
  List<Job> _jobs = [];
  List<Event> _events = [];
  int _totalResults = 0;
  bool _isLoading = false;

  List<User> get users => _users;
  List<Post> get posts => _posts;
  List<Job> get jobs => _jobs;
  List<Event> get events => _events;
  int get totalResults => _totalResults;
  bool get isLoading => _isLoading;

  Future<void> search(String query) async {
    if (query.isEmpty) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final result = await searchRepository.searchCombined(query);
      
      _users = result.users.map((e) => e.toUserEntity()).toList();
      _posts = result.posts.map((e) => e.toPostEntity()).toList();
      _jobs = result.jobs.map((e) => e.toJobEntity()).toList();
      _events = result.events.map((e) => e.toEventEntity()).toList();
      _totalResults = result.totalResults;
      
    } catch (e) {
      print("Search error: $e");
      _users = [];
      _posts = [];
      _jobs = [];
      _events = [];
      _totalResults = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) return;
    _isLoading = true;
    notifyListeners();
    try {
      _users = await searchRepository.searchUsers(query);
    } catch (e) {
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchJobs(String query) async {
    if (query.isEmpty) return;
    _isLoading = true;
    notifyListeners();
    try {
      _jobs = await searchRepository.searchJobs(query);
    } catch (e) {
      _jobs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearHelper() {
    _users = [];
    _posts = [];
    _jobs = [];
    _events = [];
    _totalResults = 0;
    notifyListeners();
  }
}

