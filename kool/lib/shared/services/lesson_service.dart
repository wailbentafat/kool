import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/local_db.dart';
import '../models/lesson.dart';

class LessonService {
  final LocalDB _localDB;

  LessonService(this._localDB);

  Future<void> seedInitialLessons() async {
    final isar = await _localDB.db;

    // Check if we have our "showcase" lesson yet
    final existing = await isar.lessons
        .filter()
        .titleEqualTo("The Human Brain 🧠")
        .findFirst();
    if (existing != null) return;

    final lessons = [
      Lesson()
        ..title = "The Human Brain 🧠"
        ..category = "Biology"
        ..difficulty = LessonDifficulty.advanced
        ..duration = 15
        ..content = """
The human brain is the most complex organ in the body. It controls everything we do, from breathing and sleeping to thinking and feeling emotions. 🤯

### 1. The Cerebrum
The largest part of the brain is the **Cerebrum**. It is divided into two halves called hemispheres. This part handles:
*   Thinking and Learning 🎓
*   Five Senses (Sight, Sound, Touch...) 🖐️
*   Memory 🗓️

### 2. The Cerebellum
Located at the back of the brain, the **Cerebellum** (or "little brain") helps you:
*   Balance while walking 🚶
*   Coordinate muscles for sports ⚽

### 3. The Brain Stem
This connects the brain to the spinal cord. It controls automatic things we don't think about, like:
*   Heartbeat ❤️
*   Digestion 🥪
*   Breathing 🌬️

Your brain sends lightning-fast signals through neurons. It's like a supercomputer that never turns off!
"""
        ..questions = [
          QuizQuestion()
            ..question = "Which part of the brain controls balance?"
            ..options = ["Cerebrum", "Cerebellum", "Brain Stem", "Heart"]
            ..correctIndex = 1
            ..explanation =
                "The Cerebellum (little brain) is responsible for balance and coordination.",
          QuizQuestion()
            ..question = "What does the Brain Stem control?"
            ..options = ["Thinking", "Running", "Heartbeat", "Memory"]
            ..correctIndex = 2
            ..explanation =
                "The Brain Stem manages automatic functions like your heartbeat and breathing.",
        ],
      Lesson()
        ..title = "Ancient Egypt 🏺"
        ..category = "History"
        ..difficulty = LessonDifficulty.intermediate
        ..duration = 12
        ..content = """
Ancient Egypt was one of the greatest civilizations in history. It began over 5,000 years ago along the **Nile River**. 🌊

### The Pharaohs 👑
Egypt was ruled by kings called Pharaohs. They were believed to be gods on Earth. Famous pharaohs include:
*   **Tutankhamun** (The Boy King)
*   **Cleopatra**
*   **Ramses II**

### The Pyramids 🔺
The ancient Egyptians built massive stone tombs called pyramids for their pharaohs. The Great Pyramid of Giza is the largest and is one of the Seven Wonders of the World!

### Mummies 🤕
To prepare for the afterlife, Egyptians preserved bodies as **mummies**. They removed organs and wrapped the body in linen cloth.
"""
        ..questions = [
          QuizQuestion()
            ..question = "Why did Egyptians build pyramids?"
            ..options = ["As houses", "As tombs", "For storage", "As temples"]
            ..correctIndex = 1
            ..explanation =
                "Pyramids were built as grand tombs for the Pharaohs.",
          QuizQuestion()
            ..question = "Which river was important to Ancient Egypt?"
            ..options = ["Amazon", "Nile", "Mississippi", "Danube"]
            ..correctIndex = 1
            ..explanation =
                "The Nile River provided water and fertile land for the civilization.",
        ],
    ];

    await isar.writeTxn(() async {
      await isar.lessons.putAll(lessons);
    });
  }

  Future<List<Lesson>> getAllLessons() async {
    final isar = await _localDB.db;
    return await isar.lessons.where().findAll();
  }

  Future<Lesson?> getLesson(int id) async {
    final isar = await _localDB.db;
    return await isar.lessons.get(id);
  }
}

final lessonServiceProvider = Provider<LessonService>((ref) {
  final localDB = ref.read(localDBProvider);
  return LessonService(localDB);
});

final allLessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final service = ref.watch(lessonServiceProvider);
  return await service.getAllLessons();
});

final lessonDetailsProvider = FutureProvider.family<Lesson?, int>((
  ref,
  id,
) async {
  final service = ref.watch(lessonServiceProvider);
  return await service.getLesson(id);
});
