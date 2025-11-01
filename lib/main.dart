import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/hive_helper.dart';
import 'features/theme/presentation/cubit/theme_cubit.dart';

void main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (local database for caching)
  await HiveHelper.init();

  // Setup Dependency Injection
  await setupDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Get app title based on flavor
  String get appTitle {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'prod');
    return flavor == 'dev' ? 'Movie App Dev' : 'Movie App';
  }

  @override
  Widget build(BuildContext context) {
    // Provide ThemeCubit to the entire app
    return BlocProvider(
      create: (_) => ThemeCubit(getIt()),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: appTitle,

            // Use our custom themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, // Current theme from Cubit

            // Use go_router for navigation
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
