import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/mode_detection/models/learning_mode.dart';

class MockAIService {
  /// Simulates analyzing user behavior to determine learning mode.
  ///
  /// Rules:
  /// - High error rate (> 2) -> DyslexiaMode
  /// - Fast actions but sporadic (simulated by [hesitationCount]) -> ADHDMode
  /// - Otherwise -> NormalMode
  Future<LearningMode> analyzeBehavior({
    required int readingSpeedWPM,
    required int errorCount,
    required int hesitationCount,
  }) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (errorCount > 2) {
      return LearningMode.dyslexia;
    }

    if (readingSpeedWPM > 200 && hesitationCount > 3) {
      return LearningMode.adhd;
    }

    return LearningMode.normal;
  }
}

final mockAIProvider = Provider<MockAIService>((ref) {
  return MockAIService();
});
