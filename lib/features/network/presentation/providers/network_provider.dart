import 'package:flutter/material.dart';
import '../../domain/entities/network_entity.dart';
import '../../domain/usecases/get_network_stats_usecase.dart';
import '../../domain/usecases/get_network_suggestions_usecase.dart';

class NetworkProvider extends ChangeNotifier {
  final GetNetworkStatsUseCase getNetworkStatsUseCase;
  final GetNetworkSuggestionsUseCase getNetworkSuggestionsUseCase;

  NetworkProvider({
    required this.getNetworkStatsUseCase,
    required this.getNetworkSuggestionsUseCase,
  });

  NetworkStats? _stats;
  List<NetworkSuggestion> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  NetworkStats? get stats => _stats;
  List<NetworkSuggestion> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNetworkData(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

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
}
