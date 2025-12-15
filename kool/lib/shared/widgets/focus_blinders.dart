import 'package:flutter/material.dart';

class FocusBlinders extends StatelessWidget {
  final Widget child;
  final bool isEnabled;

  const FocusBlinders({super.key, required this.child, this.isEnabled = false});

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) return child;

    return Stack(
      children: [
        child,
        // Top Blinder
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
        ),
        // Bottom Blinder
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
