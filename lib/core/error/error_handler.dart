import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timed out. Please check your internet connection.";
        case DioExceptionType.sendTimeout:
          return "Unable to send data to the server. Please try again.";
        case DioExceptionType.receiveTimeout:
          return "Server took too long to respond. Please try again.";
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return "Request was cancelled.";
        case DioExceptionType.connectionError:
           return "No internet connection available.";
        case DioExceptionType.unknown:
          if (error.error.toString().contains("SocketException")) {
             return "No internet connection available.";
          }
          return "An unexpected error occurred. Please try again later.";
        default:
          return "Something went wrong. Please try again.";
      }
    } else {
      return error.toString();
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) return "Unknown server error.";
    
    // Try to extract message from backend response if available
    try {
      if (response.data is Map<String, dynamic>) {
        if (response.data['message'] != null) {
          return response.data['message'].toString();
        }
        if (response.data['error'] != null) {
          return response.data['error'].toString();
        }
      }
    } catch (_) {}

    switch (response.statusCode) {
      case 400:
        return "Bad request. Please check your inputs.";
      case 401:
        return "Unauthorized. Please login again.";
      case 403:
        return "Access denied. You don't have permission.";
      case 404:
        return "Resource not found.";
      case 500:
        return "Internal server error. Please try again later.";
      case 503:
        return "Service unavailable. Please try again later.";
      default:
        return "Received invalid status code: ${response.statusCode}";
    }
  }
}
