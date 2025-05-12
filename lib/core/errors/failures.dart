import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

abstract class Resonse extends Equatable {
  final String message;

  const Resonse({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required String message, this.statusCode})
    : super(message: message);

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}
