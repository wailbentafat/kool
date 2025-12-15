import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/cozy_theme.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../shared/providers/global_providers.dart';
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
  final String title;
  final String content;

  const LearningSessionPage({
    super.key,
    this.title = "The Solar System",
    this.content =
        "The Solar System is our home in the galaxy. It consists of the Sun and everything that orbits around it. This includes eight planets and their moons, as well as dwarf planets, asteroids, and comets.\n\nThe Sun is a star. It is a huge ball of hot gas that gives off light and heat. It is by far the most important object in the Solar System, as it contains 99.8% of the Solar System's mass.\n\nThe four inner planets are Mercury, Venus, Earth, and Mars. They are called terrestrial planets because they are made mostly of rock and metal. Earth is the only planet known to support life, thanks to its liquid water and breathable atmosphere.\n\nThe four outer planets are Jupiter, Saturn, Uranus, and Neptune. These are often called gas giants. Jupiter is the largest planet in the Solar System. Saturn is famous for its beautiful rings.\n\nBeyond Neptune lies the Kuiper Belt, a region filled with icy bodies. This is where the dwarf planet Pluto resides. Exploring space helps us understand where we imply came from and if we are alone in the universe.",
  });

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
        // Dyslexia often benefits from larger spacing and sans-serif (already used)
        ref.read(sessionFontSizeProvider.notifier).state = 22.0;
        ref.read(sessionSpacingProvider.notifier).state = 1.8;
        ref.read(sessionWordSpacingProvider.notifier).state = 1.5;
        break;
      case LearningMode.normal:
        // Defaults
        break;
    }
  }

  void _onScroll() {
    final now = DateTime.now();
    final difference = now.difference(_lastScrollTime!).inSeconds;

    // Detect pauses (simple heuristic)
    if (difference > 5) {
      _pauseCount++;
      _adaptToPauses();
    }
    _lastScrollTime = now;
  }

  void _adaptToPauses() {
    // If pausing frequently, increase spacing helpful for focus
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
        _pauseCount = 0; // Reset after adaptation
      }
    }
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Slower for learning
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _toggleAudio() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      if (mounted) setState(() => _isPlaying = true);
      await _flutterTts.speak(widget.content);
    }
  }

  // ... (existing tracking methods)

  @override
  void dispose() {
    _scrollController.dispose();
    _sessionTimer.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read dynamic settings
    final fontSize = ref.watch(sessionFontSizeProvider);
    final height = ref.watch(sessionSpacingProvider);
    final wordSpacing = ref.watch(sessionWordSpacingProvider);

    return Scaffold(
      backgroundColor: CozyColors.background,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              _isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.volume_up_rounded,
            ),
            color: _isPlaying ? CozyColors.primary : CozyColors.textMain,
            onPressed: _toggleAudio,
          ),
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            onPressed: () => _showformattingSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CozyColors.textMain,
              ),
            ),
            const SizedBox(height: 24),
            // Content
            Text(
              widget.content,
              style: GoogleFonts.outfit(
                fontSize: fontSize,
                height: height,
                wordSpacing: wordSpacing,
                color: CozyColors.textMain,
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text("Complete Session"),
              ),
            ),
          ],
        ),
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
