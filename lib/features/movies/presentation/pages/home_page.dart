import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/movie_list_cubit.dart';
import '../cubit/movie_list_state.dart';
import '../widgets/movie_card.dart';

/// HomePage - Shows list of popular movies
///
/// Features:
/// 1. Displays movie cards in grid
/// 2. Pagination (loads more on scroll)
/// 3. Pull to refresh
/// 4. Shows loading & error states
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MovieListCubit>()..loadMovies(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Popular Movies'),
          centerTitle: true,
        ),
        body: BlocBuilder<MovieListCubit, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MovieListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<MovieListCubit>().loadMovies(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is MovieListLoaded || state is MovieListLoadingMore) {
              final movies = state is MovieListLoaded
                  ? state.movies
                  : (state as MovieListLoadingMore).currentMovies;

              return RefreshIndicator(
                onRefresh: () => context.read<MovieListCubit>().refreshMovies(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    // Load more when scrolled to 80%
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent * 0.8) {
                      context.read<MovieListCubit>().loadMoreMovies();
                    }
                    return false;
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: movies.length + (state is MovieListLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == movies.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return MovieCard(movie: movies[index]);
                    },
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
