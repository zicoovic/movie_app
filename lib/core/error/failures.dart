import 'package:equatable/equatable.dart';

// Failures represent errors that we show to users
// Simple, clear messages that users can understand

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// When API/server has a problem
class ServerFailure extends Failure {
  const ServerFailure(
      [super.message = 'Something went wrong. Please try again.']);
}

// When there's no internet
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

// When cached data has a problem
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not load saved data.']);
}

// For any other unexpected error
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}
