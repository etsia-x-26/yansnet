import '../../../auth/domain/auth_domain.dart';

class NetworkStats {
  final int connectionsCount;
  final int contactsCount;
  final int channelsCount;

  NetworkStats({
    required this.connectionsCount,
    required this.contactsCount,
    required this.channelsCount,
  });
}

class NetworkSuggestion {
  final User user;
  final int mutualConnectionsCount;
  final String reason;

  NetworkSuggestion({
    required this.user,
    required this.mutualConnectionsCount,
    required this.reason,
  });
}
