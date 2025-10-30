import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/theme/presentation/cubit/theme_cubit.dart';

void main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Get shared_preferences instance
  final prefs = await SharedPreferences.getInstance();

  runApp(MainApp(prefs: prefs));
}

class MainApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MainApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Provide ThemeCubit to the entire app
    return BlocProvider(
      create: (_) => ThemeCubit(prefs),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie App',

            // Use our custom themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, // Current theme from Cubit

            home: const HomePage(),
          );
        },
      ),
    );
  }
}

// Temporary home page to test theme switching
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              themeCubit.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeCubit.toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Theme System Working!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Click the icon in the app bar to switch themes',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
