import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

// Base UseCase class that all use cases will extend
// This enforces a consistent pattern across the app

/// Abstract class for UseCases that return a Future
/// [T] is the return type
/// [Params] is the parameters needed to execute the use case
abstract class UseCase<T, Params> {
  /// Execute the use case
  /// Returns Either<Failure, T>
  /// - Left: Failure (error case)
  /// - Right: T (success case)
  Future<Either<Failure, T>> call(Params params);
}

/// Used when a UseCase doesn't need any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
