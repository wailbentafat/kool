import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/cozy_theme.dart';
import '../../shared/providers/global_providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  _OnboardingContent(
                    title: 'Welcome to LexiLearn',
                    description: 'A cozy place to learn at your own pace.',
                    icon: Icons.spa_rounded,
                  ),
                  _OnboardingContent(
                    title: 'Everyone Learns Differently',
                    description: 'We adapt to you, not the other way around.',
                    icon: Icons.psychology_rounded,
                  ),
                  _ConsentContent(),
                ],
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    final isLastPage = _currentPage == 2;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicator
          Row(
            children: List.generate(
              3,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? CozyColors.primary
                      : CozyColors.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (isLastPage) {
                // Complete Onboarding
                ref.read(onboardingCompletedProvider.notifier).state = true;
                context.go('/mode-detection');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            child: Text(isLastPage ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: CozyColors.secondary),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: CozyColors.textMain,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: CozyColors.textSub,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ConsentContent extends ConsumerWidget {
  const _ConsentContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentGiven = ref.watch(userConsentProvider);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.privacy_tip_rounded,
            size: 80,
            color: CozyColors.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Private & Local',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: CozyColors.textMain,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'We simulate AI on your device. No data ever leaves your phone.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: CozyColors.textSub,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            value: consentGiven,
            onChanged: (val) {
              ref.read(userConsentProvider.notifier).state = val;
            },
            title: Text(
              'I understand and consent',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            activeThumbColor: CozyColors.success,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
