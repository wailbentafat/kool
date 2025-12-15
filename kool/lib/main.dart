import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'shared/services/user_preferences_service.dart';
import 'core/data/local_db.dart';
import 'shared/services/lesson_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services
  final prefs = await SharedPreferences.getInstance();
  final localDB = LocalDB();

  // Seed Data
  final lessonService = LessonService(localDB);
  await lessonService.seedInitialLessons();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        localDBProvider.overrideWithValue(localDB),
      ],
      child: const LexiLearnApp(),
    ),
  );
}
