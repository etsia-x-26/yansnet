import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yansnet/publication/cubit/publication_cubit.dart';
import 'package:yansnet/publication/cubit/publication_state.dart';
import 'package:yansnet/publication/widgets/add_button.dart';
import 'package:yansnet/subscription/widgets/home/post_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PublicationCubit>().fetchPosts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            _isLoadingMore = false;
            await context.read<PublicationCubit>().fetchPosts(refresh: true);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollEndNotification) {
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent * 0.9) {
                  final state = context.read<PublicationCubit>().state;
                  final isNotLoadingAndHasMore = state.maybeWhen(
                    loaded: (data) => !data.last,
                    orElse: () => false,
                  );

                  if (!_isLoadingMore && isNotLoadingAndHasMore) {
                    _isLoadingMore = true;
                    context.read<PublicationCubit>().fetchPosts().then((_) {
                      _isLoadingMore = false;
                    });
                  }
                }
              }
              return true;
            },
            child: BlocBuilder<PublicationCubit, PublicationState>(
              builder: (context, state) {
                return state.maybeWhen(
                  initial: () => const _LoadingIndicator(),
                  loading: () => const _LoadingIndicator(),
                  fetchingMore: () => _buildPublicationsList(state),
                  loaded: (data) => _buildPublicationsList(state),
                  created: (publication) => const SizedBox(),
                  error: (message) => _ErrorView(
                    message: message,
                    onRetry: () {
                      _isLoadingMore = false;
                      context
                          .read<PublicationCubit>()
                          .fetchPosts(refresh: true);
                    },
                  ),
                  orElse: () {
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ),
        floatingActionButton: const AddButton(),);
  }

  Widget _buildPublicationsList(PublicationState state) {
    return state.maybeWhen(
      loaded: (data) {
        if (data.content.isEmpty) {
          return const _EmptyView();
        }

        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: data.content.length + 1,
          itemBuilder: (context, index) {
            if (index == data.content.length) {
              return data.last
                  ? const SizedBox()
                  : const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
            }

            final publication = data.content[index];
            return PostItem(
              username: 'John Doe',
              displayName: 'John Doe',
              content: publication.content,
              time: publication.createdAt.toString().substring(0, 19),
              likes: publication.totalLikes,
              comments: publication.totalComments,
              imageUrl:
                  'https://i.pinimg.com/474x/e4/29/69/e429697f201ade295adfdc189d656047.jpg',
            );
          },
        );
      },
      orElse: () => const _LoadingIndicator(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No publications yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
