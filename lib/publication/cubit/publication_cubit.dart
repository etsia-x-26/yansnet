import 'package:bloc/bloc.dart';
import 'package:yansnet/publication/api/publication_client.dart';
import 'package:yansnet/publication/cubit/publication_state.dart';
import 'package:yansnet/publication/models/publication_response.dart';

class PublicationCubit extends Cubit<PublicationState> {
  PublicationCubit(this._client) : super(const PublicationState.initial());
  final PublicationClient _client;

  Future<void> createPost(String content) async {
    emit(const PublicationState.loading());

    try {
      await _client.createPost(content);
      emit(const PublicationState.success());
      // Recharger les posts après création
      await fetchPosts(refresh: true);
    } catch (e) {
      emit(PublicationState.error(e.toString()));
    }
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      emit(const PublicationState.loading());
    } else {
      // Vérifier si on a déjà des données avant d'émettre fetchingMore
      final hasData = state.maybeWhen(
        loaded: (_) => true,
        orElse: () => false,
      );

      if (hasData) {
        emit(const PublicationState.fetchingMore());
      } else {
        emit(const PublicationState.loading());
      }
    }

    try {
      final currentPage = state.maybeWhen(
        loaded: (data) => data.pageNumber + 1,
        orElse: () => 0,
      );

      final response = await _client.fetchPosts(
        page: refresh ? 0 : currentPage,
      );

      if (refresh || currentPage == 0) {
        emit(PublicationState.loaded(response));
      } else {
        final previousState = state.maybeWhen(
          loaded: (previousResponse) => previousResponse,
          orElse: () => null,
        );

        if (previousState != null) {
          final updatedContent = [
            ...previousState.content,
            ...response.content,
          ];

          emit(
            PublicationState.loaded(
              PublicationResponse(
                content: updatedContent,
                pageNumber: response.pageNumber,
                pageSize: response.pageSize,
                totalElements: response.totalElements,
                totalPages: response.totalPages,
                last: response.last,
              ),
            ),
          );
        } else {
          emit(PublicationState.loaded(response));
        }
      }
    } catch (e) {
      emit(PublicationState.error(e.toString()));
    }
  }
}