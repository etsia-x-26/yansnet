import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yansnet/app/widgets/nav_bar_item.dart';

class YansnetBottomNavBar extends StatelessWidget {

  const YansnetBottomNavBar({
    required this.currentIndex, required this.onTap, super.key,
  });
  final int currentIndex;
  final Function(int) onTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                icon: Iconsax.home_15,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              NavBarItem(
                icon: Icons.search,
                label: 'Explore',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              NavBarItem(
                icon: Iconsax.shopping_bag5,
                label: 'MarketPlace',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              NavBarItem(
                icon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
                isProfile: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
