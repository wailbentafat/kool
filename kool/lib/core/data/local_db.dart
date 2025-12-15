import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../shared/models/lesson.dart';
import '../../shared/models/user_progress.dart';
import '../../shared/models/mistake.dart';

class LocalDB {
  late Future<Isar> db;

  LocalDB() {
    db = _initDB();
  }

  Future<Isar> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([
        LessonSchema,
        UserProgressSchema,
        MistakeSchema,
      ], directory: dir.path);
    }
    return Isar.getInstance()!;
  }
}

final localDBProvider = Provider<LocalDB>((ref) => LocalDB());
