import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:yansnet/authentication/cubit/auth_state.dart';
import 'package:yansnet/authentication/models/login_credentials.dart';
import 'package:yansnet/authentication/models/registration_credentials.dart';
import 'package:yansnet/authentication/models/user.dart';
import 'package:yansnet/core/network/exceptions.dart';
import 'package:yansnet/core/utils/pref_utils.dart';
import 'package:yansnet/template/api/authentication_client.dart'
    hide HttpException;

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.authClient}) : super(const NoAuth());
  final AuthenticationClient authClient;

  Future<void> login(LoginCredentials credentials) async {
    emit(AuthLoading());
    try {
      // Mock successful login - comment out real API call
      // final user = await authClient.loginUser(credentials);

      // Simulate network delay
      await Future<void>.delayed(const Duration(seconds: 2));

      // Create mock user response
      final user = AuthResponse(
        id: 123,
        email: credentials.email,
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      debugPrint('Mock login successful for: ${credentials.email}');
      await saveToken(user.accessToken);
      emit(UserFetched(user: User.fromJson(user.toJson())));
    } on HttpException catch (e) {
      emit(AuthError(message: e.message!));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred'));
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> register(RegistrationCredentials credentials) async {
    emit(AuthLoading());
    try {
      // Mock successful registration - comment out real API call
      // final user = await authClient.registerUser(credentials);

      // Simulate network delay
      await Future<void>.delayed(const Duration(seconds: 2));

      // Create mock user response
      final user = AuthResponse(
        id: 456,
        email: credentials.email,
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      debugPrint('Mock registration successful for: ${credentials.email}');
      await saveToken(user.accessToken);
      emit(UserFetched(user: User.fromJson(user.toJson())));
    } on HttpException catch (e) {
      emit(AuthError(message: e.message!));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred'));
    }
  }

  Future<void> saveToken(String sessionId) async {
    await PrefUtils().setAuthToken(sessionId);
  }

  Future<void> logout(User user) async {
    try {
      emit(AuthLoading());
      const message = 'User logged out';
      await PrefUtils().setAuthToken('');
      await PrefUtils().removeUser();
      emit(const Logout(message: message));
    } on HttpException catch (e) {
      emit(AuthError(message: e.message!));
      emit(UserFetched(user: user));
    } catch (e) {
      emit(const AuthError(message: 'An error occurred'));
      emit(UserFetched(user: user));
    }
  }
}
