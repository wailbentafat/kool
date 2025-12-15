import 'package:isar/isar.dart';

part 'user_progress.g.dart';

@collection
class UserProgress {
  Id id = Isar.autoIncrement;

  late int lessonId;

  late bool isCompleted;

  late int highScore;

  late DateTime lastPlayed;

  int currentStreak = 0;

  /// 0 to 100
  int focusScore = 50;

  List<String> badges = [];
}
