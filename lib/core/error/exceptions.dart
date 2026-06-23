class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server Error', this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Network Error'});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({this.message = 'Unauthorized'});
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException({this.message = 'Not Found'});
}

class ValidationException implements Exception {
  final Map<String, dynamic> errors;
  ValidationException(this.errors);
}
