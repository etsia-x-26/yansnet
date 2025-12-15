import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yansnet/conversation/models/group.dart';

part 'groups_state.freezed.dart';

/// États possibles pour la gestion des groupes
@freezed
class GroupsState with _$GroupsState {
  /// État initial - aucune donnée chargée
  const factory GroupsState.initial() = _Initial;

  /// État de chargement - requête en cours
  const factory GroupsState.loading() = _Loading;

  /// État succès - groupes chargés
  const factory GroupsState.loaded(List<Group> groups) = _Loaded;

  /// État erreur - échec du chargement
  const factory GroupsState.error(String message) = _Error;
}