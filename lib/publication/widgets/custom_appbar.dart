import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/app/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
    this.messageCount = 0,
    this.hasNotification = false,
  });
  final int messageCount;
  final bool hasNotification;

  @override
  Size get preferredSize => const Size.fromHeight(77);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      titleSpacing: 20,
      title: Text.rich(
        TextSpan(
          text: 'YansNet',
          style: GoogleFonts.jua(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: kPrimaryColor,
          ),
        ),
      ),
      actions: [

        // Notification Icon with red dot
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(
                  Icons.notifications_none,
                  color: kPrimaryColor
              ),
              onPressed: () {},
            ),
            if (hasNotification)
              Positioned(
                right: 15,
                top: 15,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB3261E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),

        // Message Icon with badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(
                  Icons.messenger_outline_rounded,
                  color: kPrimaryColor
              ),
              onPressed: () {},
            ),
            if (messageCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB3261E),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$messageCount',
                    style: GoogleFonts.alegreyaSans(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
