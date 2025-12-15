import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/local_db.dart';
import '../../shared/models/user_progress.dart';
import 'package:isar/isar.dart';

class UserProgressService {
  final LocalDB _localDB;

  UserProgressService(this._localDB);

  Future<UserProgress?> getProgressForLesson(int lessonId) async {
    final isar = await _localDB.db;
    return await isar.userProgress
        .filter()
        .lessonIdEqualTo(lessonId)
        .findFirst();
  }

  Future<void> updateProgress({
    required int lessonId,
    required int score,
    bool isCompleted = true,
  }) async {
    final isar = await _localDB.db;
    final existing = await getProgressForLesson(lessonId);

    final progress = existing ?? UserProgress()
      ..lessonId = lessonId;

    progress.isCompleted = isCompleted;
    progress.highScore = score > (progress.highScore)
        ? score
        : progress.highScore;
    progress.lastPlayed = DateTime.now();

    // Simple streak logic: if played today, streak logic would be more complex in real app
    // For now, just increment global streak in a separate singleton setting or keep it per lesson?
    // The requirement says "Daily Progress". We might need a separate 'UserProfile' or 'DailyStats' object.
    // user_progress.dart seems to be per-lesson.
    // Let's create a separate logic for "Daily Streak" using SharedPreferences or a separate singleton entry in Isar.

    await isar.writeTxn(() async {
      await isar.userProgress.put(progress);
    });
  }

  // Mock calculation for "Focus Level"
  int calculateFocusLevel(int recentMistakes) {
    // 100 - (mistakes * 5), clamped between 0 and 100
    int base = 100;
    int penalty = recentMistakes * 10;
    return (base - penalty).clamp(0, 100);
  }
}

final userProgressServiceProvider = Provider<UserProgressService>((ref) {
  final localDB = ref.read(localDBProvider);
  return UserProgressService(localDB);
});
