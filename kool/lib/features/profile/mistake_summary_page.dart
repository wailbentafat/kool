import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/cozy_theme.dart';

import '../../shared/models/mistake.dart';
import '../../core/data/local_db.dart';
import 'package:isar/isar.dart';

final mistakesProvider = FutureProvider<List<Mistake>>((ref) async {
  // Fetch all mistakes for now, sorted by time descending
  final isar = await ref.read(localDBProvider).db;
  return await isar.mistakes.where().sortByTimestampDesc().findAll();
});

class MistakeSummaryPage extends ConsumerWidget {
  const MistakeSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mistakesAsync = ref.watch(mistakesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Learning Journey")),
      body: mistakesAsync.when(
        data: (mistakes) {
          if (mistakes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: CozyColors.success,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Great job! No mistakes yet.",
                    style: TextStyle(fontSize: 18, color: CozyColors.textSub),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mistakes.length,
            itemBuilder: (context, index) {
              final mistake = mistakes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mistake.questionText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            color: CozyColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Your Answer: ${mistake.userAnswer}",
                              style: const TextStyle(color: CozyColors.error),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: CozyColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Correct Answer: ${mistake.correctAnswer}",
                              style: const TextStyle(color: CozyColors.success),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
