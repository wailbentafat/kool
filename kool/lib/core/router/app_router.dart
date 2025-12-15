import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/onboarding/splash_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/mode_detection/mode_detection_page.dart';
import '../../features/learning_session/learning_session_page.dart';

import '../../features/games/games_page.dart';
import '../../features/games/memory_game_page.dart';
import '../../features/games/speed_game_page.dart';
import '../../features/games/pattern_game_page.dart';
import '../../features/study_support/study_support_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/ai_roleplay/presentation/pages/roleplay_landing_page.dart';
import '../../features/ai_roleplay/presentation/pages/roleplay_chat_page.dart';
import '../../features/profile/mistake_summary_page.dart';

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
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(
      path: '/mistakes',
      builder: (context, state) => const MistakeSummaryPage(),
    ),
    GoRoute(
      path: '/learning-session/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return LearningSessionPage(
          lessonId: id ?? '1', // Default to 1 if missing
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
        GoRoute(
          path: 'pattern',
          builder: (context, state) => const PatternGamePage(),
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
    GoRoute(
      path: '/roleplay',
      builder: (context, state) => const RoleplayLandingPage(),
    ),
    GoRoute(
      path: '/roleplay-chat/:charId',
      builder: (context, state) {
        final charId = state.pathParameters['charId']!;
        return RoleplayChatPage(characterId: charId);
      },
    ),
  ],
);
