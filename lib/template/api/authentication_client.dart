import 'package:dio/dio.dart';
import 'package:yansnet/authentication/models/login_credentials.dart';
import 'package:yansnet/authentication/models/registration_credentials.dart';
import 'package:yansnet/authentication/models/user.dart';
import 'package:yansnet/core/network/dio.dart';

class HttpException implements Exception {
  const HttpException(this.message);

  final String? message;
}

/// {@template http_request_failure}
/// Thrown if an `http` request returns a non-200 status code.
/// {@endtemplate}
class HttpRequestFailure implements Exception {
  /// {@macro http_request_failure}
  const HttpRequestFailure(this.statusCode, this.message, this.data);

  /// The status code of the response.
  final int statusCode;
  final String? message;
  final Map<String, dynamic> data;
}

/// Thrown when an error occurs while decoding the response body.
class JsonDecodeException implements Exception {}

/// Thrown when an error occurs while deserializing the response body.
class JsonDeserializationException implements Exception {}

class AuthenticationClient {

  Future<AuthResponse> loginUser(LoginCredentials credentials)async{
    final responseBody = await _post('auth/login', credentials.toJson());

    try {
      if (responseBody['erc'] == '0') {
        throw HttpException(responseBody['msg'] as String);
      } else if (responseBody['erc'] == '3') {
        throw HttpRequestFailure(
          int.parse(responseBody['erc'] as String),
          responseBody['msg'] as String,
          responseBody,
        );
      } else {
        return AuthResponse.fromJson(responseBody['data'] as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is HttpException || e is HttpRequestFailure) {
        rethrow;
      } else {
        throw JsonDeserializationException();
      }
    }
  }

  Future<AuthResponse> registerUser(RegistrationCredentials credentials)async{
    final responseBody = await _post('auth/register', credentials.toJson());

    try {
      if (responseBody['erc'] == '0') {
        throw HttpException(responseBody['msg'] as String);
      } else if (responseBody['erc'] == '3') {
        throw HttpRequestFailure(
          int.parse(responseBody['erc'] as String),
          responseBody['msg'] as String,
          responseBody,
        );
      } else {
        return AuthResponse.fromJson(responseBody['data'] as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is HttpException || e is HttpRequestFailure) {
        rethrow;
      } else {
        throw JsonDeserializationException();
      }
    }
  }



  Future<Map<String, dynamic>> _post(
      String url, [
        Map<String, dynamic>? data,
        Map<String, dynamic>? headers,
      ]) async {
    Response<dynamic> response;

    try {
      defaultOptions.headers?.addAll(headers ?? {});
      response = await http.post(url, options: defaultOptions, data: data);
    } catch (e) {
      final error = e as DioException;
      final data = error.response as Map<String, dynamic>?;

      throw HttpException(data?['message'] as String);
    }

    try {
      return response.data as Map<String, dynamic>;
    } catch (_) {
      throw JsonDecodeException();
    }
  }

}