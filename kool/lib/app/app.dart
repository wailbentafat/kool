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

    return MaterialApp.router(
      title: 'LexiLearn AI',
      theme: CozyTheme.light,
      darkTheme: CozyTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
