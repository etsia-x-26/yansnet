import 'package:flutter/material.dart';
import 'package:yansnet/app/view/not_available_page.dart';
import 'package:yansnet/app/widgets/yansnet_nav_bar.dart';
import 'package:yansnet/publication/views/explore_page.dart';
import 'package:yansnet/publication/views/home_page.dart';

class ApppNavigationPage extends StatefulWidget {
  const ApppNavigationPage({super.key});

  @override
  State<ApppNavigationPage> createState() => _ApppNavigationPageState();
}

class _ApppNavigationPageState extends State<ApppNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const NotAvailablePage(
      pageName: 'MarketPlace',
    ),
    const NotAvailablePage(
      pageName: 'Profile',
    ),
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
    );
  }
}
