import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/roleplay_providers.dart';
import '../../domain/entities/roleplay_character.dart';

class RoleplayLandingPage extends ConsumerWidget {
  const RoleplayLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(roleplayCharactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Travel Buddies ⏳"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Who do you want to talk to?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Pick a History Hero and ask them anything!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: characters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final char = characters[index];
                  return _buildCharacterCard(context, char, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(
    BuildContext context,
    RoleplayCharacter char,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        context.push('/roleplay-chat/${char.id}');
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: char.themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: char.themeColor.withOpacity(0.3), width: 2),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: 'avatar_${char.id}',
                child: Text(
                  char.avatarEmoji,
                  style: const TextStyle(fontSize: 64),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    char.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    char.role,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  CircleAvatar(
                        backgroundColor: char.themeColor,
                        child: const Icon(Icons.mic, color: Colors.white),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                      ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (200 * index).ms).slideX();
  }
}
