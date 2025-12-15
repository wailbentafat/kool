import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/theme/cozy_theme.dart';
import '../../shared/providers/global_providers.dart';
import '../mode_detection/models/learning_mode.dart';
import '../../shared/services/lesson_service.dart';
import '../../shared/models/lesson.dart';

// Mock providers for Dashboard stats
final focusLevelProvider = Provider<int>(
  (ref) => 85,
); // TODO: Calculate from mistakes
final streakProvider = Provider<int>(
  (ref) => 5,
); // TODO: Calculate from history

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(learningModeProvider);
    final focusLevel = ref.watch(focusLevelProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Use theme background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, mode),
              const SizedBox(height: 32),
              _buildHeroLessonCard(context),
              const SizedBox(height: 24),
              _buildStatsRow(context, focusLevel, streak),
              const SizedBox(height: 24),
              _buildQuickActionsGrid(context),
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

  // ... (Hero Card remains mostly same but check for text colors inside if needed)
  // Skipping buildHeroLessonCard for now as it uses white text on Primary color which is fine in dark mode too.

  Widget _buildHeader(BuildContext context, LearningMode mode) {
    // Mascot selection based on mode/mood (Simple logic for now)
    String mascot = "🦁"; // Default Lion
    if (mode == LearningMode.adhd) mascot = "🐯"; // Tiger for Focus
    if (mode == LearningMode.dyslexia) mascot = "🦉"; // Owl for Wisdom

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning, Alex! ☀️",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit', // Ensure rounded font
                // Color comes from Theme.textTheme
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ready to learn something new?",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                // Color comes from Theme.textTheme
                fontSize: 16,
              ),
            ),
          ],
        ),
        Text(mascot, style: const TextStyle(fontSize: 48))
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              duration: 1.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
            ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildHeroLessonCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/learning-session/1',
      ), // Hardcoded to first lesson for now
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: CozyColors.primary,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: CozyColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Decoration
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.public,
                size: 200,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "CONTINUE LEARNING",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "The Solar System",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "5 min left",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: CozyColors.primary,
                              size: 32,
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(delay: 2000.ms, duration: 1000.ms),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildStatsRow(BuildContext context, int focus, int streak) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            "Focus Level",
            "$focus%",
            "⚡",
            CozyColors.accent,
            delay: 400.ms,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            "Day Streak",
            "$streak",
            "🔥",
            CozyColors.warning,
            delay: 500.ms,
          ),
        ),
      ],
    );
  }

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

  // Header was updated previously

  // ... (Header already updated in previous step) - Wait, replace_file needs exact context.
  // I need to be careful with StartLine/EndLine. I'll rely on TargetContent.

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String emoji,
    Color color, {
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Adaptive card color
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              // Color adaptive
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              // Color adaptive
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).scale();
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            // Color handled by Theme
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildRoundActionButton(
              context,
              icon: Icons.games_rounded,
              label: "Games",
              color: CozyColors.secondary,
              onTap: () => context.push('/games'),
              delay: 600.ms,
            ),
            _buildRoundActionButton(
              context,
              icon: Icons.auto_awesome_rounded,
              label: "Summarize",
              color: CozyColors.primary,
              onTap: () => context.push('/study-support'),
              delay: 700.ms,
            ),
            _buildRoundActionButton(
              context,
              icon: Icons.person_rounded,
              label: "Profile",
              color: CozyColors.accent,
              onTap: () => context.push('/profile'),
              delay: 800.ms,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required Duration delay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).moveY(begin: 20, end: 0);
  }
}
