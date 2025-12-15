import 'package:isar/isar.dart';

part 'mistake.g.dart';

@collection
class Mistake {
  Id id = Isar.autoIncrement;

  late int lessonId;
  late String questionText;
  late String userAnswer;
  late String correctAnswer;
  late DateTime timestamp;
}
