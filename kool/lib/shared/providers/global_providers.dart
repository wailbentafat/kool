import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_preferences_service.dart';
import '../../features/mode_detection/models/learning_mode.dart';

// User Preferences with Persistence
final onboardingCompletedProvider = StateProvider<bool>((ref) {
  return ref.watch(userPreferencesServiceProvider).onboardingCompleted;
});

final userConsentProvider = StateProvider<bool>((ref) {
  return ref.watch(userPreferencesServiceProvider).userConsent;
});

final learningModeProvider = StateProvider<LearningMode>((ref) {
  return ref.watch(userPreferencesServiceProvider).learningMode;
});

/// Example provider for theme mode if we add dark mode later.
/// Currently simpler to stick to one cozy theme or system default.
