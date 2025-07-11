import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yansnet/app/theme/app_theme.dart';
import 'package:yansnet/app/view/not_available_page.dart';
import 'package:yansnet/app/view/splash_page.dart';
import 'package:yansnet/app/widgets/yansnet_nav_bar.dart';
import 'package:yansnet/counter/view/counter_page.dart';
import 'package:yansnet/subscription/views/another_profile_screen.dart';
import 'package:yansnet/subscription/views/channel_screen.dart';
import 'package:yansnet/subscription/views/create_channel_screen.dart';
import 'package:yansnet/subscription/views/profile_screen.dart';

class ApppNavigationPage extends StatefulWidget {
  const ApppNavigationPage({super.key});

  @override
  State<ApppNavigationPage> createState() => _ApppNavigationPageState();
}

class _ApppNavigationPageState extends State<ApppNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChannelScreen(),
    const AnotherProfilePage(),
    const NotAvailablePage(
      pageName: 'MarketPlace',
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: YansnetBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CreateChannelScreen(),
          ),
        ),
        child: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.add,
            color: Colors.white,
          ),
        ),
      ),
    );
    ;
  }
}
