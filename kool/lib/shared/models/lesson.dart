import 'package:isar/isar.dart';

part 'lesson.g.dart';

@collection
class Lesson {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;

  @Enumerated(EnumType.ordinal)
  late LessonDifficulty difficulty;

  late String category;

  /// Duration in minutes
  late int duration;
}

enum LessonDifficulty { beginner, intermediate, advanced }
