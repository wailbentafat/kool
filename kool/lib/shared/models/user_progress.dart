import 'package:isar/isar.dart';
import '../../features/mode_detection/models/learning_mode.dart';

part 'user_progress.g.dart';

@collection
class UserProgress {
  Id id = Isar.autoIncrement;

  @enumerated
  late LearningMode learningMode;

  List<String> badges = []; // storage for badge IDs or Names

  UserProgress() {
    // Default values
    learningMode = LearningMode.normal;
    badges = [];
  }

  late int lessonId;

  late bool isCompleted;

  late int highScore;

  late DateTime lastPlayed;

  int currentStreak = 0;

  /// 0 to 100
  int focusScore = 50;
}
