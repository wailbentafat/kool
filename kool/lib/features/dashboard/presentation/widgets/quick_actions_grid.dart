import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/cozy_theme.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildRoundActionButton(
              context,
              icon: Icons.history_edu_rounded, // or Icons.hourglass_bottom
              label: "Time Travel",
              color: Colors.indigo, // New color for Wow feature
              onTap: () => context.push('/roleplay'),
              delay: 500.ms,
            ),
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
