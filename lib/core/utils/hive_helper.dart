import 'package:hive_flutter/hive_flutter.dart';

// Hive Helper - Initialize and manage Hive boxes
// A "box" is like a table in a database

class HiveHelper {
  // Box names - like table names
  static const String moviesBox = 'movies_box';
  static const String movieDetailsBox = 'movie_details_box';

  // Initialize Hive
  static Future<void> init() async {
    // Initialize Hive with Flutter
    await Hive.initFlutter();

    // Open boxes (create if they don't exist)
    await Hive.openBox(moviesBox);
    await Hive.openBox(movieDetailsBox);
  }

  // Get a box by name
  static Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  // Close all boxes (call when app closes)
  static Future<void> closeAll() async {
    await Hive.close();
  }
}
