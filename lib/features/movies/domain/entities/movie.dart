import 'package:equatable/equatable.dart';

/// Movie Entity - Pure business object
///
/// This represents a Movie in our domain layer.
/// No JSON, no API details - just what a Movie IS.
///
/// Fields match TMDB API response from /movie/popular and /movie/{id}
/// Uses Equatable for easy comparison (useful for testing and state management)
class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String? posterPath; // Nullable - some movies might not have poster
  final String? backdropPath; // Nullable - for detail screen background
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  /// Helper method to get full poster URL
  /// TMDB gives us just the path like "/abc.jpg"
  /// We need to add base URL: https://image.tmdb.org/t/p/w500/abc.jpg
  String? get fullPosterUrl {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  /// Helper method to get full backdrop URL (for details screen background)
  String? get fullBackdropUrl {
    if (backdropPath == null) return null;
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }

  /// Helper method to format rating (8.543 → "8.5")
  String get formattedRating => voteAverage.toStringAsFixed(1);

  /// Helper method to get release year (2024-01-15 → "2024")
  String get releaseYear {
    if (releaseDate.isEmpty) return 'N/A';
    return releaseDate.split('-').first;
  }

  /// Equatable props - used for comparison
  /// Two movies are equal if they have the same id
  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        genreIds,
      ];
}
