import 'package:flutter/material.dart';

/// CategoryCard - Category card with gradient background
///
/// Matches Screen 3 design:
/// - Movies card (blue gradient, Spider-Man image)
/// - Animes card (red/orange gradient, anime character)
class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Background character image
            Positioned(
              right: -20,
              bottom: -20,
              child: Image.network(
                imageUrl,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),

            // Text content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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
}
