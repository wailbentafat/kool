import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/local_db.dart';
import '../models/lesson.dart';

class LessonService {
  final LocalDB _localDB;

  LessonService(this._localDB);

  Future<void> seedInitialLessons() async {
    final isar = await _localDB.db;
    final count = await isar.lessons.count();
    if (count > 0) return; // Already seeded

    final lessons = [
      Lesson()
        ..title = "The Solar System"
        ..category = "Science"
        ..difficulty = LessonDifficulty.beginner
        ..duration = 5
        ..content = """
The Solar System is our home in the galaxy. It consists of the Sun and everything that orbits around it. This includes eight planets and their moons, as well as dwarf planets, asteroids, and comets.

The Sun is a star. It is a huge ball of hot gas that gives off light and heat. It is by far the most important object in the Solar System, as it contains 99.8% of the Solar System's mass.

The four inner planets are Mercury, Venus, Earth, and Mars. They are called terrestrial planets because they are made mostly of rock and metal. Earth is the only planet known to support life, thanks to its liquid water and breathable atmosphere.

The four outer planets are Jupiter, Saturn, Uranus, and Neptune. These are often called gas giants. Jupiter is the largest planet in the Solar System. Saturn is famous for its beautiful rings.
"""
        ..questions = [
          QuizQuestion()
            ..question = "What is the largest planet?"
            ..options = ["Earth", "Mars", "Jupiter", "Venus"]
            ..correctIndex = 2
            ..explanation =
                "Jupiter is the largest planet in our solar system.",
          QuizQuestion()
            ..question = "Which planet has rings?"
            ..options = ["Mercury", "Saturn", "Mars", "Earth"]
            ..correctIndex = 1
            ..explanation = "Saturn is famous for its beautiful rings.",
        ],
      Lesson()
        ..title = "Ocean Life"
        ..category = "Nature"
        ..difficulty = LessonDifficulty.beginner
        ..duration = 8
        ..content = """
The ocean is a huge body of saltwater that covers about 71% of the Earth's surface. It is home to a vast variety of life, from microscopic plankton to the largest animal on Earth, the blue whale.

Coral reefs are like underwater cities. They are built by tiny animals called polyps. Reefs provide shelter for thousands of fish species. Protecting them is very important for the health of our oceans.

Sharks are often misunderstood. While some are predators, play a crucial role in keeping the ocean ecosystem balanced. Most sharks are not dangerous to humans.

Dolphins are highly intelligent marine mammals. They live in groups called pods and are known for their playful behavior and ability to communicate with clicks and whistles.
"""
        ..questions = [
          QuizQuestion()
            ..question = "What covers 71% of Earth?"
            ..options = ["Forests", "The Ocean", "Deserts", "Ice"]
            ..correctIndex = 1
            ..explanation =
                "The ocean covers the majority of our planet's surface.",
          QuizQuestion()
            ..question = "What are coral reefs built by?"
            ..options = ["Rocks", "Plants", "Polyps", "Fish"]
            ..correctIndex = 2
            ..explanation =
                "Tiny animals called polyps build the structures of coral reefs.",
        ],
      Lesson()
        ..title = "Dinosaurs"
        ..category = "History"
        ..difficulty = LessonDifficulty.intermediate
        ..duration = 10
        ..content = """
Dinosaurs ruled the Earth for over 160 million years! They came in all shapes and sizes. Some were small as chickens, while others were larger than houses.

The Tyrannosaurus Rex, or T-Rex, is one of the most famous dinosaurs. It was a fierce predator with giant teeth and tiny arms. It lived during the late Cretaceous period.

Not all dinosaurs were meat-eaters. The Triceratops was a herbivore, meaning it only ate plants. It had three horns on its face to protect itself from predators.

Dinosaurs went extinct about 65 million years ago. Scientists believe a giant asteroid hit Earth, changing the climate so drastically that they couldn't survive. Birds are the closest living relatives of dinosaurs today!
"""
        ..questions = [
          QuizQuestion()
            ..question = "What did Triceratops eat?"
            ..options = ["Meat", "Plants", "Fish", "Insects"]
            ..correctIndex = 1
            ..explanation = "Triceratops was a herbivore, so it ate plants.",
          QuizQuestion()
            ..question = "What are the closest living relatives of dinosaurs?"
            ..options = ["Lizards", "Birds", "Crocodiles", "Snakes"]
            ..correctIndex = 1
            ..explanation =
                "Birds evolved from a group of meat-eating dinosaurs.",
        ],
      Lesson()
        ..title = "Photosynthesis"
        ..category = "Science"
        ..difficulty = LessonDifficulty.advanced
        ..duration = 12
        ..content = """
Photosynthesis is the process by which plants make their own food. To do this, they need three things: sunlight, water, and carbon dioxide.

Plants have a special chemical called chlorophyll, which makes them green. Chlorophyll captures energy from the sun. The plant uses this energy to mix water and carbon dioxide together to create sugar (glucose), which is their food.

During this process, plants verify oxygen back into the air. This is why plants are so important for us humans and animals—we need the oxygen they produce to breathe!

Without photosynthesis, most life on Earth would not exist. It is the foundation of the food chain.
"""
        ..questions = [
          QuizQuestion()
            ..question = "What makes plants green?"
            ..options = ["Sugar", "Water", "Chlorophyll", "Oxygen"]
            ..correctIndex = 2
            ..explanation =
                "Chlorophyll is the pigment that gives plants their green color.",
          QuizQuestion()
            ..question = "What do plants release that we breathe?"
            ..options = ["Carbon Dioxide", "Oxygen", "Nitrogen", "Helium"]
            ..correctIndex = 1
            ..explanation =
                "Plants release oxygen as a byproduct of photosynthesis.",
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
