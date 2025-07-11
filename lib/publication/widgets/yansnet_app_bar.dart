import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'YansNet',
          style: TextStyle(
            fontFamily: GoogleFonts.jua().fontFamily,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
            fontSize: 32,
            height: 1,
            color: const Color(0xFF420C18),
          ),
        ),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              style: const ButtonStyle(
                iconColor: WidgetStatePropertyAll(Color(0xFF420C18)),
                iconSize: WidgetStatePropertyAll(24),
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
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/message-circle.png',
                      width: 21,
                      height: 21,
                      color: const Color(0xFF420C18),
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
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
