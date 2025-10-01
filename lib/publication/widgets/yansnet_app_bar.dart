import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class YansnetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const YansnetAppBar({
    super.key,
    this.messageCount = 0,
    this.hasNotification = false,
  });
  final int messageCount;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'YansNet',
          style: TextStyle(
            fontFamily: GoogleFonts.jua().fontFamily,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            fontSize: 32,
            color: const Color(0xFF420C18),
          ),
        ),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 28),
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
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 24),
              onPressed: () {
                context.push('/messages');
              },
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
      forceMaterialTransparency: true,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
