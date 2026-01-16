import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryBar extends StatelessWidget {
  const StoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 10, // Mock data
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildYourStory();
          }
          return _buildStoryItem(index);
        },
      ),
    );
  }

  Widget _buildYourStory() {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(
                    'assets/images/onboarding_welcome.png',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1313EC),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.add, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Your story',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(int index) {
    final hasStory = index % 3 != 0; // Mock logic for who has stories

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasStory
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF833AB4),
                        Color(0xFFE1306C),
                        Color(0xFFFD1D1D),
                        Color(0xFFF77737),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              border: !hasStory
                  ? Border.all(color: Colors.grey[300]!, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                'https://picsum.photos/200/200?random=$index',
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'User $index',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
