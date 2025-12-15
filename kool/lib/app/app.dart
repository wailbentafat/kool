import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';

class LexiLearnApp extends StatelessWidget {
  const LexiLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LexiLearn AI',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
