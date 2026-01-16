import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChannelCard extends StatelessWidget {
  final dynamic channel; // Replace with your Channel model
  final VoidCallback onTap;
  final VoidCallback onFollow;
  final bool showOwnerActions;

  const ChannelCard({
    super.key,
    required this.channel,
    required this.onTap,
    required this.onFollow,
    this.showOwnerActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildChannelAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  channel.name ?? 'Channel Name',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (channel.isVerified == true)
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: Color(0xFF1313EC),
                                  ),
                                ),
                              if (channel.isPrivate == true)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.lock,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_formatFollowerCount(channel.followersCount ?? 0)} followers',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!showOwnerActions)
                      _buildFollowButton()
                    else
                      _buildOwnerActions(context),
                  ],
                ),
                if (channel.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Text(
                    channel.description!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                _buildChannelStats(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChannelAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        image: channel.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(channel.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: channel.imageUrl == null
          ? Icon(Icons.campaign, size: 24, color: Colors.grey[600])
          : null,
    );
  }

  Widget _buildFollowButton() {
    final isFollowing = channel.isFollowing ?? false;

    return ElevatedButton(
      onPressed: onFollow,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing
            ? Colors.grey[200]
            : const Color(0xFF1313EC),
        foregroundColor: isFollowing ? Colors.grey[700] : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: Text(
        isFollowing ? 'Following' : 'Follow',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOwnerActions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _editChannel(context);
            break;
          case 'analytics':
            _showAnalytics(context);
            break;
          case 'settings':
            _showChannelSettings(context);
            break;
          case 'delete':
            _deleteChannel(context);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit, size: 18),
              const SizedBox(width: 8),
              Text('Edit', style: GoogleFonts.plusJakartaSans()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'analytics',
          child: Row(
            children: [
              const Icon(Icons.analytics, size: 18),
              const SizedBox(width: 8),
              Text('Analytics', style: GoogleFonts.plusJakartaSans()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.settings, size: 18),
              const SizedBox(width: 8),
              Text('Settings', style: GoogleFonts.plusJakartaSans()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 18, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Delete',
                style: GoogleFonts.plusJakartaSans(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChannelStats() {
    return Row(
      children: [
        _buildStatItem(
          Icons.message,
          '${channel.messagesCount ?? 0}',
          'messages',
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          Icons.visibility,
          '${_formatViewCount(channel.viewsCount ?? 0)}',
          'views',
        ),
        const SizedBox(width: 16),
        _buildStatItem(Icons.schedule, _getLastActiveText(), 'last active'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
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

  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _getLastActiveText() {
    // Mock implementation - replace with actual last active logic
    return '2h ago';
  }

  void _editChannel(BuildContext context) {
    // Navigate to edit channel screen
  }

  void _showAnalytics(BuildContext context) {
    // Show channel analytics
  }

  void _showChannelSettings(BuildContext context) {
    // Show channel settings
  }

  void _deleteChannel(BuildContext context) {
    // Show delete confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Channel',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this channel? This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement delete logic
            },
            child: Text(
              'Delete',
              style: GoogleFonts.plusJakartaSans(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
