import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/network/presentation/providers/network_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../core/error/error_handler.dart';
import '../core/utils/dialog_utils.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().currentUser?.id;
      if (userId != null) {
        context.read<NetworkProvider>().loadNetworkData(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Network',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<NetworkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<AuthProvider>().currentUser?.id;
              if (userId != null) {
                await provider.loadNetworkData(userId);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'People you may know',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSuggestionsList(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestionsList(NetworkProvider provider) {
    if (provider.suggestions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No suggestions for now',
            style: GoogleFonts.plusJakartaSans(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.suggestions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final suggestion = provider.suggestions[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: suggestion.user.profilePictureUrl != null
                    ? NetworkImage(suggestion.user.profilePictureUrl!)
                    : const AssetImage('assets/images/onboarding_welcome.png')
                          as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.user.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      suggestion.reason,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (suggestion.mutualConnectionsCount > 0)
                      Text(
                        '${suggestion.mutualConnectionsCount} mutual connections',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF1313EC),
                        ),
                      ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final currentUserId = context
                      .read<AuthProvider>()
                      .currentUser
                      ?.id;
                  if (currentUserId == null) {
                    if (context.mounted) {
                      DialogUtils.showError(
                        context,
                        'Please login to connect with users',
                      );
                    }
                    return;
                  }

                  try {
                    final isConnected = provider.isUserConnected(
                      suggestion.user.id,
                    );

                    if (isConnected) {
                      // Disconnect
                      final success = await provider.disconnectUser(
                        currentUserId,
                        suggestion.user.id,
                      );
                      if (context.mounted) {
                        if (success) {
                          DialogUtils.showSuccess(
                            context,
                            'Disconnected from ${suggestion.user.name}',
                          );
                        } else {
                          DialogUtils.showError(
                            context,
                            'Failed to disconnect',
                          );
                        }
                      }
                    } else {
                      // Connect
                      final success = await provider.connectUser(
                        currentUserId,
                        suggestion.user.id,
                      );
                      if (context.mounted) {
                        if (success) {
                          DialogUtils.showSuccess(
                            context,
                            'Connected to ${suggestion.user.name}',
                          );
                        } else {
                          DialogUtils.showError(context, 'Failed to connect');
                        }
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      DialogUtils.showError(
                        context,
                        ErrorHandler.getErrorMessage(e),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: provider.isUserConnected(suggestion.user.id)
                      ? Colors.grey[300]
                      : const Color(0xFF1313EC),
                  foregroundColor: provider.isUserConnected(suggestion.user.id)
                      ? Colors.grey[700]
                      : Colors.white,
                ),
                child: Text(
                  provider.isUserConnected(suggestion.user.id)
                      ? 'Disconnect'
                      : 'Connect',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
