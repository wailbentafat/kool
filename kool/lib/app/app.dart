import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import 'theme/cozy_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/providers/global_providers.dart';

class LexiLearnApp extends ConsumerWidget {
  const LexiLearnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final learningMode = ref.watch(learningModeProvider);

    return MaterialApp.router(
      title: 'LexiLearn AI',
      theme: CozyTheme.getTheme(learningMode, ThemeMode.light),
      darkTheme: CozyTheme.getTheme(learningMode, ThemeMode.dark),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
