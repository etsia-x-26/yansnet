import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    debugPrint('SharedPreference Initialized');
  }

  Future<void> clearPreferenceData() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences!.clear();
  }

  Future<void> setAuthToken(String value) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences!.setString('authToken', value);
  }

  Future<String?> getAuthToken() async {
    try {
      // S'assurer que _sharedPreferences est initialisé
      _sharedPreferences ??= await SharedPreferences.getInstance();
      final token = _sharedPreferences?.getString('authToken');
      debugPrint('[PrefUtils] Auth token retrieved: ${token != null ? "exists" : "null"}');
      return token;
    } catch (e) {
      debugPrint('[PrefUtils] Error getting auth token: $e');
      return null; // Retourner null en cas d'erreur au lieu de crasher
    }
  }

  Future<void> setRefreshToken(String value) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences!.setString('refreshToken', value);
  }

  Future<String?> getRefreshToken() async {
    try {
      _sharedPreferences ??= await SharedPreferences.getInstance();
      return _sharedPreferences?.getString('refreshToken');
    } catch (e) {
      debugPrint('[PrefUtils] Error getting refresh token: $e');
      return null;
    }
  }

  Future<bool> removeUser() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!.remove('user');
  }

  Future<String?> getUser() async {
    try {
      _sharedPreferences ??= await SharedPreferences.getInstance();
      return _sharedPreferences?.getString('user');
    } catch (e) {
      debugPrint('[PrefUtils] Error getting user: $e');
      return null;
    }
  }
}