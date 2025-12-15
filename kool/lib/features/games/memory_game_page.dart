import 'package:flutter/material.dart';
import 'dart:async';
import '../../app/theme/cozy_theme.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  final List<String> _emojis = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];
  late List<String> _cards;
  late List<bool> _cardFlips;
  late List<bool> _cardMatches;
  int? _firstFlippedIndex;
  bool _isProcessing = false;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _cards = [..._emojis, ..._emojis]..shuffle();
    _cardFlips = List.filled(_cards.length, false);
    _cardMatches = List.filled(_cards.length, false);
    _firstFlippedIndex = null;
    _isProcessing = false;
    _moves = 0;
    setState(() {});
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cardFlips[index] || _cardMatches[index]) return;

    setState(() {
      _cardFlips[index] = true;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      _isProcessing = true;
      _moves++;
      if (_cards[index] == _cards[_firstFlippedIndex!]) {
        // Match
        _cardMatches[index] = true;
        _cardMatches[_firstFlippedIndex!] = true;
        _firstFlippedIndex = null;
        _isProcessing = false;
        _checkWin();
      } else {
        // No match
        Timer(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _cardFlips[index] = false;
              _cardFlips[_firstFlippedIndex!] = false;
              _firstFlippedIndex = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  void _checkWin() {
    if (_cardMatches.every((element) => element)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("You Won!"),
          content: Text("You completed the game in $_moves moves."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Memory Match")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Moves: $_moves",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final isFlipped = _cardFlips[index] || _cardMatches[index];
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isFlipped
                          ? CozyColors.primary
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: isFlipped
                          ? Text(
                              _cards[index],
                              style: const TextStyle(fontSize: 32),
                            )
                          : Icon(
                              Icons.help_outline,
                              color: Theme.of(context).disabledColor,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
