import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/movie_model.dart';

/// MovieRemoteDataSource - Talks to TMDB API
///
/// This class is responsible for making HTTP requests to get movie data.
/// It throws exceptions (not Failures - that's for repository layer)
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies(int page);
  Future<MovieModel> getMovieDetails(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getPopularMovies(int page) async {
    try {
      print('🌍 RemoteDataSource: Calling API for page $page');
      final response = await dio.get(
        ApiConstants.popularMovies,
        queryParameters: {
          'page': page,
          'api_key': ApiConstants.apiKey,
        },
      );

      print('🌍 RemoteDataSource: Got response with status ${response.statusCode}');
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        print('🌍 RemoteDataSource: Parsing ${results.length} movies');
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load movies');
      }
    } on DioException catch (e) {
      print('🌍 RemoteDataSource: DioException - ${e.type}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(
          e.response?.data['status_message'] ?? 'Server error',
        );
      }
    } catch (e) {
      print('🌍 RemoteDataSource: Unexpected error - $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get(
        ApiConstants.getMovieDetailsEndpoint(movieId),
        queryParameters: {
          'api_key': ApiConstants.apiKey,
        },
      );

      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to load movie details');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(
          e.response?.data['status_message'] ?? 'Server error',
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
