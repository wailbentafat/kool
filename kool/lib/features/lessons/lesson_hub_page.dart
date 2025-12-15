import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/cozy_theme.dart';

class LessonHubPage extends ConsumerWidget {
  const LessonHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Lessons")),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildLessonCard(
            context,
            title: "The Solar System",
            category: "Science",
            duration: "5 min",
            color: CozyColors.primary,
            isLocked: false,
            onTap: () {
              context.push(
                '/learning-session',
                extra: {
                  'title': "The Solar System",
                  'content':
                      "The Solar System is our home in the galaxy. It consists of the Sun and everything that orbits around it. This includes eight planets and their moons, as well as dwarf planets, asteroids, and comets.\n\nThe Sun is a star. It is a huge ball of hot gas that gives off light and heat. It is by far the most important object in the Solar System, as it contains 99.8% of the Solar System's mass.\n\nThe four inner planets are Mercury, Venus, Earth, and Mars. They are called terrestrial planets because they are made mostly of rock and metal. Earth is the only planet known to support life, thanks to its liquid water and breathable atmosphere.\n\nThe four outer planets are Jupiter, Saturn, Uranus, and Neptune. These are often called gas giants. Jupiter is the largest planet in the Solar System. Saturn is famous for its beautiful rings.",
                },
              );
            },
          ),
          const SizedBox(height: 16),
          _buildLessonCard(
            context,
            title: "Ocean Life",
            category: "Nature",
            duration: "8 min",
            color: CozyColors.secondary,
            isLocked: false,
            onTap: () {
              // Future: Navigate to dynamic lesson page
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Coming soon!")));
            },
          ),
          const SizedBox(height: 16),
          _buildLessonCard(
            context,
            title: "Dinosaurs",
            category: "History",
            duration: "10 min",
            color: Colors.orange,
            isLocked: true,
            onTap: () {},
          ),
        ],
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
