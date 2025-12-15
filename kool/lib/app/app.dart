import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import 'theme/cozy_theme.dart';

class LexiLearnApp extends StatelessWidget {
  const LexiLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LexiLearn AI',
      theme: CozyTheme.light,
      routerConfig: appRouter,
    );
  }
}
