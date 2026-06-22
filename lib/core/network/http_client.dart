import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class FarchisHttpClient {
  final FlutterSecureStorage secureStorage;
  final http.Client _client;

  FarchisHttpClient(this.secureStorage) : _client = http.Client();

  Future<Map<String, String>> _getHeaders(Map<String, String>? extraHeaders) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    final token = await secureStorage.read(key: 'auth_token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded as Map<String, dynamic>;
      }

      final message = decoded['message'] ?? 'Unknown error occurred';

      switch (response.statusCode) {
        case 401:
          throw UnauthorizedException(message: message);
        case 403:
          throw ServerException(message: 'Forbidden: $message', statusCode: 403);
        case 404:
          throw NotFoundException(message: message);
        case 422:
          final errors = decoded['errors'] as Map<String, dynamic>?;
          throw ValidationException(errors ?? {});
        default:
          throw ServerException(message: message, statusCode: response.statusCode);
      }
    } on FormatException {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {};
      }
      throw ServerException(
          message: 'Invalid response format', statusCode: response.statusCode);
    }
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$path');
      final reqHeaders = await _getHeaders(headers);
      final response = await _client.get(url, headers: reqHeaders).timeout(ApiConstants.requestTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on Exception catch (e) {
      if (e is UnauthorizedException ||
          e is NotFoundException ||
          e is ValidationException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> post(String path,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$path');
      final reqHeaders = await _getHeaders(headers);
      final response = await _client
          .post(url, headers: reqHeaders, body: body != null ? json.encode(body) : null)
          .timeout(ApiConstants.requestTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on Exception catch (e) {
      if (e is UnauthorizedException ||
          e is NotFoundException ||
          e is ValidationException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> put(String path,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$path');
      final reqHeaders = await _getHeaders(headers);
      final response = await _client
          .put(url, headers: reqHeaders, body: body != null ? json.encode(body) : null)
          .timeout(ApiConstants.requestTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on Exception catch (e) {
      if (e is UnauthorizedException ||
          e is NotFoundException ||
          e is ValidationException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> patch(String path,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$path');
      final reqHeaders = await _getHeaders(headers);
      final response = await _client
          .patch(url, headers: reqHeaders, body: body != null ? json.encode(body) : null)
          .timeout(ApiConstants.requestTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on Exception catch (e) {
      if (e is UnauthorizedException ||
          e is NotFoundException ||
          e is ValidationException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> delete(String path, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$path');
      final reqHeaders = await _getHeaders(headers);
      final response = await _client.delete(url, headers: reqHeaders).timeout(ApiConstants.requestTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on Exception catch (e) {
      if (e is UnauthorizedException ||
          e is NotFoundException ||
          e is ValidationException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> uploadFiles(
      String path, Map<String, String> fields, List<http.MultipartFile> files) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$path');
      final request = http.MultipartRequest('POST', url);

      final reqHeaders = await _getHeaders(null);
      reqHeaders.remove('Content-Type'); // Let multipart handle it
      request.headers.addAll(reqHeaders);

      request.fields.addAll(fields);
      request.files.addAll(files);

      final streamedResponse = await request.send().timeout(const Duration(minutes: 5));
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on Exception catch (e) {
      if (e is UnauthorizedException ||
          e is NotFoundException ||
          e is ValidationException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException(message: e.toString());
    }
  }
}
