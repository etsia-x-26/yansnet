import 'package:flutter/material.dart';
import 'package:yansnet/authentication/views/login_page.dart';
import 'package:yansnet/authentication/views/register_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _isLogin = true;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLogin
            ? const LoginPage(key: ValueKey('login'))
            : const RegisterPage(key: ValueKey('register')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleAuthMode,
        label: Text(_isLogin ? 'Create Account' : 'Sign In'),
        icon: Icon(_isLogin ? Icons.person_add : Icons.login),
      ),
    );
  }
}