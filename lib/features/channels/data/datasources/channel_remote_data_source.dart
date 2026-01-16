import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/channel_entity.dart';
import '../models/channel_dto.dart';

abstract class ChannelRemoteDataSource {
  Future<List<Channel>> getChannels();
  Future<Channel> createChannel(String title, String description);
  Future<Channel> getChannel(int channelId);
  Future<void> followChannel(int channelId, int followerId);
  Future<void> unfollowChannel(int channelId, int followerId);
}

class ChannelRemoteDataSourceImpl implements ChannelRemoteDataSource {
  final ApiClient apiClient;

  ChannelRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Channel>> getChannels() async {
    print('📥 Loading channels from API...');

    // Try /api/channel first, then /channel as fallback
    final endpoints = ['/api/channel', '/channel'];

    for (final endpoint in endpoints) {
      try {
        print('🌐 Trying endpoint: $endpoint');
        final response = await apiClient.dio.get(endpoint);
        print('🔍 GET $endpoint response: ${response.data}');

        final List data = response.data is List ? response.data : [];
        print('✅ Found ${data.length} channels with $endpoint');

        return data.map((e) => ChannelDto.fromJson(e).toEntity()).toList();
      } catch (e) {
        print('❌ Error with $endpoint: $e');
        // If this is the last endpoint, rethrow
        if (endpoint == endpoints.last) {
          rethrow;
        }
        // Otherwise, try next endpoint
        print('🔄 Trying next endpoint...');
      }
    }

    return [];
  }

  @override
  Future<Channel> createChannel(String title, String description) async {
    print('🆕 Creating channel: $title');

    final payload = {'title': title, 'description': description};
    print('📤 Payload: $payload');

    // Try /api/channel first, then /channel as fallback
    final endpoints = ['/api/channel', '/channel'];

    for (final endpoint in endpoints) {
      try {
        print('🌐 Base URL: ${apiClient.dio.options.baseUrl}');
        print('🌐 Trying endpoint: $endpoint');
        print('🌐 Full URL: ${apiClient.dio.options.baseUrl}$endpoint');

        final response = await apiClient.dio.post(endpoint, data: payload);
        print('✅ Channel created successfully with $endpoint!');
        print('🔍 Response: ${response.data}');

        return ChannelDto.fromJson(response.data).toEntity();
      } catch (e) {
        print('❌ Error with $endpoint: $e');
        if (e is DioException) {
          print('❌ Error type: ${e.type}');
          print('❌ Error message: ${e.message}');
          print('❌ Request full URL: ${e.requestOptions.uri}');
          print('❌ Response data: ${e.response?.data}');
          print('❌ Status code: ${e.response?.statusCode}');

          // If this is the last endpoint, rethrow
          if (endpoint == endpoints.last) {
            rethrow;
          }
          // Otherwise, try next endpoint
          print('🔄 Trying next endpoint...');
        } else {
          rethrow;
        }
      }
    }

    throw Exception('Failed to create channel with all endpoints');
  }

  @override
  Future<Channel> getChannel(int channelId) async {
    print('📥 Loading channel $channelId...');

    // Try /api/channel first, then /channel as fallback
    final endpoints = ['/api/channel/$channelId', '/channel/$channelId'];

    for (final endpoint in endpoints) {
      try {
        print('🌐 Trying endpoint: $endpoint');
        final response = await apiClient.dio.get(endpoint);
        print('✅ Channel loaded with $endpoint: ${response.data}');

        return ChannelDto.fromJson(response.data).toEntity();
      } catch (e) {
        print('❌ Error with $endpoint: $e');
        // If this is the last endpoint, rethrow
        if (endpoint == endpoints.last) {
          rethrow;
        }
        // Otherwise, try next endpoint
        print('🔄 Trying next endpoint...');
      }
    }

    throw Exception('Failed to load channel with all endpoints');
  }

  @override
  Future<void> followChannel(int channelId, int followerId) async {
    print('➕ Following channel $channelId...');

    // Try /api/channelFollow first, then /channelFollow as fallback
    final endpoints = [
      '/api/channelFollow/follow/$channelId/$followerId',
      '/channelFollow/follow/$channelId/$followerId',
    ];

    for (final endpoint in endpoints) {
      try {
        print('🌐 Trying endpoint: $endpoint');
        await apiClient.dio.post(endpoint);
        print('✅ Channel followed with $endpoint');
        return;
      } catch (e) {
        print('❌ Error with $endpoint: $e');
        // If this is the last endpoint, rethrow
        if (endpoint == endpoints.last) {
          rethrow;
        }
        // Otherwise, try next endpoint
        print('🔄 Trying next endpoint...');
      }
    }
  }

  @override
  Future<void> unfollowChannel(int channelId, int followerId) async {
    print('➖ Unfollowing channel $channelId...');

    // Try /api/channelFollow first, then /channelFollow as fallback
    final endpoints = [
      '/api/channelFollow/unfollow/$channelId/$followerId',
      '/channelFollow/unfollow/$channelId/$followerId',
    ];

    for (final endpoint in endpoints) {
      try {
        print('🌐 Trying endpoint: $endpoint');
        await apiClient.dio.delete(endpoint);
        print('✅ Channel unfollowed with $endpoint');
        return;
      } catch (e) {
        print('❌ Error with $endpoint: $e');
        // If this is the last endpoint, rethrow
        if (endpoint == endpoints.last) {
          rethrow;
        }
        // Otherwise, try next endpoint
        print('🔄 Trying next endpoint...');
      }
    }
  }
}
