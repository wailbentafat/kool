import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/cozy_theme.dart';
import '../../../../shared/services/lesson_service.dart';
import '../../../mode_detection/models/learning_mode.dart';
import '../../../../shared/providers/global_providers.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/quick_actions_grid.dart';

// Mock providers for Dashboard stats
final focusLevelProvider = Provider<int>((ref) => 85);
final streakProvider = Provider<int>((ref) => 5);

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(learningModeProvider);
    final focusLevel = ref.watch(focusLevelProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashboardHeader(mode: mode),
              const SizedBox(height: 32),
              const ContinueLearningCard(),
              const SizedBox(height: 24),
              StatsRow(focusLevel: focusLevel, streak: streak),
              const SizedBox(height: 24),
              const QuickActionsGrid(),
              const SizedBox(height: 32),
              _buildExploreCourses(context),
              const SizedBox(height: 32),
              _buildDailyTip(context),
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Refactor these remaining widgets into separate files as well
  Widget _buildExploreCourses(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final lessonsAsync = ref.watch(allLessonsProvider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore Courses",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: lessonsAsync.when(
                data: (lessons) {
                  if (lessons.isEmpty) return const SizedBox.shrink();

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: lessons.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      final colors = [
                        CozyColors.primary,
                        CozyColors.secondary,
                        CozyColors.accent,
                        Colors.orange,
                        Colors.purple,
                        Colors.pink,
                      ];
                      final color = colors[index % colors.length];

                      final icons = [
                        Icons.star_rounded,
                        Icons.water_drop,
                        Icons.pets,
                        Icons.science,
                      ];
                      final icon = icons[index % icons.length];

                      return GestureDetector(
                            onTap: () {
                              context.push('/learning-session/${lesson.id}');
                            },
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: color.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, color: color),
                                  ),
                                  const Spacer(),
                                  Text(
                                    lesson.category,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Start",
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (200 + (index * 100)).ms)
                          .slideX();
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDailyTip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CozyColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: CozyColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text("💡", style: TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Did You Know?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Octopuses have three hearts and blue blood!",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1200.ms).scale();
  }
}
