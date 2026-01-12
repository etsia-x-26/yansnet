import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/channels/presentation/providers/channels_provider.dart';
import 'create_channel_screen.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChannelsProvider>().loadChannels();
    });
  }

  void _showCreateChannelDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Channel', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Channel Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                 final success = await context.read<ChannelsProvider>().createChannel(
                   titleController.text,
                   descriptionController.text,
                 );
                 if (mounted && success) {
                   Navigator.pop(context);
                 }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateChannelDialog,
        backgroundColor: const Color(0xFF1313EC),
        child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateChannelScreen()));
        },
        backgroundColor: const Color(0xFF1313EC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<ChannelsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.channels.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.error != null && provider.channels.isEmpty) {
             return Center(child: Text('Error: ${provider.error}'));
          }

          if (provider.channels.isEmpty) {
            return const Center(child: Text("No channels found. Create one!"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.channels.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final channel = provider.channels[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                     BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ]
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.tag, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            channel.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${channel.totalFollowers} followers',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (channel.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                             Text(
                              channel.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {}, // TODO: Implement Follow/Unfollow
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1313EC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Join'),
                      onPressed: () async {
                         final success = await provider.joinChannel(channel.id.toString());
                         if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(success ? 'Joined ${channel.title}' : 'Failed to join')),
                            );
                         }
                      },
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
