import 'package:flutter/foundation.dart';

class NetworkDebug {
  static void logConnectionRequest({
    required int fromUserId,
    required int toUserId,
    required String endpoint,
  }) {
    if (kDebugMode) {
      print('🔗 CONNECTION REQUEST DEBUG');
      print('📤 Endpoint: $endpoint');
      print('👤 From User ID: $fromUserId');
      print('👥 To User ID: $toUserId');
      print('⏰ Timestamp: ${DateTime.now()}');
      print('─' * 50);
    }
  }

  static void logApiResponse({
    required String endpoint,
    required int statusCode,
    required dynamic responseData,
    required Map<String, dynamic> headers,
  }) {
    if (kDebugMode) {
      print('📥 API RESPONSE DEBUG');
      print('🌐 Endpoint: $endpoint');
      print('📊 Status Code: $statusCode');
      print('📋 Headers: $headers');
      print('📄 Response Data: $responseData');
      print('⏰ Timestamp: ${DateTime.now()}');
      print('─' * 50);
    }
  }

  static void logError({
    required String operation,
    required dynamic error,
    required StackTrace stackTrace,
  }) {
    if (kDebugMode) {
      print('❌ ERROR DEBUG');
      print('🔧 Operation: $operation');
      print('💥 Error: $error');
      print('📍 Stack Trace: $stackTrace');
      print('⏰ Timestamp: ${DateTime.now()}');
      print('─' * 50);
    }
  }
}
