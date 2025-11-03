import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';

/// MovieRepository Interface (Contract)
///
/// This is the "contract" that defines what operations we can do with movies.
/// The actual implementation is in the data layer.
///
/// Why interface?
/// - Domain layer doesn't care HOW we get movies (API, cache, etc.)
/// - Easy to swap implementations (mock for testing, real for production)
/// - Follows Dependency Inversion Principle (SOLID)
abstract class MovieRepository {
  /// Get popular movies with pagination
  ///
  /// Returns Either:
  /// - Left (Failure) if something goes wrong
  /// - Right (List of Movie) if successful
  ///
  /// [page] - Page number (1, 2, 3...)
  Future<Either<Failure, List<Movie>>> getPopularMovies({
    required int page,
  });

  /// Get movie details by ID
  ///
  /// Returns Either:
  /// - Left (Failure) if movie not found or error
  /// - Right (Movie) with full details
  ///
  /// [movieId] - The TMDB movie ID
  Future<Either<Failure, Movie>> getMovieDetails({
    required int movieId,
  });
}
