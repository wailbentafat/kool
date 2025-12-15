import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/mode_detection/models/learning_mode.dart';

/// Tracks if the user has completed the onboarding flow.
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);

/// Tracks if the user has consented to local data collection.
final userConsentProvider = StateProvider<bool>((ref) => false);

/// The current learning mode of the application.
/// Defaults to [LearningMode.normal] until detected or changed.
final learningModeProvider = StateProvider<LearningMode>(
  (ref) => LearningMode.normal,
);

/// Example provider for theme mode if we add dark mode later.
/// Currently simpler to stick to one cozy theme or system default.
