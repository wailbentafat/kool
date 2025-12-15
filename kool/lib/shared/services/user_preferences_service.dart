import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/mode_detection/models/learning_mode.dart';

class UserPreferencesService {
  final SharedPreferences _prefs;

  UserPreferencesService(this._prefs);

  static const _keyOnboarding = 'onboarding_completed';
  static const _keyConsent = 'user_consent';
  static const _keyMode = 'learning_mode';

  bool get onboardingCompleted => _prefs.getBool(_keyOnboarding) ?? false;
  Future<void> setOnboardingCompleted(bool value) =>
      _prefs.setBool(_keyOnboarding, value);

  bool get userConsent => _prefs.getBool(_keyConsent) ?? false;
  Future<void> setUserConsent(bool value) => _prefs.setBool(_keyConsent, value);

  LearningMode get learningMode {
    final index = _prefs.getInt(_keyMode);
    if (index == null) return LearningMode.normal;
    return LearningMode.values[index];
  }

  Future<void> setLearningMode(LearningMode mode) =>
      _prefs.setInt(_keyMode, mode.index);

  static const _keyTheme = 'theme_mode'; // 0: System, 1: Light, 2: Dark

  ThemeMode get themeMode {
    final index = _prefs.getInt(_keyTheme) ?? 0;
    return ThemeMode.values[index];
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setInt(_keyTheme, mode.index);
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main.dart');
});

final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserPreferencesService(prefs);
});
