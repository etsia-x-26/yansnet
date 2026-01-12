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
                  _buildStatsSection(provider),
                  const SizedBox(height: 24),
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

  Widget _buildStatsSection(NetworkProvider provider) {
    if (provider.stats == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Connections', provider.stats!.connectionsCount.toString()),
          _buildStatItem('Contacts', provider.stats!.contactsCount.toString()),
          _buildStatItem('Channels', provider.stats!.channelsCount.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1313EC),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
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
                    : const AssetImage('assets/images/onboarding_welcome.png') as ImageProvider,
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
                  try {
                    final success = await provider.connectUser(suggestion.user.id.toString());
                    if (context.mounted) {
                      if (success) {
                        DialogUtils.showSuccess(context, 'Connection request sent to ${suggestion.user.name}');
                      } else {
                        DialogUtils.showError(context, 'Failed to send request');
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                       DialogUtils.showError(context, ErrorHandler.getErrorMessage(e));
                    }
                  }
                },
                child: const Text('Connect'),
              ),
            ],
          ),
        );
      },
    );
  }
}
