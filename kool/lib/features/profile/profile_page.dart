import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/cozy_theme.dart';
import '../../shared/services/user_preferences_service.dart';
import '../../shared/providers/global_providers.dart';
import '../mode_detection/models/learning_mode.dart';
import '../../shared/services/progress_service.dart';

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
          Text(
            "Learning Mode",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color, // Subtitle color
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

          // Badges Section
          Text(
            "My Badges",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Consumer(
            builder: (context, ref, _) {
              final progressAsync = ref.watch(userProgressProvider);
              return progressAsync.when(
                data: (progress) {
                  final badges = progress?.badges ?? [];
                  if (badges.isEmpty) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No badges yet. Keep learning! 🚀"),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: badges.length,
                      itemBuilder: (context, index) {
                        final badge = badges[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CozyColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: CozyColors.accent),
                          ),
                          child: Row(
                            children: [
                              const Text("🏆", style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 8),
                              Text(
                                badge,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text("Could not load badges"),
              );
            },
          ),

          const SizedBox(height: 24),

          // Appearance Settings
          Text(
            "Appearance",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color,
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
          Text(
            "Privacy",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color,
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
