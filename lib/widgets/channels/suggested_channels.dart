import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestedChannels extends StatelessWidget {
  const SuggestedChannels({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.recommend, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Suggested for you',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _suggestedChannels.length,
              itemBuilder: (context, index) {
                final channel = _suggestedChannels[index];
                return _buildSuggestedChannelCard(context, channel);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedChannelCard(
    BuildContext context,
    Map<String, dynamic> channel,
  ) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openChannel(context, channel),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    image: channel['imageUrl'] != null
                        ? DecorationImage(
                            image: NetworkImage(channel['imageUrl']),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: channel['imageUrl'] == null
                      ? Icon(Icons.campaign, size: 30, color: Colors.grey[600])
                      : null,
                ),
                const SizedBox(height: 8),
                Text(
                  channel['name'],
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatFollowerCount(channel['followersCount'])} followers',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _followChannel(context, channel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1313EC),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Follow',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatFollowerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _openChannel(BuildContext context, Map<String, dynamic> channel) {
    // Navigate to channel detail
  }

  void _followChannel(BuildContext context, Map<String, dynamic> channel) {
    // Follow the channel
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Following ${channel['name']}',
          style: GoogleFonts.plusJakartaSans(),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  static final List<Map<String, dynamic>> _suggestedChannels = [
    {
      'id': 1,
      'name': 'Flutter Dev',
      'imageUrl': 'https://picsum.photos/200/200?random=1',
      'followersCount': 15420,
      'description': 'Flutter development tips and tricks',
    },
    {
      'id': 2,
      'name': 'Tech News',
      'imageUrl': 'https://picsum.photos/200/200?random=2',
      'followersCount': 8750,
      'description': 'Latest technology news and updates',
    },
    {
      'id': 3,
      'name': 'Design Hub',
      'imageUrl': 'https://picsum.photos/200/200?random=3',
      'followersCount': 12300,
      'description': 'UI/UX design inspiration',
    },
    {
      'id': 4,
      'name': 'Startup Life',
      'imageUrl': 'https://picsum.photos/200/200?random=4',
      'followersCount': 6890,
      'description': 'Entrepreneurship and startup stories',
    },
    {
      'id': 5,
      'name': 'AI & ML',
      'imageUrl': 'https://picsum.photos/200/200?random=5',
      'followersCount': 22100,
      'description': 'Artificial Intelligence and Machine Learning',
    },
  ];
}
