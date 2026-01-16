import '../../domain/repositories/network_repository.dart';
import '../../domain/entities/network_entity.dart';
import '../datasources/network_remote_data_source.dart';
import '../../../auth/domain/auth_domain.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkRemoteDataSource remoteDataSource;

  NetworkRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkStats> getNetworkStats(int userId) async {
    final model = await remoteDataSource.getNetworkStats(userId);
    return NetworkStats(
      connectionsCount: model.connectionsCount,
      contactsCount: model.contactsCount,
      channelsCount: model.channelsCount,
    );
  }

  @override
  Future<List<NetworkSuggestion>> getNetworkSuggestions(int userId) async {
    final models = await remoteDataSource.getNetworkSuggestions(userId);
    return models
        .map(
          (model) => NetworkSuggestion(
            user: User(
              id: model.user.id,
              email: model.user.email,
              name: model.user.name,
              username: model.user.username,
              bio: model.user.bio,
              profilePictureUrl: model.user.profilePictureUrl,
              isMentor: model.user.isMentor,
            ),
            mutualConnectionsCount: model.mutualConnectionsCount,
            reason: model.reason,
          ),
        )
        .toList();
  }

  @override
  Future<bool> sendConnectionRequest(int fromUserId, int toUserId) async {
    return await remoteDataSource.sendConnectionRequest(fromUserId, toUserId);
  }

  @override
  Future<bool> disconnectUser(int fromUserId, int toUserId) async {
    return await remoteDataSource.disconnectUser(fromUserId, toUserId);
  }

  @override
  Future<bool> acceptConnectionRequest(int requestId) async {
    return await remoteDataSource.acceptConnectionRequest(requestId);
  }

  @override
  Future<bool> rejectConnectionRequest(int requestId) async {
    return await remoteDataSource.rejectConnectionRequest(requestId);
  }
}
