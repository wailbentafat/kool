import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../mode_detection/models/learning_mode.dart';

class DashboardHeader extends StatelessWidget {
  final LearningMode mode;

  const DashboardHeader({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ready to learn something new?",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 16),
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
}
