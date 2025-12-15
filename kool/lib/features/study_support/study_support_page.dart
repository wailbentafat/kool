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

    // 1. Simulate "Thinking" phase
    await Future.delayed(const Duration(seconds: 1));

    // 2. Prepare the target text (Simulated AI response)
    final text = _textController.text;
    final sentences = text.split(RegExp(r'[.!?]'));
    final topic = sentences.isNotEmpty ? sentences.first : "this topic";

    final response =
        """
Here is a simple summary for you! 🌟

• Key Point: "${topic.trim()}."
• Why it matters: It helps us understand the world better.

💡 Quick Tip: Try drawing a picture of this to remember it better!
""";

    // 3. Stream the text character by character
    setState(() => _isProcessing = false); // Stop spinner, start typing

    for (int i = 0; i < response.length; i++) {
      if (!mounted) return;

      setState(() {
        _summary += response[i];
      });

      // Variable speed for realism (faster on spaces, slower on punctuation)
      int delay = 30;
      if (response[i] == '.' || response[i] == '!') delay = 100;
      if (response[i] == ' ') delay = 10;

      await Future.delayed(Duration(milliseconds: delay));
    }
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
            Text(
              "Paste text below to get a simplified summary.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Paste your study notes here...",
                filled: true,
                fillColor: Theme.of(context).cardColor,
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
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: CozyColors.primary.withValues(alpha: 0.3),
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
