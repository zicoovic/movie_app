import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';
import 'movie_list_state.dart';

/// MovieListCubit - Manages movie list state
///
/// Handles:
/// 1. Loading initial movies
/// 2. Pagination (loading more on scroll)
/// 3. Error handling
class MovieListCubit extends Cubit<MovieListState> {
  final GetPopularMovies getPopularMovies;

  // Track pagination
  int _currentPage = 0;
  final List<Movie> _allMovies = [];
  bool _hasMore = true;

  MovieListCubit({required this.getPopularMovies}) : super(MovieListInitial());

  /// Load first page of movies
  Future<void> loadMovies() async {
    emit(MovieListLoading());

    final result = await getPopularMovies(GetPopularMoviesParams(page: 1));

    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) {
        _currentPage = 1;
        _allMovies.clear();
        _allMovies.addAll(movies);
        _hasMore = movies.length >= 20; // TMDB returns 20 per page

        emit(MovieListLoaded(
          movies: _allMovies,
          currentPage: _currentPage,
          hasMore: _hasMore,
        ));
      },
    );
  }

  /// Load more movies (pagination)
  /// Called when user scrolls to bottom
  Future<void> loadMoreMovies() async {
    // Don't load if already loading or no more pages
    if (state is MovieListLoadingMore || !_hasMore) return;

    emit(MovieListLoadingMore(_allMovies));

    final nextPage = _currentPage + 1;
    final result =
        await getPopularMovies(GetPopularMoviesParams(page: nextPage));

    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) {
        _currentPage = nextPage;
        _allMovies.addAll(movies);
        _hasMore = movies.length >= 20;

        emit(MovieListLoaded(
          movies: _allMovies,
          currentPage: _currentPage,
          hasMore: _hasMore,
        ));
      },
    );
  }

  /// Refresh movies (pull to refresh)
  Future<void> refreshMovies() async {
    _currentPage = 0;
    _allMovies.clear();
    _hasMore = true;
    await loadMovies();
  }
}
