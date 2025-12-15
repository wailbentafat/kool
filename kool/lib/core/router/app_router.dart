import 'package:go_router/go_router.dart';
import '../../features/onboarding/splash_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/mode_detection/mode_detection_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/learning_session/learning_session_page.dart';
import '../../features/lessons/lesson_hub_page.dart';
import '../../features/games/games_page.dart';
import '../../features/games/memory_game_page.dart';
import '../../features/games/speed_game_page.dart';
import '../../features/study_support/study_support_page.dart';
import '../../features/profile/profile_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/lessons',
      builder: (context, state) => const LessonHubPage(),
    ),
    GoRoute(
      path: '/learning-session',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        return LearningSessionPage(
          title: extras?['title'] ?? "The Solar System",
          content: extras?['content'] ?? "Standard lesson content...",
        );
      },
    ),
    GoRoute(
      path: '/games',
      builder: (context, state) => const GamesPage(),
      routes: [
        GoRoute(
          path: 'memory',
          builder: (context, state) => const MemoryGamePage(),
        ),
        GoRoute(
          path: 'speed',
          builder: (context, state) => const SpeedGamePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/mode-detection',
      builder: (context, state) => const ModeDetectionPage(),
    ),
    GoRoute(
      path: '/study-support',
      builder: (context, state) => const StudySupportPage(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
  ],
);
