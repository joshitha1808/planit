import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/core/theme/theme_provider.dart';
import 'package:planit/viewmodels/onboarding_viewmodel.dart';
import 'package:planit/viewmodels/profile_viewmodel.dart';
import 'package:planit/views/main_shell.dart';
import 'package:planit/views/onboarding_page.dart';
import 'package:planit/views/profile_setup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final onboarding = ref.watch(onboardingViewModelProvider);

    return MaterialApp(
      theme: themeMode,
      debugShowCheckedModeBanner: false,
      home: onboarding.when(
        loading: () => const _SplashScreen(),
        error: (_, __) => const MainShell(),
        data: (completed) =>
            completed ? const _ProfileGate() : const OnboardingPage(),
      ),
    );
  }
}

/// After onboarding, make sure the user has set up a profile before entering
/// the app.
class _ProfileGate extends ConsumerWidget {
  const _ProfileGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileViewModelProvider);
    return profile.when(
      loading: () => const _SplashScreen(),
      error: (_, __) => const MainShell(),
      data: (p) => p == null ? const ProfileSetupPage() : const MainShell(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}
