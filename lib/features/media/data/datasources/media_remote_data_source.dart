import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

abstract class MediaRemoteDataSource {
  Future<String> uploadFile(File file);
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  final ApiClient apiClient;

  MediaRemoteDataSourceImpl(this.apiClient);

  @override
  Future<String> uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await apiClient.dio.post(
        '/api/media/upload',
        data: formData,
      );

      // The API response for upload is Map<String, String> like {"url": "..."} according to docs?
      // Doc says: responses: 200: schemas: type: object, additionalProperties: type: string
      // Let's assume it returns a map. We need to find the key that holds the URL.
      // Usually it's "url" or similar.
      // Based on docs: /api/media/upload -> response schema: additionalProperties: string.
      // Let's assume the response body is the purely the key-value map.
      // Implementation strategy: Print response if debugging, but here we assume 'url' key or similar,
      // OR if it returns just a string (less likely for JSON).
      // Let's check the API doc again carefully.
      // "Uploads a multipart file to MinIO and returns its public URL"
      // Response content schema: type object, additionalProperties string.
      // It's likely `{"url": "http://minio..."}` or `{"fileName": "..."}`.
      // I will assume it returns a map and I'll return the first value if I can't find 'url', or 'url' specifically.

      final data = response.data;
      if (data is Map) {
         if (data.containsKey('url')) {
           return data['url'];
         } else if (data.isNotEmpty) {
           return data.values.first.toString();
         }
      } else if (data is String) {
        return data; // Maybe it returns the URL directly stringified
      }

      throw Exception("Unexpected response format from upload: $data");
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
}
