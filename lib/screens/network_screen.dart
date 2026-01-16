import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/network/presentation/providers/network_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../core/error/error_handler.dart';
import '../core/utils/dialog_utils.dart';
import 'search_screen.dart';

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
      backgroundColor: const Color(0xFFF4F7FE), // Slightly softer blue-grey background
      appBar: AppBar(
        title: Text(
          'My Network',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1D1E),
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search_rounded, color: Color(0xFF1A1D1E), size: 22),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen(initialIndex: 1)));
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<NetworkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.stats == null) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1313EC)));
          }

          if (provider.error != null && provider.stats == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                     padding: const EdgeInsets.all(24),
                     decoration: BoxDecoration(
                       color: Colors.red.withOpacity(0.05),
                       shape: BoxShape.circle,
                     ),
                     child: Icon(Icons.error_outline_rounded, size: 48, color: Colors.red[300]),
                   ),
                   const SizedBox(height: 24),
                   Text('Something went wrong', 
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF1A1D1E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                   const SizedBox(height: 8),
                   Text('We couldn\'t load your network data', 
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 14)),
                   const SizedBox(height: 24),
                   ElevatedButton(
                    onPressed: () {
                      final userId = context.read<AuthProvider>().currentUser?.id;
                      if (userId != null) context.read<NetworkProvider>().loadNetworkData(userId);
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1313EC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Retry', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold))
                  )
                ],
              )
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<AuthProvider>().currentUser?.id;
              if (userId != null) {
                await provider.loadNetworkData(userId, silent: true);
              }
            },
            color: const Color(0xFF1313EC),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsSection(provider),
                        const SizedBox(height: 36),
                        Row(
                          children: [
                            Text(
                              'People you may know',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1D1E),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'See all',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1313EC),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSuggestionsList(provider),
                         const SizedBox(height: 32), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(NetworkProvider provider) {
    if (provider.stats == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1313EC).withOpacity(0.04), 
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('Connections', provider.stats!.connectionsCount.toString(), Icons.people_alt_rounded),
          _buildDivider(),
          _buildStatItem('Contacts', provider.stats!.contactsCount.toString(), Icons.contact_phone_rounded),
          _buildDivider(),
          _buildStatItem('Channels', provider.stats!.channelsCount.toString(), Icons.hub_rounded),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.withOpacity(0),
            Colors.grey.withOpacity(0.15),
            Colors.grey.withOpacity(0),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1313EC).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF1313EC)),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1D1E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList(NetworkProvider provider) {
    if (provider.suggestions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(24),
           border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add_disabled_rounded, size: 40, color: Colors.grey[300]),
            ),
            const SizedBox(height: 20),
            Text(
              'No suggestions for now',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1A1D1E), 
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for more people to connect with.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.suggestions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final suggestion = provider.suggestions[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
               BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ]
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Subtle background pattern or accent
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1313EC).withOpacity(0.03),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                           decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF1313EC).withOpacity(0.1), width: 3),
                           ),
                           child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey[50],
                            backgroundImage: suggestion.user.profilePictureUrl != null && suggestion.user.profilePictureUrl!.isNotEmpty
                                ? NetworkImage(suggestion.user.profilePictureUrl!)
                                : null,
                             child: suggestion.user.profilePictureUrl == null || suggestion.user.profilePictureUrl!.isEmpty
                              ? Text(
                                  suggestion.user.name.isNotEmpty ? suggestion.user.name[0].toUpperCase() : '?', 
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w800, 
                                    color: const Color(0xFF1313EC),
                                    fontSize: 20,
                                  )
                                )
                              : null,
                          ),
                        ),
                        if (suggestion.user.isMentor)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1313EC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion.user.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: const Color(0xFF1A1D1E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (suggestion.user.bio != null && suggestion.user.bio!.isNotEmpty)
                            Text(
                              suggestion.user.bio!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 8),
                          if (suggestion.mutualConnectionsCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1313EC).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                    const Icon(Icons.people_rounded, size: 12, color: Color(0xFF1313EC)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${suggestion.mutualConnectionsCount} mutual',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: const Color(0xFF1313EC),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                 ]
                              ),
                            )
                          else 
                             Text(
                              'Suggested for you',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final currentUser = context.read<AuthProvider>().currentUser;
                          if (currentUser != null) {
                            final success = await context.read<NetworkProvider>().followUser(currentUser.id, suggestion.user.id);
                            if (context.mounted) {
                              if (success) {
                                DialogUtils.showSuccess(context, 'Following ${suggestion.user.name}');
                              } else {
                                DialogUtils.showError(context, 'Failed to follow');
                              }
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                             DialogUtils.showError(context, ErrorHandler.getErrorMessage(e));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1313EC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text('Follow', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
