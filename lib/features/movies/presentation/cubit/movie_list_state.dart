import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

/// States for Movie List
///
/// The UI will rebuild based on these states
abstract class MovieListState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state - nothing loaded yet
class MovieListInitial extends MovieListState {}

/// Loading first page of movies
class MovieListLoading extends MovieListState {}

/// Movies loaded successfully
class MovieListLoaded extends MovieListState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasMore; // Are there more pages to load?

  MovieListLoaded({
    required this.movies,
    required this.currentPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [movies, currentPage, hasMore];
}

/// Loading more movies (pagination)
/// Shows current movies + loading indicator at bottom
class MovieListLoadingMore extends MovieListState {
  final List<Movie> currentMovies;

  MovieListLoadingMore(this.currentMovies);

  @override
  List<Object?> get props => [currentMovies];
}

/// Error occurred
class MovieListError extends MovieListState {
  final String message;

  MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}
