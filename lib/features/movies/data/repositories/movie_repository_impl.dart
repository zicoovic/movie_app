import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_datasource.dart';
import '../datasources/movie_remote_datasource.dart';

/// MovieRepositoryImpl - Implementation of MovieRepository
///
/// This is where the magic happens!
/// Strategy: Cache-first approach
/// 1. Try to get data from cache (fast, works offline)
/// 2. If no cache or cache expired, fetch from API
/// 3. Save API response to cache for next time
///
/// Converts Exceptions (data layer) → Failures (domain layer)
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({
    required int page,
  }) async {
    try {
      // Step 1: Try cache first
      print('📦 Repository: Checking cache for page $page');
      final cachedMovies = await localDataSource.getCachedPopularMovies(page);
      print('📦 Repository: Cache HIT - Found ${cachedMovies.length} movies');
      return Right(cachedMovies);
    } on CacheException catch (e) {
      // Step 2: Cache miss or expired, fetch from API
      print('📦 Repository: Cache MISS - ${e.message}');
      try {
        print('📦 Repository: Fetching from API...');
        final remoteMovies = await remoteDataSource.getPopularMovies(page);
        print('📦 Repository: API returned ${remoteMovies.length} movies');

        // Step 3: Save to cache for next time
        await localDataSource.cachePopularMovies(remoteMovies, page);
        print('📦 Repository: Saved to cache');

        return Right(remoteMovies);
      } on ServerException catch (e) {
        print('📦 Repository: ServerException - ${e.message}');
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        print('📦 Repository: NetworkException - ${e.message}');
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      print('📦 Repository: Unexpected error - $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails({
    required int movieId,
  }) async {
    try {
      // Step 1: Try cache first
      final cachedMovie = await localDataSource.getCachedMovieDetails(movieId);
      return Right(cachedMovie);
    } on CacheException {
      // Step 2: Cache miss or expired, fetch from API
      try {
        final remoteMovie = await remoteDataSource.getMovieDetails(movieId);

        // Step 3: Save to cache for next time
        await localDataSource.cacheMovieDetails(remoteMovie);

        return Right(remoteMovie);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
