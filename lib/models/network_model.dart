import 'user_model.dart';

class NetworkStatsModel {
  final int connectionsCount;
  final int contactsCount;
  final int channelsCount;

  NetworkStatsModel({
    required this.connectionsCount,
    required this.contactsCount,
    required this.channelsCount,
  });

  factory NetworkStatsModel.fromJson(Map<String, dynamic> json) {
    return NetworkStatsModel(
      connectionsCount: json['connectionsCount'] ?? 0,
      contactsCount: json['contactsCount'] ?? 0,
      channelsCount: json['channelsCount'] ?? 0,
    );
  }
}

class NetworkSuggestionModel {
  final User user;
  final int mutualConnectionsCount;
  final String reason;

  NetworkSuggestionModel({
    required this.user,
    required this.mutualConnectionsCount,
    required this.reason,
  });

  factory NetworkSuggestionModel.fromJson(Map<String, dynamic> json) {
    return NetworkSuggestionModel(
      user: User.fromJson(json['user']),
      mutualConnectionsCount: json['mutualConnectionsCount'] ?? 0,
      reason: json['reason'] ?? '',
    );
  }
}
