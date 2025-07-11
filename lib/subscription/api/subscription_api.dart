import 'package:dio/dio.dart';
import 'package:yansnet/core/network/dio.dart';
import 'package:yansnet/subscription/models/channel.dart';

class SubscriptionAPI {
  //final Dio dio = Dio();

  Future<dynamic> getChannels() async {
    final response = await http.get('$apiBaseUrl/api/channels');
    return response.data;
  }

  Future<dynamic> createChannel(String title, String description) async {
    final response = await http.post(
      '$apiBaseUrl/api/channels',
      data: {
        'title': title,
        'description': description,
      },
    );
    return response.data;
  }

  Future<dynamic> getGroups() async {
    final response = await http.get('$apiBaseUrl/api/groups');
    return response.data;
  }

  Future<dynamic> createGroup(String title, String description) async {
    final response = await http.post(
      '$apiBaseUrl/api/groups',
      data: {
        'title': title,
        'description': description,
      },
    );
    return response.data;
  }

  Future<dynamic> getUsers() async {
    final response = await http.get('$apiBaseUrl/api/users');
    return response.data;
  }

  Future<dynamic> followUser(int followerId, int followedId) async {
    final response = await http.post(
      '$apiBaseUrl/follow/$followerId/$followedId',
    );
    return response.data;
  }

  Future<dynamic> unFollowerUser(int followerId, int followedId) async {
    final response = await http.delete(
      '$apiBaseUrl/follow/unfollow/$followerId/$followedId',
    );
    return response.data;
  }

  Future<dynamic> followChannel(int channelId, int followerId) async {
    final response = await http.post(
      '$apiBaseUrl/channelFollow/follow/$channelId/$followerId',
    );
    return response.data;
  }

  Future<dynamic> unFollowerChannel(int channelId, int followerId) async {
    final response = await http.delete(
      '$apiBaseUrl/channelFollow/unfollow/$channelId/$followerId',
    );
    return response.data;
  }

  Future<dynamic> sendPrivateMessage() async {
    final response = await http.get('$apiBaseUrl/');
    return response.data;
  }

  Future<dynamic> sendGroupMessage() async {
    final response = await http.get('$apiBaseUrl/');
    return response.data;
  }
}
