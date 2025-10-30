import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';

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
  getIt.registerLazySingleton(() => dio);

  // DioClient - Configured HTTP client
  getIt.registerLazySingleton(() => DioClient(getIt<Dio>()));

  // ==================== Repositories ====================
  // TODO: Register repositories here when we create them
  // Example: getIt.registerLazySingleton(() => MovieRepository(getIt()));

  // ==================== Use Cases ====================
  // TODO: Register use cases here when we create them
  // Example: getIt.registerLazySingleton(() => GetPopularMovies(getIt()));

  // ==================== Cubits ====================
  // Cubits are registered as factories (new instance each time)
  // TODO: Register cubits here when we create them
  // Example: getIt.registerFactory(() => MovieListCubit(getIt()));
}
