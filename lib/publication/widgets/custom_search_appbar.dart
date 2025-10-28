import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/publication/views/explore_history_page.dart';

class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSearchAppBar({
    required this.controller,
    this.onCancel,
    this.hintText = 'Search',
    this.onChanged,
    this.showCancel = true,
    this.navigateOnTap = true,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback? onCancel;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool showCancel;
  final bool navigateOnTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E7E7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20,
                      color: Color(0xFF687684),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (navigateOnTap) {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    const ExploreHistoryPage(),
                              ),
                            );
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: controller,
                            onChanged: onChanged,
                            style: GoogleFonts.aBeeZee(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF687684),
                              letterSpacing: -0.4,
                            ),
                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: const TextStyle(
                                fontSize: 17,
                                color: Color(0xFF687684),
                                letterSpacing: -0.4,
                              ),
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showCancel) ...[
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onCancel,
                child: Text(
                  'Cancel',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF49454F),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
