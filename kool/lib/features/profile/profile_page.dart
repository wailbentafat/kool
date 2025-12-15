import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/cozy_theme.dart';
import '../../shared/services/user_preferences_service.dart';
import '../../shared/providers/global_providers.dart';
import '../mode_detection/models/learning_mode.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(learningModeProvider);
    final consent = ref.watch(userConsentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings")),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // User Info
          Center(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.history_edu_rounded,
                    color: CozyColors.primary,
                  ),
                  title: const Text('My Mistakes'),
                  subtitle: const Text('Review what you missed'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/mistakes'),
                ),
                const Divider(),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: CozyColors.primary,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Student",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Learning Mode Settings
          const Text(
            "Learning Mode",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CozyColors.textSub,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                RadioListTile<LearningMode>(
                  title: const Text("Standard Mode"),
                  value: LearningMode.normal,
                  groupValue: mode,
                  activeColor: CozyColors.primary,
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(learningModeProvider.notifier).state = val;
                      ref
                          .read(userPreferencesServiceProvider)
                          .setLearningMode(val);
                    }
                  },
                ),
                RadioListTile<LearningMode>(
                  title: const Text("Focus Mode (ADHD Support)"),
                  value: LearningMode.adhd,
                  groupValue: mode,
                  activeColor: CozyColors.primary,
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(learningModeProvider.notifier).state = val;
                      ref
                          .read(userPreferencesServiceProvider)
                          .setLearningMode(val);
                    }
                  },
                ),
                RadioListTile<LearningMode>(
                  title: const Text("Dyslexia Support"),
                  value: LearningMode.dyslexia,
                  groupValue: mode,
                  activeColor: CozyColors.primary,
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(learningModeProvider.notifier).state = val;
                      ref
                          .read(userPreferencesServiceProvider)
                          .setLearningMode(val);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appearance Settings
          const Text(
            "Appearance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CozyColors.textSub,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              title: const Text("Sleepy Mode 🌙"),
              subtitle: const Text("Dark theme for night-time learning"),
              value: ref.watch(themeModeProvider) == ThemeMode.dark,
              activeThumbColor: CozyColors.accent,
              onChanged: (isDark) {
                final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
                ref.read(themeModeProvider.notifier).state = newMode;
                ref.read(userPreferencesServiceProvider).setThemeMode(newMode);
              },
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            "Privacy",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CozyColors.textSub,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              value: consent,
              title: const Text("Allow Local Usage Analysis"),
              subtitle: const Text(
                "Helps adapt the app to your needs. No data leaves device.",
              ),
              activeColor: CozyColors.success,
              onChanged: (val) {
                ref.read(userConsentProvider.notifier).state = val;
                ref.read(userPreferencesServiceProvider).setUserConsent(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
