import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/channels_repository.dart';
import '../cubit/channel_detail_cubit.dart';
import '../cubit/channel_posts_cubit.dart';
import '../cubit/channels_state.dart';
import '../../core/di/injection.dart';

class ChannelDetailPage extends StatelessWidget {
  final int channelId;

  const ChannelDetailPage({
    super.key,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChannelDetailCubit(
            repository: getIt<ChannelsRepository>(),
            channelId: channelId,
            currentUserId: 1, // TODO: Récupérer depuis l'auth
          )..loadChannelDetail(),
        ),
        BlocProvider(
          create: (context) => ChannelPostsCubit(
            repository: getIt<ChannelsRepository>(),
            channelId: channelId,
            currentUserId: 1, // TODO: Récupérer depuis l'auth
          )..loadPosts(),
        ),
      ],
      child: const _ChannelDetailView(),
    );
  }
}

class _ChannelDetailView extends StatelessWidget {
  const _ChannelDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 📱 Header avec infos du channel
          BlocBuilder<ChannelDetailCubit, ChannelDetailState>(
            builder: (context, state) {
              if (state is ChannelDetailLoaded) {
                final channel = state.channel;

                return SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(channel.name ?? 'Channel'),
                    background: channel.avatar != null
                        ? Image.network(
                      channel.avatar!,
                      fit: BoxFit.cover,
                    )
                        : Container(color: Colors.blue),
                  ),
                  actions: [
                    // 👍 Bouton Follow/Unfollow
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: state.isFollowLoading
                            ? null
                            : () => context
                            .read<ChannelDetailCubit>()
                            .toggleSubscription(),
                        icon: Icon(
                          state.isSubscribed ? Icons.check : Icons.add,
                        ),
                        label: Text(
                          state.isSubscribed ? 'Abonné' : 'S\'abonner',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          state.isSubscribed ? Colors.grey : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.people,
                            label: 'Abonnés',
                            value: '${channel.subscriberCount}',
                          ),
                          // TODO: Ajouter d'autres stats
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SliverAppBar(
                title: Text('Chargement...'),
              );
            },
          ),

          // 📝 Liste des posts
          BlocBuilder<ChannelPostsCubit, ChannelPostsState>(
            builder: (context, state) {
              if (state is ChannelPostsLoading && !state.isLoadingMore) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is ChannelPostsError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Erreur: ${state.message}'),
                  ),
                );
              }

              if (state is ChannelPostsLoaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index == state.posts.length) {
                        // Dernier élément : bouton load more
                        if (state.hasMore) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: state.isLoadingMore
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                onPressed: () => context
                                    .read<ChannelPostsCubit>()
                                    .loadMorePosts(),
                                child: const Text('Charger plus'),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }

                      final post = state.posts[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.user?.name ?? 'Anonyme',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(post.content ?? ''),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.thumb_up_outlined),
                                    onPressed: () => context
                                        .read<ChannelPostsCubit>()
                                        .likePost(post.id),
                                  ),
                                  Text('${post.likeCount}'),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(Icons.comment_outlined),
                                    onPressed: () {},
                                  ),
                                  Text('${post.commentCount}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: state.posts.length + 1,
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(child: Text('Aucun post')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nouveau post'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Quoi de neuf ?',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;

              try {
                await context.read<ChannelPostsCubit>().createPost(
                  controller.text,
                );
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            },
            child: const Text('Publier'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
