import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/movies/data/datasources/movie_local_datasource.dart';
import '../../features/movies/data/datasources/movie_remote_datasource.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_popular_movies.dart';
import '../../features/movies/presentation/cubit/movie_list_cubit.dart';
import '../network/dio_client.dart';
import '../utils/hive_helper.dart';

// Service Locator - Register all dependencies here
// Call setupDependencies() once in main()
// Then use getIt<Type>() anywhere in the app

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ==================== External Dependencies ====================

  // SharedPreferences - for simple storage (theme preference)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Dio - HTTP client
  final dio = Dio();

  // DioClient - Configured HTTP client with base URL and interceptors
  final dioClient = DioClient(dio);
  getIt.registerLazySingleton(() => dioClient);

  // ==================== Data Sources ====================

  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(
      moviesBox: Hive.box(HiveHelper.moviesBox),
      movieDetailsBox: Hive.box(HiveHelper.movieDetailsBox),
    ),
  );

  // ==================== Repositories ====================

  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: getIt<MovieRemoteDataSource>(),
      localDataSource: getIt<MovieLocalDataSource>(),
    ),
  );

  // ==================== Use Cases ====================

  getIt.registerLazySingleton(() => GetPopularMovies(getIt<MovieRepository>()));

  // ==================== Cubits ====================
  // Cubits are factories (new instance each time)

  getIt.registerFactory(() => MovieListCubit(
    getPopularMovies: getIt<GetPopularMovies>(),
  ));
}
