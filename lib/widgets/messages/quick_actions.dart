import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/create_group_chat_screen.dart';
import '../../screens/select_contacts_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'New Message',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildActionItem(
            icon: Icons.person,
            title: 'Send Message',
            subtitle: 'Start a conversation with someone',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectContactsScreen(
                    title: 'Send Message',
                    allowMultiple: false,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            icon: Icons.group,
            title: 'Create Group',
            subtitle: 'Start a group conversation',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateGroupChatScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            icon: Icons.campaign,
            title: 'Create Channel',
            subtitle: 'Broadcast messages to followers',
            onTap: () {
              Navigator.pop(context);
              // Navigate to create channel screen
            },
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            icon: Icons.qr_code,
            title: 'Scan QR Code',
            subtitle: 'Connect by scanning a QR code',
            onTap: () {
              Navigator.pop(context);
              // Implement QR code scanner
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1313EC).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF1313EC), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
