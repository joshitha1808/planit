import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/viewmodels/onboarding_viewmodel.dart';
import 'package:planit/views/widgets/neo_box.dart';

class _OnboardData {
  final IconData icon;
  final String image;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardData({
    required this.icon,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

const _pages = [
  _OnboardData(
    icon: Icons.edit_note_rounded,
    image: 'assets/onboarding/onboarding_1.png',
    title: 'Plan it,\nthe fun way!',
    subtitle:
        'Jot down everything on your mind and turn a messy day into a tidy little list.',
    color: Color(0xFFB8F2C9),
  ),
  _OnboardData(
    icon: Icons.category_rounded,
    image: 'assets/onboarding/onboarding_2.png',
    title: 'Sort by\ncute categories',
    subtitle:
        'Work, study, shopping or fun — colour-code your tasks and find them in a tap.',
    color: Color(0xFFA9C7FF),
  ),
  _OnboardData(
    icon: Icons.timer_rounded,
    image: 'assets/onboarding/onboarding_3.png',
    title: 'Focus &\nstay on track',
    subtitle:
        'Beat procrastination with a built-in Pomodoro timer and watch your stats grow.',
    color: Color(0xFFFFC6F5),
  ),
];

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _index == _pages.length - 1;

  void _next() {
    if (_isLast) {
      ref.read(onboardingViewModelProvider.notifier).completeOnboarding();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
    ref.read(onboardingViewModelProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    _isLast ? '' : 'Skip',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _OnboardSlide(data: _pages[i]),
              ),
            ),
            _Dots(count: _pages.length, index: _index),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: SizedBox(
                width: double.infinity,
                child: NeoButton(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  onTap: _next,
                  child: Center(
                    child: Text(
                      _isLast ? "Let's go!" : 'Next',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardSlide extends StatelessWidget {
  final _OnboardData data;

  const _OnboardSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: NeoBox(
              color: data.color,
              shadowOffset: const Offset(6, 6),
              child: Center(
                child: Image.asset(
                  data.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Icon(data.icon, size: 120, color: AppColors.ink),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 34,
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.ink.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 14,
          width: active ? 34 : 14,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: AppStyles.border(),
          ),
        );
      }),
    );
  }
}
