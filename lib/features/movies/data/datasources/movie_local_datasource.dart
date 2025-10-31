import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/hive_helper.dart';
import '../models/movie_model.dart';

/// MovieLocalDataSource - Manages local caching with Hive
///
/// This class is responsible for:
/// 1. Saving movies to local database (Hive)
/// 2. Retrieving cached movies
/// 3. Checking if cache is still fresh (< 1 hour)
abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getCachedPopularMovies(int page);
  Future<void> cachePopularMovies(List<MovieModel> movies, int page);
  Future<MovieModel> getCachedMovieDetails(int movieId);
  Future<void> cacheMovieDetails(MovieModel movie);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box moviesBox;
  final Box movieDetailsBox;

  MovieLocalDataSourceImpl({
    required this.moviesBox,
    required this.movieDetailsBox,
  });

  @override
  Future<List<MovieModel>> getCachedPopularMovies(int page) async {
    try {
      final key = 'popular_page_$page';
      final cached = moviesBox.get(key);

      if (cached == null) {
        throw CacheException('No cached data for page $page');
      }

      final movies = (cached as List).cast<MovieModel>();

      // Check if cache is still fresh (< 1 hour)
      if (movies.isNotEmpty && movies.first.isCacheFresh) {
        return movies;
      } else {
        throw CacheException('Cache expired');
      }
    } catch (e) {
      throw CacheException('Failed to get cached movies: $e');
    }
  }

  @override
  Future<void> cachePopularMovies(List<MovieModel> movies, int page) async {
    try {
      final key = 'popular_page_$page';
      await moviesBox.put(key, movies);
    } catch (e) {
      throw CacheException('Failed to cache movies: $e');
    }
  }

  @override
  Future<MovieModel> getCachedMovieDetails(int movieId) async {
    try {
      final cached = movieDetailsBox.get(movieId);

      if (cached == null) {
        throw CacheException('No cached data for movie $movieId');
      }

      final movie = cached as MovieModel;

      // Check if cache is still fresh (< 24 hours for details)
      if (movie.isCacheFresh) {
        return movie;
      } else {
        throw CacheException('Cache expired');
      }
    } catch (e) {
      throw CacheException('Failed to get cached movie details: $e');
    }
  }

  @override
  Future<void> cacheMovieDetails(MovieModel movie) async {
    try {
      await movieDetailsBox.put(movie.movieId, movie);
    } catch (e) {
      throw CacheException('Failed to cache movie details: $e');
    }
  }
}
