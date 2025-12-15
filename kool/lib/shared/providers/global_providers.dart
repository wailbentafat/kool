import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; // Fixed import
import '../services/user_preferences_service.dart';
import '../../features/mode_detection/models/learning_mode.dart';

// User Preferences with Persistence
final onboardingCompletedProvider = StateProvider<bool>((ref) {
  return ref.watch(userPreferencesServiceProvider).onboardingCompleted;
});

final userConsentProvider = StateProvider<bool>((ref) => false);
final learningModeProvider = StateProvider<LearningMode>(
  (ref) => LearningMode.normal,
);

// Theme Mode Provider (Light/Dark/System) is now handled in user_preferences_service.dart usage
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Service Providers (initialized in main)
final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

/// Example provider for theme mode if we add dark mode later.
/// Currently simpler to stick to one cozy theme or system default.
