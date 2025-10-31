import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/movie.dart';

/// HorizontalMovieList - Scrollable movie list
///
/// Shows movie posters horizontally with title and year
/// Used in "Most searched" section (Screen 3)
class HorizontalMovieList extends StatelessWidget {
  final List<Movie> movies;

  const HorizontalMovieList({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _MoviePosterItem(
            movie: movie,
            onTap: () => context.push('/details', extra: movie),
          );
        },
      ),
    );
  }
}

/// Individual movie poster item
class _MoviePosterItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const _MoviePosterItem({required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: movie.fullPosterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: movie.fullPosterUrl!,
                        fit: BoxFit.cover,
                        width: 120,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.movie, color: Colors.white54),
                        ),
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie, color: Colors.white54),
                      ),
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Year
            Text(
              movie.releaseYear,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
