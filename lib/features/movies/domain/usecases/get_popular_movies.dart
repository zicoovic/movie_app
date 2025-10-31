import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// GetPopularMovies UseCase
///
/// Business logic for fetching popular movies.
/// This is a single responsibility class - it does ONE thing only.
///
/// Why UseCase?
/// - Separates business logic from UI (Cubit just calls this)
/// - Reusable (can be called from multiple places)
/// - Testable (easy to mock repository)
class GetPopularMovies implements UseCase<List<Movie>, GetPopularMoviesParams> {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

/// Parameters for GetPopularMovies UseCase
class GetPopularMoviesParams {
  final int page;

  GetPopularMoviesParams({required this.page});
}
