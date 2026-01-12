// lib/conversation/views/channels_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../api/channels_repository.dart';
import '../cubit/channels_cubit.dart';
import '../cubit/channels_state.dart';
import '../models/channel.dart';
import '../models/channel_filter.dart';
import 'channel_detail_page.dart';

class ChannelsPage extends StatelessWidget {
  const ChannelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChannelsCubit(
        repository: getIt<ChannelsRepository>(),
        currentUserId: 1, // TODO: Récupérer depuis AuthService
      )..loadChannels(),
      child: const _ChannelsPageContent(),
    );
  }
}

class _ChannelsPageContent extends StatefulWidget {
  const _ChannelsPageContent();

  @override
  State<_ChannelsPageContent> createState() => _ChannelsPageContentState();
}

class _ChannelsPageContentState extends State<_ChannelsPageContent> {
  ChannelFilter _selectedFilter = ChannelFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔍 Filtres des chaînes
          _buildFilters(context),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),

          // 📋 Liste des chaînes
          Expanded(
            child: BlocBuilder<ChannelsCubit, ChannelsState>(
              builder: (context, state) {
                // 🔄 Loading
                if (state is ChannelsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // ❌ Erreur
                if (state is ChannelsError) {
                  return _buildErrorWidget(context, state);
                }

                // ✅ Chargé avec succès
                if (state is ChannelsLoaded) {
                  return _buildChannelsList(context, state.channels);
                }

                // État initial ou inconnu
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateChannelDialog(context),
        backgroundColor: const Color(0xFF5D1A1A), // Couleur du bouton
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Toutes',
              filter: ChannelFilter.all,
              context: context,
            ),
            const SizedBox(width: 12),
            _buildFilterChip(
              label: 'Abonnées',
              filter: ChannelFilter.subscribed,
              context: context,
            ),
            const SizedBox(width: 12),
            _buildFilterChip(
              label: 'Populaires',
              filter: ChannelFilter.popular,
              context: context,
            ),
            const SizedBox(width: 12),
            _buildFilterChip(
              label: 'Récentes',
              filter: ChannelFilter.recent,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, ChannelsError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Erreur de chargement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton.icon(
            onPressed: () => context.read<ChannelsCubit>().refreshChannels(),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelsList(BuildContext context, List<Channel> channels) {
    if (channels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Aucune chaîne disponible', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ChannelsCubit>().refreshChannels(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return _buildChannelItem(context, channel);
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required ChannelFilter filter,
    required BuildContext context,
  }) {
    final isSelected = _selectedFilter == filter;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = filter);
          context.read<ChannelsCubit>().filterChannels(filter);
        }
      },
      selectedColor: const Color(0xFFD4F4DD),
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? const Color(0xFF075E54) : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildChannelItem(BuildContext context, Channel channel) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelDetailPage(channelId: channel.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: channel.avatar != null ? NetworkImage(channel.avatar!) : null,
              child: channel.avatar == null ? Text(channel.name?.substring(0, 1).toUpperCase() ?? '#') : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(channel.name ?? 'Sans nom', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(channel.description ?? 'Pas de description', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _toggleSubscription(context, channel),
              style: ElevatedButton.styleFrom(
                backgroundColor: channel.isSubscribed ? Colors.grey[300] : const Color(0xFF5D1A1A),
                foregroundColor: channel.isSubscribed ? Colors.black87 : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(channel.isSubscribed ? 'Abonné' : 'S\'abonner', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCreateChannelDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Créer une nouvelle chaîne'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nom de la chaîne', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un nom' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer une description' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await context.read<ChannelsCubit>().createChannel(
                          name: nameController.text,
                          description: descriptionController.text,
                        );
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  } catch (e) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSubscription(BuildContext context, Channel channel) {
    context.read<ChannelsCubit>().toggleSubscription(channel);
  }
}
