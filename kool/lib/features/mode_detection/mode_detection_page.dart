import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/cozy_theme.dart';
import '../../shared/providers/global_providers.dart';
import '../../shared/services/mock_ai_service.dart';
import 'models/learning_mode.dart';

class ModeDetectionPage extends ConsumerStatefulWidget {
  const ModeDetectionPage({super.key});

  @override
  ConsumerState<ModeDetectionPage> createState() => _ModeDetectionPageState();
}

class _ModeDetectionPageState extends ConsumerState<ModeDetectionPage> {
  // Metric trackers
  int _wordsRead = 0;
  int _errors = 0;
  int _hesitations = 0;
  final Stopwatch _stopwatch = Stopwatch();
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  void _finishTask() async {
    _stopwatch.stop();
    setState(() {
      _isAnalyzing = true;
    });

    final elapsedSeconds = _stopwatch.elapsedMilliseconds / 1000;
    final wpm = (_wordsRead / (elapsedSeconds / 60)).round();

    // Call Mock AI
    final mode = await ref
        .read(mockAIProvider)
        .analyzeBehavior(
          readingSpeedWPM: wpm,
          errorCount: _errors,
          hesitationCount: _hesitations,
        );

    if (!mounted) return;

    // Save mode
    ref.read(learningModeProvider.notifier).state = mode;

    // Show result dialog then go to dashboard
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ModeResultDialog(mode: mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isAnalyzing) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: CozyColors.primary),
              SizedBox(height: 16),
              Text(
                "Personalizing your experience...",
                style: TextStyle(color: CozyColors.textSub),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Quick Check-in")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Read this short text and tap the button when done.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      "The quick brown fox jumps over the lazy dog. Learning is a journey, not a race. Take your time and breathe.",
                      style: GoogleFonts.outfit(fontSize: 24, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hidden debug buttons to simulate behavior
                IconButton(
                  icon: const Icon(Icons.bug_report, color: Colors.transparent),
                  onPressed: () {
                    _errors++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Simulated Error"),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.timer, color: Colors.transparent),
                  onPressed: () {
                    _hesitations++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Simulated Hesitation"),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _wordsRead = 20; // Approx word count of text
                _finishTask();
              },
              child: const Text("I'm Done"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeResultDialog extends StatelessWidget {
  final LearningMode mode;

  const _ModeResultDialog({required this.mode});

  @override
  Widget build(BuildContext context) {
    String title;
    String description;
    IconData icon;

    switch (mode) {
      case LearningMode.adhd:
        title = "Focus Mode Activated";
        description =
            "We've reduced distractions and increased text spacing for you.";
        icon = Icons.center_focus_strong_rounded;
        break;
      case LearningMode.dyslexia:
        title = "Dyslexia Support Active";
        description =
            "We've adjusted fonts and contrast to make reading easier.";
        icon = Icons.text_fields_rounded;
        break;
      case LearningMode.normal:
        title = "You're All Set!";
        description = "We've customized the app to your reading pace.";
        icon = Icons.check_circle_rounded;
        break;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: CozyColors.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: CozyColors.textSub),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/dashboard'),
            child: const Text("Go to Dashboard"),
          ),
        ],
      ),
    );
  }
}
