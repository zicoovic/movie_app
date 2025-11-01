import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/features/movies/domain/usecases/get_popular_movies.dart';

/// Mock class for MovieRepository
class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    usecase = GetPopularMovies(mockRepository);
  });

  const tPage = 1;
  final List<Movie> tMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie 1',
      overview: 'Test overview',
      posterPath: '/test1.jpg',
      backdropPath: '/backdrop1.jpg',
      releaseDate: '2024-01-01',
      voteAverage: 8.5,
      genreIds: [16, 28],
    ),
    const Movie(
      id: 2,
      title: 'Test Movie 2',
      overview: 'Test overview 2',
      posterPath: '/test2.jpg',
      backdropPath: '/backdrop2.jpg',
      releaseDate: '2024-01-02',
      voteAverage: 7.5,
      genreIds: [16],
    ),
  ];

  test('should get list of movies from repository', () async {
    // Arrange: Setup mock to return success
    when(() => mockRepository.getPopularMovies(page: tPage))
        .thenAnswer((_) async => Right(tMovies));

    // Act: Call the use case
    final result = await usecase(GetPopularMoviesParams(page: tPage));

    // Assert: Verify the result
    expect(result, Right(tMovies));
    verify(() => mockRepository.getPopularMovies(page: tPage));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // Arrange: Setup mock to return failure
    final tFailure = ServerFailure('Server error');
    when(() => mockRepository.getPopularMovies(page: tPage))
        .thenAnswer((_) async => Left(tFailure));

    // Act: Call the use case
    final result = await usecase(GetPopularMoviesParams(page: tPage));

    // Assert: Verify failure is returned
    expect(result, Left(tFailure));
    verify(() => mockRepository.getPopularMovies(page: tPage));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle different page numbers', () async {
    // Arrange
    const tPage2 = 2;
    when(() => mockRepository.getPopularMovies(page: tPage2))
        .thenAnswer((_) async => Right(tMovies));

    // Act
    final result = await usecase(GetPopularMoviesParams(page: tPage2));

    // Assert
    expect(result, Right(tMovies));
    verify(() => mockRepository.getPopularMovies(page: tPage2));
  });
}
