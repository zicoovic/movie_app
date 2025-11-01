import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              Text(
                'Onboarding',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Watch everything you want\nfor free!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Enter button with gradient border
              Container(
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
                      onTap: () => context.go('/home'),
                      child: const Center(
                        child: Text(
                          'Enter now',
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

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
