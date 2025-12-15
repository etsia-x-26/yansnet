import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yansnet/publication/cubit/publication_cubit.dart';
import 'package:yansnet/publication/cubit/publication_state.dart';
import 'package:yansnet/publication/widgets/add_button.dart';
import 'package:yansnet/publication/widgets/home/post_item.dart';
import 'package:yansnet/publication/widgets/home/post_skeleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Charger les posts au démarrage
    context.read<PublicationCubit>().fetchPosts(refresh: true);

    // Écouter le scroll pour la pagination infinie
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final cubit = context.read<PublicationCubit>();
      final state = cubit.state;

      // Charger plus de posts si on n'est pas déjà en train de charger
      state.maybeWhen(
        loaded: (data) {
          if (!data.last) {
            cubit.fetchPosts(refresh: false);
          }
        },
        orElse: () {},
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AddButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: BlocConsumer<PublicationCubit, PublicationState>(
          listener: (context, state) {
            // Afficher un snackbar en cas d'erreur
            state.maybeWhen(
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'Retry',
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<PublicationCubit>().fetchPosts(refresh: true);
                      },
                    ),
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: Text('Pull to refresh'),
              ),
              loading: () => RefreshIndicator(
                onRefresh: () async {
                  await context.read<PublicationCubit>().fetchPosts(refresh: true);
                },
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => const PostSkeleton(),
                ),
              ),
              loaded: (publicationResponse) {
                if (publicationResponse.content.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<PublicationCubit>().fetchPosts(refresh: true);
                    },
                    child: ListView(
                      children: const [
                        SizedBox(height: 200),
                        Center(child: Text('No posts yet')),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<PublicationCubit>().fetchPosts(refresh: true);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: publicationResponse.content.length +
                        (publicationResponse.last ? 0 : 1),
                    itemBuilder: (context, index) {
                      // Afficher un loader en bas si ce n'est pas la dernière page
                      if (index >= publicationResponse.content.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final post = publicationResponse.content[index];
                      final postDate =
                          '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}';
                      final postTime =
                          '${post.createdAt.hour.toString().padLeft(2, '0')}:'
                          '${post.createdAt.minute.toString().padLeft(2, '0')}';

                      return PostItem(
                        username: post.user.email ?? post.user.id?.toString() ?? 'user_${post.id}',
                        displayName: post.user.email?.split('@').first ?? 'User ${post.id}',
                        content: post.content,
                        imageUrl: post.media.isNotEmpty ? post.media.first : null,
                        time: '$postTime - $postDate',
                        likes: post.totalLikes,
                        comments: post.totalComments,
                      );
                    },
                  ),
                );
              },
              fetchingMore: () {
                // Afficher les posts existants avec un loader en bas
                final currentState = context.read<PublicationCubit>().state;
                return currentState.maybeWhen(
                  loaded: (publicationResponse) {
                    if (publicationResponse.content.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await context.read<PublicationCubit>().fetchPosts(refresh: true);
                        },
                        child: ListView(
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text('No posts yet')),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<PublicationCubit>().fetchPosts(refresh: true);
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: publicationResponse.content.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= publicationResponse.content.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final post = publicationResponse.content[index];
                          final postDate =
                              '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}';
                          final postTime =
                              '${post.createdAt.hour.toString().padLeft(2, '0')}:'
                              '${post.createdAt.minute.toString().padLeft(2, '0')}';

                          return PostItem(
                            username: post.user.email ?? post.user.id?.toString() ?? 'user_${post.id}',
                            displayName: post.user.email?.split('@').first ?? 'User ${post.id}',
                            content: post.content,
                            imageUrl: post.media.isNotEmpty ? post.media.first : null,
                            time: '$postTime - $postDate',
                            likes: post.totalLikes,
                            comments: post.totalComments,
                          );
                        },
                      ),
                    );
                  },
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              success: () => const Center(
                child: Text('Post created successfully'),
              ),
              created: (publication) => const Center(
                child: Text('Post created successfully'),
              ),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<PublicationCubit>().fetchPosts(refresh: true);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}