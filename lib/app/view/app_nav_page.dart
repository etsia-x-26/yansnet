import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yansnet/app/view/not_available_page.dart';
import 'package:yansnet/app/view/splash_page.dart';
import 'package:yansnet/app/widgets/yansnet_nav_bar.dart';
import 'package:yansnet/authentication/cubit/authentication_cubit.dart';
import 'package:yansnet/subscription/views/profile_screen.dart';

class ApppNavigationPage extends StatefulWidget {
  const ApppNavigationPage({super.key});

  @override
  State<ApppNavigationPage> createState() => _ApppNavigationPageState();
}

class _ApppNavigationPageState extends State<ApppNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const SplashPage(),
    const NotAvailablePage(pageName: 'Explore',),
    const NotAvailablePage(pageName: 'MarketPlace',),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yansnet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authCubit = context.read<AuthenticationCubit>();
              final user = authCubit.state.user;
              if (user != null) {
                authCubit.logout(user);
              }
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: YansnetBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
