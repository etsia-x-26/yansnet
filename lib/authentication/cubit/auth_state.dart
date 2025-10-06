import 'package:flutter/material.dart';
import 'package:yansnet/authentication/models/user.dart';

@immutable
abstract class AuthenticationState {
  const AuthenticationState({this.user});

  final User? user;
}

class NoAuth extends AuthenticationState {
  const NoAuth({bool? firstOpening})
      : super(user: null);
}

class UserFetched extends AuthenticationState {
  const UserFetched({required this.user}) : super(user: user);
  @override
  final User user;
}
class AuthError extends AuthenticationState {
  const AuthError({required this.message}) : super();
  final String message;
}

class Logout extends AuthenticationState {
  const Logout({required this.message}) : super();
  final String message;
}

class AuthLoading extends AuthenticationState {}