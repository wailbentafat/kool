import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/cozy_theme.dart';

class SpeedGamePage extends StatefulWidget {
  const SpeedGamePage({super.key});

  @override
  State<SpeedGamePage> createState() => _SpeedGamePageState();
}

class _SpeedGamePageState extends State<SpeedGamePage> {
  final List<String> _words = [
    'Cat',
    'Dog',
    'Sun',
    'Moon',
    'Star',
    'Tree',
    'Bird',
    'Fish',
    'Book',
    'Pen',
    'Cake',
    'Ball',
    'Hat',
    'Shoe',
    'Car',
    'Bus',
  ];
  String _currentWord = "";
  int _score = 0;
  bool _isPlaying = false;
  Timer? _gameTimer;
  Timer? _wordTimer;
  int _timeLeft = 30;

  @override
  void dispose() {
    _gameTimer?.cancel();
    _wordTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _score = 0;
      _timeLeft = 30;
      _currentWord = "Ready?";
    });

    // Start countdown
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _endGame();
      }
    });

    // Start word rotation
    Future.delayed(const Duration(seconds: 2), () {
      _showNextWord();
    });
  }

  void _showNextWord() {
    if (!_isPlaying) return;

    setState(() {
      _currentWord =
          _words[(DateTime.now().millisecondsSinceEpoch ~/ 100) %
              _words.length];
    });

    // Speed increases as score increases
    int speed = 1500 - (_score * 50);
    if (speed < 500) speed = 500;

    _wordTimer = Timer(Duration(milliseconds: speed), _showNextWord);
  }

  void _onTapWord() {
    if (!_isPlaying) return;

    // Only score if it's not the "Ready?" text
    if (_currentWord != "Ready?") {
      setState(() {
        _score += 10;
        // Visual feedback could be added here
      });
      // Force next word immediately
      _wordTimer?.cancel();
      _showNextWord();
    }
  }

  void _endGame() {
    _gameTimer?.cancel();
    _wordTimer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentWord = "Game Over!";
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Time's Up!"),
        content: Text("You scored $_score points. Great focus!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to hub
            },
            child: const Text("Finish"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Speed Reader")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isPlaying) ...[
              Text(
                "Time: $_timeLeft",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CozyColors.textSub,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Score: $_score",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CozyColors.primary,
                ),
              ),
              const SizedBox(height: 48),
            ],

            GestureDetector(
              onTap: _onTapWord,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: CozyColors.cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: CozyColors.primary, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: CozyColors.primary.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _currentWord,
                    style: GoogleFonts.outfit(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: CozyColors.textMain,
                    ),
                  ),
                ),
              ),
            ),

            if (!_isPlaying) ...[
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text("Start Game"),
              ),
            ] else
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: Text(
                  "Tap the word to collect points!",
                  style: TextStyle(color: CozyColors.textSub),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
