import 'package:flutter/material.dart';
import '../../domain/auth_domain.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../../../core/network/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final ApiClient apiClient;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.apiClient,
  });

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authResponse = await loginUseCase(email, password);
      // Fetch user details
      _currentUser = await getUserUseCase(authResponse.userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await registerUseCase(name, username, email, password);
      await login(email, password);
    } catch (e) {
      _isLoading = false; // Fix: was missing separate loading set
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin() async {
    final token = await apiClient.storage.read(key: 'auth_token');
    final userIdStr = await apiClient.storage.read(key: 'user_id');
    
    print('[AuthProvider] tryAutoLogin: token=${token != null ? "exists" : "null"}, userId=$userIdStr');
    
    if (token != null && token.isNotEmpty && userIdStr != null) {
      try {
        _currentUser = await getUserUseCase(int.parse(userIdStr));
        print('[AuthProvider] Auto-login successful for user: ${_currentUser?.name}');
        notifyListeners();
        return true;
      } catch (e) {
        print('[AuthProvider] Auto-login failed: $e');
        // Token might be expired or invalid, clear it
        await apiClient.storage.delete(key: 'auth_token');
        await apiClient.storage.delete(key: 'user_id');
        return false;
      }
    }
    print('[AuthProvider] No valid token found for auto-login');
    return false;
  }

  Future<bool> updateProfile({String? name, String? bio, String? profilePictureUrl}) async {
    if (_currentUser == null) return false;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final updatedUser = await updateUserUseCase(
        _currentUser!.id, 
        name: name, 
        bio: bio, 
        profilePictureUrl: profilePictureUrl,
      );
      _currentUser = updatedUser;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


