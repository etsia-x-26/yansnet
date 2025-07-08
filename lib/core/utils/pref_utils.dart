import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  PrefUtils(){
    SharedPreferences.getInstance().then((value){
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init()async{
    _sharedPreferences ??= await SharedPreferences.getInstance();
    debugPrint('SharedPreference Initialized');
  }

  Future<void> clearPreferenceData() async {
    await _sharedPreferences!.clear();
  }

  Future<void> setAuthToken(String value) {
    return _sharedPreferences!.setString('authToken', value);
  }

  Future<String?> getAuthToken() async {
    return _sharedPreferences!.getString('authToken');
  }

  Future<void> setRefreshToken(String value) {
    return _sharedPreferences!.setString('refreshToken', value);
  }

  Future<String?> getRefreshToken() async {
    return _sharedPreferences!.getString('refreshToken');
  }

  // Future<bool> setUser(User user) {
  //   return _sharedPreferences!.setString('user', jsonEncode(user.toJson()));
  // }

  Future<bool> removeUser(){
    return _sharedPreferences!.remove('user');
  }

  Future<String?> getUser() async {
    return _sharedPreferences!.getString('user');
  }
}