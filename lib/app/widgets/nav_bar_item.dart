import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yansnet/app/theme/app_theme.dart';

class NavBarItem extends StatelessWidget {
  
  const NavBarItem({
    required this.icon, required this.label, required this.isActive,
    required this.onTap, super.key,
    this.isProfile = false,
  });
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isProfile;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h,),
          if (isActive)
            Container(
              width: 64.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16.r),
                    right: Radius.circular(16.r),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            )
          else
            Icon(
              icon,
              color: Colors.grey,
              size: 24,
            ),
          const SizedBox(height: 4),
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? kPrimaryColor : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          // const SizedBox(height: 4),
          // Container(
          //   width: 24,
          //   height: 3,
          //   decoration: BoxDecoration(
          //     color: isActive ? kPrimaryColor : Colors.transparent,
          //     borderRadius: BorderRadius.circular(2),
          //   ),
          // ),

        ],
      ),
    );
  }
}
