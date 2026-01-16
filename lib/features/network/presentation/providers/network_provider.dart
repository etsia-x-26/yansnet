import 'package:flutter/material.dart';
import '../../domain/entities/network_entity.dart';
import '../../domain/usecases/get_network_stats_usecase.dart';
import '../../domain/usecases/get_network_suggestions_usecase.dart';
import '../../domain/usecases/follow_user_usecase.dart';

class NetworkProvider extends ChangeNotifier {
  final GetNetworkStatsUseCase getNetworkStatsUseCase;
  final GetNetworkSuggestionsUseCase getNetworkSuggestionsUseCase;
  final FollowUserUseCase followUserUseCase;

  NetworkStats? _stats;
  List<NetworkSuggestion> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  NetworkProvider({
    required this.getNetworkStatsUseCase,
    required this.getNetworkSuggestionsUseCase,
    required this.followUserUseCase,
  });

  NetworkStats? get stats => _stats;
  List<NetworkSuggestion> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNetworkData(int userId, {bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      notifyListeners();
    }
    _error = null;

    try {
      final results = await Future.wait([
        getNetworkStatsUseCase(userId),
        getNetworkSuggestionsUseCase(userId),
      ]);

      _stats = results[0] as NetworkStats;
      _suggestions = results[1] as List<NetworkSuggestion>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> followUser(int currentUserId, int otherUserId) async {
    try {
      final success = await followUserUseCase(currentUserId, otherUserId);
      if (success) {
        // Optimistically remove from suggestions
        _suggestions.removeWhere((s) => s.user.id == otherUserId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false; 
    }
  }
}
