import 'package:flutter/material.dart';
import '../../app/theme/cozy_theme.dart';

class StudySupportPage extends StatefulWidget {
  const StudySupportPage({super.key});

  @override
  State<StudySupportPage> createState() => _StudySupportPageState();
}

class _StudySupportPageState extends State<StudySupportPage> {
  final TextEditingController _textController = TextEditingController();
  String _summary = "";
  bool _isProcessing = false;

  void _generateSummary() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _summary = "";
    });

    // Mock processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      // Rule-based "summary": Take first sentence and add generic tips.
      final text = _textController.text;
      final sentences = text.split(RegExp(r'[.!?]'));
      final firstSentence = sentences.isNotEmpty ? sentences.first : text;

      _summary =
          "Here is the key point:\n\n"
          "• \"$firstSentence.\"\n\n"
          "Tip: Try to break down the rest into bullet points!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study Helper")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Paste text below to get a simplified summary.",
              style: TextStyle(color: CozyColors.textSub, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Paste your study notes here...",
                filled: true,
                fillColor: CozyColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _generateSummary,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isProcessing ? "Simplifying..." : "Simplify Text"),
            ),
            const SizedBox(height: 32),
            if (_summary.isNotEmpty) ...[
              const Text(
                "Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CozyColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: CozyColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _summary,
                  style: const TextStyle(height: 1.6, fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
