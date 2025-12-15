import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/roleplay_providers.dart';
import '../../domain/entities/roleplay_character.dart';

class RoleplayChatPage extends ConsumerStatefulWidget {
  final String characterId;

  const RoleplayChatPage({super.key, required this.characterId});

  @override
  ConsumerState<RoleplayChatPage> createState() => _RoleplayChatPageState();
}

class _RoleplayChatPageState extends ConsumerState<RoleplayChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages =
      []; // {role: 'user'/'ai', text: '...'}
  bool _isTyping = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    // Initial greeting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialGreeting();
    });
  }

  void _sendInitialGreeting() async {
    final char = ref
        .read(roleplayCharactersProvider)
        .firstWhere((c) => c.id == widget.characterId);
    setState(() => _isTyping = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // Simulate typing
    final greeting =
        "Greetings! I am ${char.name}. ${char.role}. Ask me anything! ${char.avatarEmoji}";
    _addMessage('ai', greeting);
    setState(() => _isTyping = false);
  }

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;
    final text = _textController.text;
    _textController.clear();
    _addMessage('user', text);

    setState(() => _isTyping = true);

    // Mock thinking
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Mock response based on character
    final char = ref
        .read(roleplayCharactersProvider)
        .firstWhere((c) => c.id == widget.characterId);
    String response =
        "That is a fascinating question! As a ${char.role}, I would say... well, history is full of surprises! ${char.avatarEmoji}";

    if (text.toLowerCase().contains("hello")) {
      response = "Hello there! Ready to travel back in time? 🕰️";
    }

    _addMessage('ai', response);
    setState(() => _isTyping = false);
  }

  void _toggleListening() async {
    setState(() => _isListening = true);
    // Mock listening duration
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isListening = false);
    _textController.text = "Tell me about your life!"; // Mock STT result
  }

  void _addMessage(String role, String text) {
    setState(() {
      _messages.add({'role': role, 'text': text});
    });
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildQuickAction(BuildContext context, String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _textController.text = text;
        _sendMessage();
      },
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[300]!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final char = ref
        .watch(roleplayCharactersProvider)
        .firstWhere(
          (c) => c.id == widget.characterId,
          orElse: () => ref.read(roleplayCharactersProvider).first, // Fallback
        );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: char.themeColor.withOpacity(0.2),
              child: Text(char.avatarEmoji),
            ),
            const SizedBox(width: 8),
            Text(char.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show character info
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      "Typing... 💭",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ).animate().fadeIn();
                }

                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : Radius.zero,
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
              },
            ),
          ),
          if (_isListening)
            Container(
              color: Colors.redAccent.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Listening...",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(),

          // Quick Question Chips for Kids (No typing needed!)
          if (!_isTyping)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildQuickAction(context, "Tell me a joke! 😂"),
                  const SizedBox(width: 8),
                  _buildQuickAction(context, "What is your favorite food? 🍇"),
                  const SizedBox(width: 8),
                  _buildQuickAction(context, "Did you go to school? 🏫"),
                ],
              ),
            ).animate().slideY(begin: 0.5, end: 0),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: char.themeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                    color: char.themeColor,
                    onPressed: _toggleListening,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Ask ${char.name}...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          Colors.grey[100], // Adaptive color needed ideally
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
