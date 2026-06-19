import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late Dio _dio;
  late FlutterSecureStorage _secureStorage;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _secureStorage = const FlutterSecureStorage();
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor(_secureStorage));
    _dio.interceptors.add(_LoggingInterceptor());
  }

  Dio get dio => _dio;

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'sanctum_token');
  }

  Future<void> setToken(String token) async {
    await _secureStorage.write(key: 'sanctum_token', value: token);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'sanctum_token');
  }
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  _AuthInterceptor(this.secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: 'sanctum_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await secureStorage.delete(key: 'sanctum_token');
    }
    return handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Log request details (excluding sensitive data)
    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    return handler.next(err);
  }
}
