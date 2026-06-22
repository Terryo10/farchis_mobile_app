import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  String get message;

  @override
  List<Object?> get props => [];

  static Failure network(String message) => NetworkFailure(message);
  static Failure server(String message, {int? statusCode}) =>
      ServerFailure(message, statusCode: statusCode);
  static Failure validation(Map<String, String> errors) =>
      ValidationFailure(errors);
  static Failure cache(String message) => CacheFailure(message);
  static Failure unauthorized(String message) => UnauthorizedFailure(message);
  static Failure forbidden(String message) => ForbiddenFailure(message);
  static Failure notFound(String message) => NotFoundFailure(message);
  static Failure conflict(String message) => ConflictFailure(message);
  static Failure timeout(String message) => TimeoutFailure(message);
  static Failure unknown(String message) => UnknownFailure(message);
}

class NetworkFailure extends Failure {
  @override
  final String message;

  const NetworkFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  @override
  final String message;
  final int? statusCode;

  const ServerFailure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure(this.errors);

  @override
  String get message => errors.values.join('\n');

  @override
  List<Object?> get props => [errors];
}

class CacheFailure extends Failure {
  @override
  final String message;

  const CacheFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UnauthorizedFailure extends Failure {
  @override
  final String message;

  const UnauthorizedFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ForbiddenFailure extends Failure {
  @override
  final String message;

  const ForbiddenFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NotFoundFailure extends Failure {
  @override
  final String message;

  const NotFoundFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ConflictFailure extends Failure {
  @override
  final String message;

  const ConflictFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TimeoutFailure extends Failure {
  @override
  final String message;

  const TimeoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  @override
  final String message;

  const UnknownFailure(this.message);

  @override
  List<Object?> get props => [message];
}

sealed class Result<T> extends Equatable {
  const Result();

  @override
  List<Object?> get props => [];

  factory Result.success(T data) => Success(data);
  factory Result.failure(Failure failure) => FailureResult(failure);

  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as FailureResult).failure);
    }
  }

  R? whenOrNull<R>({
    R Function(T data)? onSuccess,
    R Function(Failure failure)? onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess?.call((this as Success<T>).data);
    } else {
      return onFailure?.call((this as FailureResult).failure);
    }
  }

  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  Failure? getFailureOrNull() {
    if (this is FailureResult) {
      return (this as FailureResult).failure;
    }
    return null;
  }
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);

  @override
  List<Object?> get props => [failure];
}
