import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

/// MovieModel - Data layer
///
/// Extends Movie entity and adds:
/// 1. JSON serialization (for API responses)
/// 2. Hive type adapter (for local caching)
///
/// The @JsonSerializable handles API JSON → Dart object conversion
/// The @HiveType handles Dart object → Local database storage
@HiveType(typeId: 0)
@JsonSerializable()
class MovieModel extends Movie {
  @HiveField(0)
  final int movieId;

  @HiveField(1)
  final String movieTitle;

  @HiveField(2)
  final String movieOverview;

  @HiveField(3)
  final String? moviePosterPath;

  @HiveField(4)
  final String? movieBackdropPath;

  @HiveField(5)
  final double movieVoteAverage;

  @HiveField(6)
  final String movieReleaseDate;

  @HiveField(7)
  final List<int> movieGenreIds;

  @HiveField(8)
  final DateTime cachedAt; // Track when we cached this

  const MovieModel({
    required this.movieId,
    required this.movieTitle,
    required this.movieOverview,
    this.moviePosterPath,
    this.movieBackdropPath,
    required this.movieVoteAverage,
    required this.movieReleaseDate,
    required this.movieGenreIds,
    required this.cachedAt,
  }) : super(
          id: movieId,
          title: movieTitle,
          overview: movieOverview,
          posterPath: moviePosterPath,
          backdropPath: movieBackdropPath,
          voteAverage: movieVoteAverage,
          releaseDate: movieReleaseDate,
          genreIds: movieGenreIds,
        );

  /// Create MovieModel from TMDB API JSON
  /// Maps API field names to our Dart properties
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      movieId: json['id'] as int,
      movieTitle: json['title'] as String,
      movieOverview: json['overview'] as String,
      moviePosterPath: json['poster_path'] as String?,
      movieBackdropPath: json['backdrop_path'] as String?,
      movieVoteAverage: (json['vote_average'] as num).toDouble(),
      movieReleaseDate: json['release_date'] as String,
      movieGenreIds: (json['genre_ids'] as List).cast<int>(),
      cachedAt: DateTime.now(), // Set cache time
    );
  }

  /// Convert MovieModel to JSON (if needed for sending data)
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  /// Check if cache is still fresh (less than 1 hour old)
  bool get isCacheFresh {
    final difference = DateTime.now().difference(cachedAt);
    return difference.inHours < 1;
  }
}
