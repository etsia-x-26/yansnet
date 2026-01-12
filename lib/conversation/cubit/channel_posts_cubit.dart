// lib/conversation/cubit/channel_posts_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/channels_repository.dart';
import '../models/channel_post.dart';
import 'channels_state.dart';

class ChannelPostsCubit extends Cubit<ChannelPostsState> {
  final ChannelsRepository repository;
  final int channelId;
  final int currentUserId;

  int _currentPage = 0;
  static const int _pageSize = 20;

  ChannelPostsCubit({
    required this.repository,
    required this.channelId,
    required this.currentUserId,
  }) : super(ChannelPostsInitial());

  Future<void> loadPosts() async {
    try {
      emit(const ChannelPostsLoading());
      _currentPage = 0;
      final posts = await repository.getChannelPosts(
        channelId,
        page: _currentPage,
        size: _pageSize,
      );

      emit(ChannelPostsLoaded(
        posts: posts,
        hasMore: posts.length >= _pageSize,
      ));
    } catch (e) {
      emit(ChannelPostsError(e.toString()));
    }
  }

  Future<void> loadMorePosts() async {
    if (state is! ChannelPostsLoaded) return;

    final currentState = state as ChannelPostsLoaded;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));
      _currentPage++;
      final newPosts = await repository.getChannelPosts(
        channelId,
        page: _currentPage,
        size: _pageSize,
      );

      final allPosts = [...currentState.posts, ...newPosts];

      emit(ChannelPostsLoaded(
        posts: allPosts,
        hasMore: newPosts.length >= _pageSize,
        isLoadingMore: false,
      ));
    } catch (e) {
      // Garder l'état actuel en cas d'erreur
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> createPost(String content) async {
    try {
      final newPost = await repository.createPost(
        content: content,
        userId: currentUserId,
        channelId: channelId,
      );

      // Ajouter le post au début de la liste
      if (state is ChannelPostsLoaded) {
        final currentState = state as ChannelPostsLoaded;
        emit(currentState.copyWith(
          posts: [newPost, ...currentState.posts],
        ));
      } else {
        // Si pas de posts chargés, recharger
        await loadPosts();
      }
    } catch (e) {
      // Propager l'erreur pour l'UI
      rethrow;
    }
  }

  Future<void> updatePost({
    required int postId,
    required String content,
  }) async {
    if (state is! ChannelPostsLoaded) return;

    final currentState = state as ChannelPostsLoaded;

    try {
      final updatedPost = await repository.updatePost(
        postId: postId,
        content: content,
      );

      // Mettre à jour dans la liste
      final updatedPosts = currentState.posts.map((post) {
        return post.id == postId ? updatedPost : post;
      }).toList();

      emit(currentState.copyWith(posts: updatedPosts));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePost(int postId) async {
    if (state is! ChannelPostsLoaded) return;

    final currentState = state as ChannelPostsLoaded;

    try {
      await repository.deletePost(postId);

      // Retirer de la liste
      final updatedPosts = currentState.posts
          .where((post) => post.id != postId)
          .toList();

      emit(currentState.copyWith(posts: updatedPosts));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likePost(int postId) async {
    if (state is! ChannelPostsLoaded) return;

    final currentState = state as ChannelPostsLoaded;

    // Optimistic update
    final updatedPosts = currentState.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          likeCount: post.likeCount + 1,
          isLiked: true,
        );
      }
      return post;
    }).toList();

    emit(currentState.copyWith(posts: updatedPosts));

    try {
      // TODO: Appeler l'API quand disponible
      // await repository.reactToPost(
      //   channelId: channelId.toString(),
      //   postId: postId.toString(),
      //   emoji: '👍',
      // );
    } catch (e) {
      // Rollback en cas d'erreur
      emit(currentState);
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }
}
