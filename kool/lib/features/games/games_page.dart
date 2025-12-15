import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/cozy_theme.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brain Games")),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildGameCard(
            context,
            title: "Memory Match",
            description: "Flip cards to find pairs and improve your memory.",
            icon: Icons.grid_view_rounded,
            color: CozyColors.secondary,
            route: '/games/memory',
          ),
          const SizedBox(height: 16),
          _buildGameCard(
            context,
            title: "Speed Reader",
            description: "Tap words as they appear to improve reading speed.",
            icon: Icons.timer,
            color: CozyColors.secondary,
            route: "/games/speed",
          ),
          const SizedBox(height: 16),
          _buildGameCard(
            context,
            title: "Pattern Logic",
            description: "What comes next? Guess the pattern.",
            icon: Icons.lightbulb,
            color: CozyColors.accent,
            route: "/games/pattern",
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(route);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: CozyColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: CozyColors.textSub, height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: CozyColors.textSub,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
