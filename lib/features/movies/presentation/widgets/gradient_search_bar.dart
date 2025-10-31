import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// GradientSearchBar - Search bar with gradient border
///
/// Matches Screen 3 design:
/// - Gradient border (cyan to purple)
/// - Dark background
/// - "Search for a content" placeholder
class GradientSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const GradientSearchBar({
    super.key,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        margin: const EdgeInsets.all(2), // Border width
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(26),
        ),
        child: TextField(
          onChanged: onChanged,
          onTap: onTap,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for a content',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white54,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}
