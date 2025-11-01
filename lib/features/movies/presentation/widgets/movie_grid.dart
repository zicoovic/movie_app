import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/movie.dart';

/// MovieGrid - Vertical scrollable movie grid
///
/// Shows movie posters in a 2-column grid
/// Better for tablets and large screens
class MovieGrid extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  const MovieGrid({
    super.key,
    required this.movies,
    this.onLoadMore,
    this.hasMore = true,
  });

  @override
  State<MovieGrid> createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (widget.hasMore && widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.movies.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.movies.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final movie = widget.movies[index];
        return _MoviePosterItem(
          movie: movie,
          onTap: () => context.push('/details', extra: movie),
        );
      },
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
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(child: CircularProgressIndicator()),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Year
          Text(
            movie.releaseYear,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
