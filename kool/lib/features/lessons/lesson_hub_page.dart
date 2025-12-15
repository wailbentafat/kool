import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/cozy_theme.dart';
import '../../shared/services/lesson_service.dart';
import '../../shared/models/lesson.dart';

class LessonHubPage extends ConsumerWidget {
  const LessonHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(allLessonsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Lessons")),
      body: lessonsAsync.when(
        data: (lessons) {
          if (lessons.isEmpty) {
            return const Center(child: Text("No lessons available."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: lessons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              final colors = [
                CozyColors.primary,
                CozyColors.secondary,
                CozyColors.accent,
                Colors.orange,
              ];
              final color = colors[index % colors.length];

              return _buildLessonCard(
                context,
                title: lesson.title,
                category: lesson.category,
                duration: "${lesson.duration} min",
                color: color,
                isLocked: false, // Unlock all for now
                onTap: () {
                  context.push('/learning-session/${lesson.id}');
                },
              );
            },
          );
        },
        error: (err, stack) =>
            Center(child: Text("Error loading lessons: $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required String title,
    required String category,
    required String duration,
    required Color color,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey.shade200 : CozyColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLocked
                ? Colors.grey.shade300
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isLocked ? Icons.lock_rounded : Icons.play_arrow_rounded,
                color: isLocked ? Colors.white : color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey : CozyColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: isLocked ? Colors.grey : CozyColors.textSub,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.circle,
                        size: 4,
                        color: isLocked ? Colors.grey : CozyColors.textSub,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        duration,
                        style: TextStyle(
                          color: isLocked ? Colors.grey : CozyColors.textSub,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
