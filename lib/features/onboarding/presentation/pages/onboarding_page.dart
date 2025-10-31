import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../widgets/tilted_posters.dart';

/// OnboardingPage - First screen user sees
///
/// Design from Screen 1:
/// - Dark background
/// - Tilted movie posters (3D effect)
/// - Title + subtitle
/// - Gradient button to enter app
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Tilted movie posters (3D perspective)
              const TiltedPosters(),

              const Spacer(),

              // Title
              const Text(
                'Onboarding',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'Watch everything you want\nfor free!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Enter button
              GradientButton(
                text: 'Enter now',
                width: 200,
                onPressed: () {
                  // Navigate to home using go_router
                  context.go('/home');
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
