import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../features/movies/presentation/cubit/movie_list_cubit.dart';
import '../../features/movies/presentation/pages/home_page.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

/// App Router - Navigation configuration
///
/// Each route is wrapped with its required Cubit
/// This way screens don't need BlocProvider inside them!
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // Onboarding (no Cubit needed)
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingPage(),
      ),

      // Home (wrapped with MovieListCubit)
      GoRoute(
        path: '/home',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<MovieListCubit>()..loadMovies(),
          child: const HomePage(),
        ),
      ),

      // Movie Details (no Cubit needed - receives movie as parameter)
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final movie = state.extra as Movie;
          return MovieDetailsPage(movie: movie);
        },
      ),
    ],
  );
}
