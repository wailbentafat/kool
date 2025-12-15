import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress.dart';
import '../../core/data/local_db.dart';
import 'package:isar/isar.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  final localDB = ref.watch(localDBProvider);
  return ProgressService(localDB);
});

final userProgressProvider = FutureProvider<UserProgress?>((ref) async {
  final service = ref.watch(progressServiceProvider);
  return service.getUserProgress();
});

class ProgressService {
  final LocalDB _localDB;

  ProgressService(this._localDB);

  Future<UserProgress?> getUserProgress() async {
    final isar = await _localDB.db;
    return isar.userProgress.where().findFirst();
  }

  Future<void> awardBadge(String badgeName) async {
    final isar = await _localDB.db;
    final progress =
        await isar.userProgress.where().findFirst() ?? UserProgress();

    if (!progress.badges.contains(badgeName)) {
      progress.badges = [...progress.badges, badgeName];
      await isar.writeTxn(() async {
        await isar.userProgress.put(progress);
      });
    }
  }

  Future<void> updateStreak(int newStreak) async {
    final isar = await _localDB.db;
    final progress =
        await isar.userProgress.where().findFirst() ?? UserProgress();
    progress.currentStreak = newStreak;
    await isar.writeTxn(() async {
      await isar.userProgress.put(progress);
    });
  }
}
