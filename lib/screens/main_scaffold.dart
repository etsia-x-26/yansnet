import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feed_screen.dart';
import 'network_screen.dart';
import 'events_screen.dart';
import 'messages_screen.dart';

import 'jobs_screen.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure AuthProvider loads the user profile if a token exists
      Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
    });
  }

  final List<Widget> _screens = [
    const FeedScreen(),
    const NetworkScreen(),
    const JobsScreen(), // Added Jobs
    const EventsScreen(),
    const MessagesScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w500),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 28), 
              activeIcon: Icon(Icons.home_filled, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline, size: 28),
              activeIcon: Icon(Icons.people_alt, size: 28),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline, size: 28), // Jobs Icon
              activeIcon: Icon(Icons.work, size: 28),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: 28),
              activeIcon: Icon(Icons.calendar_month, size: 28),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send_outlined, size: 28),
              activeIcon: Icon(Icons.send, size: 28),
              label: 'Messages',
            ),
          ],
        ),
      ),
    );
  }
}
