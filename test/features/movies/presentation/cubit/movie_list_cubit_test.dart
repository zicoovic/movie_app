import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_app/features/movies/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app/features/movies/presentation/cubit/movie_list_state.dart';

/// Mock class for GetPopularMovies UseCase
class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late MovieListCubit cubit;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    cubit = MovieListCubit(getPopularMovies: mockGetPopularMovies);
  });

  setUpAll(() {
    registerFallbackValue(GetPopularMoviesParams(page: 1));
  });

  tearDown(() {
    cubit.close();
  });

  final List<Movie> tMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Test overview',
      posterPath: '/test.jpg',
      backdropPath: '/backdrop.jpg',
      releaseDate: '2024-01-01',
      voteAverage: 8.5,
      genreIds: [16],
    ),
  ];

  group('loadMovies', () {
    blocTest<MovieListCubit, MovieListState>(
      'emits [MovieListLoading, MovieListLoaded] when data is fetched successfully',
      build: () {
        when(() => mockGetPopularMovies(any()))
            .thenAnswer((_) async => Right(tMovies));
        return cubit;
      },
      act: (cubit) => cubit.loadMovies(),
      expect: () => [
        MovieListLoading(),
        MovieListLoaded(
          movies: tMovies,
          currentPage: 1,
          hasMore: false, // Only 1 movie, need 20+ for hasMore=true
        ),
      ],
    );

    blocTest<MovieListCubit, MovieListState>(
      'emits [MovieListLoading, MovieListError] when fetching fails',
      build: () {
        when(() => mockGetPopularMovies(any()))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        return cubit;
      },
      act: (cubit) => cubit.loadMovies(),
      expect: () => [
        MovieListLoading(),
        MovieListError('Server error'),
      ],
    );

    blocTest<MovieListCubit, MovieListState>(
      'sets hasMore to false when fewer than 20 movies are returned',
      build: () {
        when(() => mockGetPopularMovies(any()))
            .thenAnswer((_) async => Right(tMovies));
        return cubit;
      },
      act: (cubit) => cubit.loadMovies(),
      expect: () => [
        MovieListLoading(),
        MovieListLoaded(
          movies: tMovies,
          currentPage: 1,
          hasMore: false, // Only 1 movie, less than 20
        ),
      ],
    );
  });

  group('refreshMovies', () {
    blocTest<MovieListCubit, MovieListState>(
      'resets and reloads movies from page 1',
      build: () {
        when(() => mockGetPopularMovies(any()))
            .thenAnswer((_) async => Right(tMovies));
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadMovies();
        await cubit.refreshMovies(); // Should reload from page 1
      },
      expect: () => [
        MovieListLoading(),
        MovieListLoaded(movies: tMovies, currentPage: 1, hasMore: false),
        MovieListLoading(),
        MovieListLoaded(movies: tMovies, currentPage: 1, hasMore: false),
      ],
    );
  });
}
