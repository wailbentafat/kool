import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/cozy_theme.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../shared/providers/global_providers.dart';
import '../../shared/services/mistake_service.dart';
import '../../shared/services/lesson_service.dart'; // import lesson service
import '../mode_detection/models/learning_mode.dart';

// Local state for the session settings
final sessionFontSizeProvider = StateProvider.autoDispose<double>(
  (ref) => 18.0,
);
final sessionSpacingProvider = StateProvider.autoDispose<double>((ref) => 1.5);
final sessionWordSpacingProvider = StateProvider.autoDispose<double>(
  (ref) => 1.0,
);

// ... (providers remain)

class LearningSessionPage extends ConsumerStatefulWidget {
  final String lessonId; // Still string from router, parse later

  const LearningSessionPage({super.key, required this.lessonId});

  @override
  ConsumerState<LearningSessionPage> createState() =>
      _LearningSessionPageState();
}

class _LearningSessionPageState extends ConsumerState<LearningSessionPage> {
  final ScrollController _scrollController = ScrollController();
  final Stopwatch _sessionTimer = Stopwatch();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isPlaying = false;

  // Tracking
  int _pauseCount = 0;
  DateTime? _lastScrollTime;

  // Quiz State
  bool _isQuizMode = false;
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _sessionTimer.start();
    _lastScrollTime = DateTime.now();
    _scrollController.addListener(_onScroll);
    _initTts();

    // Initial setup based on global mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyInitialModeSettings();
    });
  }

  void _applyInitialModeSettings() {
    final mode = ref.read(learningModeProvider);
    switch (mode) {
      case LearningMode.adhd:
        ref.read(sessionFontSizeProvider.notifier).state = 20.0;
        ref.read(sessionSpacingProvider.notifier).state = 2.0;
        ref.read(sessionWordSpacingProvider.notifier).state = 2.0;
        break;
      case LearningMode.dyslexia:
        ref.read(sessionFontSizeProvider.notifier).state = 22.0;
        ref.read(sessionSpacingProvider.notifier).state = 1.8;
        ref.read(sessionWordSpacingProvider.notifier).state = 1.5;
        break;
      case LearningMode.normal:
        break;
    }
  }

  void _onScroll() {
    final now = DateTime.now();
    final difference = now.difference(_lastScrollTime!).inSeconds;

    if (difference > 5) {
      _pauseCount++;
      _adaptToPauses();
    }
    _lastScrollTime = now;
  }

  void _adaptToPauses() {
    if (_pauseCount > 3) {
      final currentSpacing = ref.read(sessionSpacingProvider);
      if (currentSpacing < 2.5) {
        ref.read(sessionSpacingProvider.notifier).state = currentSpacing + 0.2;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("We increased spacing to help you focus."),
            duration: Duration(seconds: 2),
            backgroundColor: CozyColors.primary,
          ),
        );
        _pauseCount = 0;
      }
    }
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _showFeedback(bool isCorrect, String explanation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCorrect ? "Correct! 🎉" : "Not quite.",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(explanation),
          ],
        ),
        backgroundColor: isCorrect ? CozyColors.success : CozyColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Need to extract questions from the fetches lesson.

  @override
  void dispose() {
    _scrollController.dispose();
    _sessionTimer.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(sessionFontSizeProvider);
    final height = ref.watch(sessionSpacingProvider);
    final wordSpacing = ref.watch(sessionWordSpacingProvider);

    final lessonIdInt =
        int.tryParse(widget.lessonId) ?? 1; // Default to 1 if fail
    final lessonAsync = ref.watch(lessonDetailsProvider(lessonIdInt));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: lessonAsync.when(
          data: (lesson) => Text(lesson?.title ?? "Lesson"),
          error: (_, __) => const Text("Error"),
          loading: () => const Text("Loading..."),
        ),
        actions: [
          if (!_isQuizMode) ...[
            IconButton(
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.volume_up_rounded,
              ),
              color: _isPlaying ? CozyColors.primary : CozyColors.textMain,
              onPressed: () {
                lessonAsync.whenData((lesson) {
                  if (lesson != null) _toggleAudio(lesson.content);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.text_fields_rounded),
              onPressed: () => _showformattingSettings(context),
            ),
          ],
        ],
      ),
      body: lessonAsync.when(
        data: (lesson) {
          if (lesson == null) {
            return const Center(child: Text("Lesson not found"));
          }
          return _isQuizMode
              ? _buildQuizUI(lesson)
              : _buildContentUI(lesson, fontSize, height, wordSpacing);
        },
        error: (err, stack) => Center(child: Text("Error: $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _toggleAudio(String content) async {
    if (_isPlaying) {
      await _flutterTts.stop();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      if (mounted) setState(() => _isPlaying = true);
      await _flutterTts.speak(content);
    }
  }

  Widget _buildContentUI(
    var lesson,
    double fontSize,
    double height,
    double wordSpacing,
  ) {
    // var lesson to avoid import issues here, but it is Lesson
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: CozyColors.textMain,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            lesson.content,
            style: GoogleFonts.outfit(
              fontSize: fontSize,
              height: height,
              wordSpacing: wordSpacing,
              color: CozyColors.textMain, // Dynamic text color
            ),
          ),
          const SizedBox(height: 48),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isQuizMode = true;
                });
              },
              icon: const Icon(Icons.quiz_rounded),
              label: const Text("Take Quiz"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizUI(var lesson) {
    if (lesson.questions.isEmpty) {
      // Assuming questions is available
      return const Center(child: Text("No quiz available for this lesson."));
    }

    // We need to map the Isar List<QuizQuestion> to what the UI expects
    // Actually we can just use the object directly if we typed it, but for safety:
    final question = lesson.questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Question ${_currentQuestionIndex + 1} of ${lesson.questions.length}",
            style: const TextStyle(color: CozyColors.textSub),
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CozyColors.textMain,
            ),
          ),
          const SizedBox(height: 32),
          ...(question.options as List<String>).asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: CozyColors.textMain,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                ),
                // Need to update _submitAnswer to take lesson as well or just pass data
                onPressed: () => _submitAnswer(entry.key, lesson),
                child: Text(entry.value, style: const TextStyle(fontSize: 18)),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _submitAnswer(int selectedIndex, var lesson) {
    final currentQ = lesson.questions[_currentQuestionIndex];
    final correctIndex = currentQ.correctIndex;

    if (selectedIndex == correctIndex) {
      _score++;
      _showFeedback(true, currentQ.explanation);
    } else {
      _showFeedback(false, currentQ.explanation);
      ref
          .read(mistakeServiceProvider)
          .logMistake(
            lessonId: int.tryParse(widget.lessonId) ?? 1,
            question: currentQ.question,
            userAnswer: currentQ.options[selectedIndex],
            correctAnswer: currentQ.options[correctIndex],
          );
    }

    if (_currentQuestionIndex < lesson.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showCompletionDialog(lesson.questions.length); // Pass total
    }
  }

  void _showCompletionDialog(int total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Lesson Complete!"),
        content: Text("You scored $_score/$total"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close page
            },
            child: const Text("Finish"),
          ),
        ],
      ),
    );
  }

  void _showformattingSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CozyColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final fontSize = ref.watch(sessionFontSizeProvider);
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Text Size",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: fontSize,
                  min: 14.0,
                  max: 32.0,
                  activeColor: CozyColors.primary,
                  onChanged: (val) =>
                      ref.read(sessionFontSizeProvider.notifier).state = val,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
