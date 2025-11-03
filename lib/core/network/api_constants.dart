/// API Constants for TMDB
/// This file contains all API endpoints and configuration
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  // API Key - SECURITY: Loaded from environment variable at compile time
  // Never hardcode API keys in source code!
  // Pass via: flutter run --dart-define=TMDB_API_KEY=your_key
  static const String apiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: '29501a0da4990b898ff159bde85192f4', // Fallback for development only
  );

  // Image Sizes
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';
  static const String profileSize = 'w185';

  // Endpoints
  static const String popularMovies =
      '/discover/movie'; // Changed to discover for better filtering
  static const String movieDetails = '/movie';
  static const String movieCredits = '/credits';

  // Helper methods
  static String getPosterUrl(String posterPath) {
    return '$imageBaseUrl/$posterSize$posterPath';
  }

  static String getBackdropUrl(String backdropPath) {
    return '$imageBaseUrl/$backdropSize$backdropPath';
  }

  static String getProfileUrl(String profilePath) {
    return '$imageBaseUrl/$profileSize$profilePath';
  }

  static String getMovieDetailsEndpoint(int movieId) {
    return '$movieDetails/$movieId';
  }

  static String getMovieCreditsEndpoint(int movieId) {
    return '$movieDetails/$movieId$movieCredits';
  }
}
