import 'package:flutter/material.dart';

class RoleplayCharacter {
  final String id;
  final String name;
  final String avatarEmoji; // Using emoji for MVP
  final String role; // "Queen of Egypt", "Physicist"
  final String systemPrompt;
  final Color themeColor;

  const RoleplayCharacter({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.role,
    required this.systemPrompt,
    required this.themeColor,
  });
}
