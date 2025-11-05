import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {

  const MessagesAppBar({
    required this.title,
    required this.onBackPressed,
    super.key,
    this.backgroundColor = Colors.white,
  });

  final String title;
  final VoidCallback onBackPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0, // Flat design for Figma look
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new, // Thicker back arrow for bold effect
          color: Colors.black87,
          size: 30, // Larger size for prominence
          weight: 900, // Maximum boldness
        ),
        onPressed: onBackPressed, // Navigate back
      ),
      title: Text(
        title,
        style: GoogleFonts.jua(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold, // Bold title
        ),
      ),
      centerTitle: false, // Title aligned to the left
      titleSpacing: 0, // Remove extra spacing around title
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
