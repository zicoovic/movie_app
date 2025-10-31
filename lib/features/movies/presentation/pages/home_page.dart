import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_list_cubit.dart';
import '../cubit/movie_list_state.dart';
import '../widgets/category_card.dart';
import '../widgets/gradient_search_bar.dart';
import '../widgets/horizontal_movie_list.dart';

/// HomePage - Main screen matching Screen 3 design
///
/// Sections:
/// 1. Search bar (gradient border)
/// 2. Categories (Movies & Animes cards)
/// 3. Most searched (horizontal movie list)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ No BlocProvider here!
    // MovieListCubit is provided by the router (app_router.dart)
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Search for a content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Search bar
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: GradientSearchBar(),
              ),

              const SizedBox(height: 32),

              // Categories title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Categories.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Categories cards (Movies & Animes)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: CategoryCard(
                        title: 'Movies',
                        subtitle: '532 Titles',
                        imageUrl: 'https://example.com/spiderman.png',
                        gradientColors: const [
                          Color(0xFF1E88E5),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CategoryCard(
                        title: 'Animes',
                        subtitle: '732 Titles',
                        imageUrl: 'https://example.com/anime.png',
                        gradientColors: const [
                          Color(0xFFE53935),
                          Color(0xFFFF6F00),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Most searched title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Most searched.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Most searched movie list
              Expanded(
                child: BlocBuilder<MovieListCubit, MovieListState>(
                  builder: (context, state) {
                    if (state is MovieListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is MovieListError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is MovieListLoaded) {
                      return HorizontalMovieList(movies: state.movies);
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
