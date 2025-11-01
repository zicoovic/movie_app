import 'package:flutter/material.dart';

/// TiltedPosters - 3D tilted movie posters effect
///
/// Shows 3 movie poster images with perspective tilt
/// Matches design from Onboarding screen
class TiltedPosters extends StatelessWidget {
  const TiltedPosters({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // Top poster (tilted)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(0.3)
                ..rotateZ(-0.1),
              alignment: Alignment.center,
              child: _buildPosterCard(
                'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
              ),
            ),
          ),

          // Middle poster (tilted opposite)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.2)
                ..rotateZ(0.05),
              alignment: Alignment.center,
              child: _buildPosterCard(
                'https://image.tmdb.org/t/p/w500/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg',
              ),
            ),
          ),

          // Bottom poster (tilted)
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.15)
                ..rotateZ(-0.05),
              alignment: Alignment.center,
              child: _buildPosterCard(
                'https://image.tmdb.org/t/p/w500/4m1Au3YkjqsxF8iwQy0fPYSxE0h.jpg',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterCard(String imageUrl) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Icon(Icons.movie, size: 48, color: Colors.white54),
            );
          },
        ),
      ),
    );
  }
}
