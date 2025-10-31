import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/gradient_button.dart';
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
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 400,
                      color: Colors.grey[800],
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 400,
                      color: Colors.grey[800],
                    ),
                  )
                else
                  Container(
                    height: 400,
                    color: Colors.grey[800],
                  ),

                // Gradient overlay
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
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
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row (with year and rating)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildRating(),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Year and Studio (placeholder)
                  Text(
                    '${movie.releaseYear} · Marvel Studios',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // User count
                  const Text(
                    'From 342 users',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Cast section
                  _buildCastSection(),

                  const SizedBox(height: 32),

                  // Watch button
                  Center(
                    child: GradientButton(
                      text: 'Watch now',
                      width: 200,
                      onPressed: () {
                        // TODO: Play movie
                      },
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
