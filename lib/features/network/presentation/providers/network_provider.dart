import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/network_entity.dart';
import '../../domain/usecases/get_network_stats_usecase.dart';
import '../../domain/usecases/get_network_suggestions_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';

class NetworkProvider extends ChangeNotifier {
  final GetNetworkStatsUseCase getNetworkStatsUseCase;
  final GetNetworkSuggestionsUseCase getNetworkSuggestionsUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;

  NetworkProvider({
    required this.getNetworkStatsUseCase,
    required this.getNetworkSuggestionsUseCase,
    required this.sendConnectionRequestUseCase,
  }) {
    _loadConnectedUsersFromStorage();
  }

  NetworkStats? _stats;
  List<NetworkSuggestion> _suggestions = [];
  bool _isLoading = false;
  String? _error;
  final Set<int> _connectedUserIds = <int>{};

  NetworkStats? get stats => _stats;
  List<NetworkSuggestion> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<int> get connectedUserIds => _connectedUserIds;

  bool isUserConnected(int userId) => _connectedUserIds.contains(userId);

  Future<void> loadNetworkData(int userId) async {
    print('🔍 NetworkProvider: Loading network data for userId: $userId');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔍 NetworkProvider: Calling use cases...');
      final results = await Future.wait([
        getNetworkStatsUseCase(userId),
        getNetworkSuggestionsUseCase(userId),
      ]);

      _stats = results[0] as NetworkStats;
      _suggestions = results[1] as List<NetworkSuggestion>;

      print(
        '🔍 NetworkProvider: Stats loaded: ${_stats?.connectionsCount} connections',
      );
      print(
        '🔍 NetworkProvider: Suggestions loaded: ${_suggestions.length} suggestions',
      );

      if (_suggestions.isNotEmpty) {
        print(
          '🔍 NetworkProvider: First suggestion: ${_suggestions.first.user.name}',
        );
      }

      // Les connexions sont chargées depuis le storage au démarrage du provider
    } catch (e) {
      print('❌ NetworkProvider: Error loading network data: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> connectUser(int fromUserId, int toUserId) async {
    try {
      final success = await sendConnectionRequestUseCase(fromUserId, toUserId);

      if (success) {
        _connectedUserIds.add(toUserId);
        await _saveConnectedUsersToStorage(); // Sauvegarder

        // Update stats
        if (_stats != null) {
          _stats = NetworkStats(
            connectionsCount: _stats!.connectionsCount + 1,
            contactsCount: _stats!.contactsCount,
            channelsCount: _stats!.channelsCount,
          );
        }

        notifyListeners();
      }

      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> disconnectUser(int fromUserId, int toUserId) async {
    try {
      // Appeler l'endpoint unfollow
      final success = await sendConnectionRequestUseCase.repository
          .disconnectUser(fromUserId, toUserId);

      if (success) {
        _connectedUserIds.remove(toUserId);
        await _saveConnectedUsersToStorage(); // Sauvegarder

        // Update stats
        if (_stats != null) {
          _stats = NetworkStats(
            connectionsCount: _stats!.connectionsCount - 1,
            contactsCount: _stats!.contactsCount,
            channelsCount: _stats!.channelsCount,
          );
        }

        notifyListeners();
      }

      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void markUserAsConnected(int userId) {
    _connectedUserIds.add(userId);
    _saveConnectedUsersToStorage();
    notifyListeners();
  }

  // Sauvegarder les connexions dans SharedPreferences
  Future<void> _saveConnectedUsersToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final connectedList = _connectedUserIds.toList();
      await prefs.setString('connected_user_ids', json.encode(connectedList));
      print('💾 Saved ${connectedList.length} connected users to storage');
    } catch (e) {
      print('❌ Failed to save connected users: $e');
    }
  }

  // Charger les connexions depuis SharedPreferences
  Future<void> _loadConnectedUsersFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('connected_user_ids');
      if (savedData != null) {
        final List<dynamic> decoded = json.decode(savedData);
        _connectedUserIds.clear();
        _connectedUserIds.addAll(decoded.cast<int>());
        print(
          '📂 Loaded ${_connectedUserIds.length} connected users from storage',
        );
        notifyListeners();
      }
    } catch (e) {
      print('❌ Failed to load connected users: $e');
    }
  }

  // Nettoyer les connexions sauvegardées (à appeler au logout)
  Future<void> clearConnectedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('connected_user_ids');
      _connectedUserIds.clear();
      print('🗑️ Cleared connected users from storage');
      notifyListeners();
    } catch (e) {
      print('❌ Failed to clear connected users: $e');
    }
  }
}
