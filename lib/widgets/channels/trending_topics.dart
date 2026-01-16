import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingTopics extends StatelessWidget {
  const TrendingTopics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _trendingTopics.length,
        itemBuilder: (context, index) {
          final topic = _trendingTopics[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _searchTopic(context, topic),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        topic,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _searchTopic(BuildContext context, String topic) {
    // Implement topic search
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Searching for "$topic"',
          style: GoogleFonts.plusJakartaSans(),
        ),
      ),
    );
  }

  static final List<String> _trendingTopics = [
    '#Flutter',
    '#Tech',
    '#Startup',
    '#AI',
    '#Design',
    '#Mobile',
    '#Web3',
    '#Innovation',
    '#Coding',
    '#Business',
  ];
}
