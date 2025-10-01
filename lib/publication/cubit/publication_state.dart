import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/publication_response.dart';

part 'publication_state.freezed.dart';

@freezed
class PublicationState with _$PublicationState {
  const factory PublicationState.initial() = _Initial;
  const factory PublicationState.loading() = _Loading;
  const factory PublicationState.success() = _Success;
  const factory PublicationState.fetchingMore() = _FetchingMore;
  const factory PublicationState.loaded(PublicationResponse data) = _Loaded;
  const factory PublicationState.created(Publication publication) = _Created;
  const factory PublicationState.error(String message) = _Error;
}
