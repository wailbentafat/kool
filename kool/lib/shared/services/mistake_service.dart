import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/data/local_db.dart';
import '../../shared/models/mistake.dart';

class MistakeService {
  final LocalDB _localDB;

  MistakeService(this._localDB);

  Future<void> logMistake({
    required int lessonId,
    required String question,
    required String userAnswer,
    required String correctAnswer,
  }) async {
    final isar = await _localDB.db;
    final mistake = Mistake()
      ..lessonId = lessonId
      ..questionText = question
      ..userAnswer = userAnswer
      ..correctAnswer = correctAnswer
      ..timestamp = DateTime.now();

    await isar.writeTxn(() async {
      await isar.mistakes.put(mistake);
    });
  }

  Future<List<Mistake>> getMistakesForLesson(int lessonId) async {
    final isar = await _localDB.db;
    return await isar.mistakes.filter().lessonIdEqualTo(lessonId).findAll();
  }
}

final mistakeServiceProvider = Provider<MistakeService>((ref) {
  final localDB = ref.read(localDBProvider);
  return MistakeService(localDB);
});
