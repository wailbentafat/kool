import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/cozy_theme.dart';
import 'dart:math';

class PatternGamePage extends ConsumerStatefulWidget {
  const PatternGamePage({super.key});

  @override
  ConsumerState<PatternGamePage> createState() => _PatternGamePageState();
}

class _PatternGamePageState extends ConsumerState<PatternGamePage> {
  int _score = 0;
  int _level = 1;
  late List<IconData> _sequence;
  late List<IconData> _options;
  late int _correctOptionIndex;

  @override
  void initState() {
    super.initState();
    _startLevel();
  }

  void _startLevel() {
    // Generate a pattern A-B-A-? or A-B-C-?
    final random = Random();
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.cloud,
      Icons.wb_sunny,
      Icons.pets,
      Icons.music_note,
      Icons.bolt,
      Icons.eco,
    ];

    // Simple ABAB pattern for level 1, ABCABC for level 2, etc.
    final patternLength = 2 + (_level % 3);
    final patternIcons = List.generate(
      patternLength,
      (_) => icons[random.nextInt(icons.length)],
    );

    // Create sequence A B A B A (?)
    _sequence = [];
    for (int i = 0; i < 5; i++) {
      _sequence.add(patternIcons[i % patternLength]);
    }

    final correctIcon = patternIcons[5 % patternLength];

    // Generate options including the correct one
    final wrongIcons = icons.where((i) => i != correctIcon).toList()..shuffle();
    _options = [correctIcon, wrongIcons[0], wrongIcons[1]]..shuffle();
    _correctOptionIndex = _options.indexOf(correctIcon);

    setState(() {});
  }

  void _checkAnswer(int index) {
    if (index == _correctOptionIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Correct! +10 Points"),
          backgroundColor: CozyColors.success,
          duration: Duration(milliseconds: 500),
        ),
      );
      setState(() {
        _score += 10;
        _level++;
      });
      Future.delayed(const Duration(milliseconds: 500), _startLevel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Try again!"),
          backgroundColor: CozyColors.error,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pattern Logic"),
        backgroundColor: CozyColors.accent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Level $_level",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Score: $_score",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // The Sequence
            const Text(
              "What comes next?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: [
                ..._sequence.map((icon) => _buildIconBox(icon)),
                _buildIconBox(Icons.question_mark, isQuestion: true),
              ],
            ),

            const Spacer(),

            // Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_options.length, (index) {
                return GestureDetector(
                  onTap: () => _checkAnswer(index),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: CozyColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: CozyColors.primary.withAlpha(50),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _options[index],
                      size: 40,
                      color: CozyColors.primary,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, {bool isQuestion = false}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isQuestion
            ? CozyColors.warning.withAlpha(50)
            : CozyColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: isQuestion
            ? Border.all(color: CozyColors.warning, width: 2)
            : null,
      ),
      child: Icon(
        icon,
        size: 32,
        color: isQuestion ? CozyColors.warning : CozyColors.textMain,
      ),
    );
  }
}
