import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/movie.dart';
import '../widgets/cast_list.dart';

/// MovieDetailsPage - Shows movie details
///
/// Matches Screen 2 design:
/// - Large backdrop with gradient overlay
/// - Movie title, year, studio
/// - Star rating + user count
/// - Description
/// - Cast section (4 actors)
/// - "Watch now" gradient button
class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backdrop image with gradient overlay
            Stack(
              children: [
                // Backdrop image
                if (movie.fullBackdropUrl != null)
                  CachedNetworkImage(
                    imageUrl: movie.fullBackdropUrl!,
                    height: 500,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 500,
                      color: Colors.grey[800],
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 500,
                      color: Colors.grey[800],
                    ),
                  )
                else
                  Container(
                    height: 500,
                    color: Colors.grey[800],
                  ),

                // Gradient overlay
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Movie info overlaid on backdrop
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Rating Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${movie.releaseYear}\nMarvel Studios',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              _buildRating(),
                              const SizedBox(height: 4),
                              const Text(
                                'From 342 users',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    movie.overview,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Cast section
                  _buildCastSection(),

                  const SizedBox(height: 32),

                  // Watch button with gradient border
                  Center(
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00BCD4), Color(0xFF9C27B0)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(23),
                            onTap: () {
                              // Play movie
                            },
                            child: const Center(
                              child: Text(
                                'Watch now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCastSection() {
    // Temporary mock data
    final mockCast = [
      CastMember(
        name: 'Marla Espaes',
        role: 'As Morbius',
        imageUrl: 'https://via.placeholder.com/100',
      ),
      CastMember(
        name: 'Marla Espaes',
        role: 'As Morbius',
        imageUrl: 'https://via.placeholder.com/100',
      ),
      CastMember(
        name: 'Marla Espaes',
        role: 'As Morbius',
        imageUrl: 'https://via.placeholder.com/100',
      ),
      CastMember(
        name: 'Marla Espaes',
        role: 'As Morbius',
        imageUrl: 'https://via.placeholder.com/100',
      ),
    ];

    return CastList(cast: mockCast);
  }
}
