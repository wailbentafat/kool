import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/cozy_theme.dart';
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
                    }
                  },
                ),
              ],
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
          SwitchListTile(
            value: consent,
            title: const Text("Allow Local Usage Analysis"),
            subtitle: const Text(
              "Helps adapt the app to your needs. No data leaves device.",
            ),
            activeThumbColor: CozyColors.success,
            onChanged: (val) {
              ref.read(userConsentProvider.notifier).state = val;
            },
          ),
        ],
      ),
    );
  }
}
