import 'package:bloc/bloc.dart';
import 'package:yansnet/conversation/api/groups_client.dart';
import 'package:yansnet/conversation/cubit/groups_state.dart';

/// Cubit gérant l'état et la logique des groupes de conversation
class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit({required GroupsClient groupsClient})
      : _groupsClient = groupsClient,
        super(const GroupsState.initial());

  final GroupsClient _groupsClient;

  /// Charge la liste des groupes depuis le backend
  ///
  /// Émet [GroupsState.loading] pendant le chargement
  /// Émet [GroupsState.loaded] en cas de succès
  /// Émet [GroupsState.error] en cas d'échec
  Future<void> loadGroups() async {
    emit(const GroupsState.loading());

    try {
      final groups = await _groupsClient.getGroups();
      emit(GroupsState.loaded(groups));
    } catch (e) {
      emit(GroupsState.error(e.toString()));
    }
  }

  /// Recharge les groupes (pour pull-to-refresh)
  ///
  /// Ne passe pas par l'état loading pour éviter de cacher le contenu
  /// pendant le refresh
  Future<void> refreshGroups() async {
    try {
      final groups = await _groupsClient.getGroups();
      emit(GroupsState.loaded(groups));
    } catch (e) {
      // En cas d'erreur pendant le refresh, on émet l'erreur
      // L'UI peut afficher un Snackbar sans perdre les données affichées
      emit(GroupsState.error(e.toString()));
    }
  }

  /// Réinitialise l'état à initial
  void reset() {
    emit(const GroupsState.initial());
  }
}