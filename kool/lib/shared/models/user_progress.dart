import 'package:isar/isar.dart';

part 'user_progress.g.dart';

@collection
class UserProgress {
  Id id = Isar.autoIncrement;

  late int lessonId;

  late bool isCompleted;

  late int highScore;

  late DateTime lastPlayed;
}
