import 'package:flutter/material.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/services/github_launcher.dart';
import 'package:planit/views/widgets/neo_box.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _features = [
    (
      icon: Icons.lock_rounded,
      color: Color(0xFFB8F2C9),
      title: "Private by design",
      subtitle: "Everything stays on your device. No accounts, no cloud.",
    ),
    (
      icon: Icons.category_rounded,
      color: Color(0xFFA9C7FF),
      title: "Cute categories",
      subtitle: "Colour-code tasks and filter them in a tap.",
    ),
    (
      icon: Icons.timer_rounded,
      color: Color(0xFFFFC6F5),
      title: "Pomodoro timer",
      subtitle: "Focus in sprints with your own custom durations.",
    ),
    (
      icon: Icons.insights_rounded,
      color: Color(0xFFFDE68A),
      title: "Your stats",
      subtitle: "See progress, completion and focus sessions.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: NeoButton(
            padding: const EdgeInsets.all(8),
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          // App identity
          Center(
            child: Column(
              children: [
                NeoBox(
                  color: AppColors.primary,
                  shadowOffset: const Offset(5, 5),
                  padding: const EdgeInsets.all(14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/icon/app_icon.png",
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.check_circle_rounded,
                        size: 72,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Planit",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(30),
                    border: AppStyles.border(),
                  ),
                  child: const Text(
                    "your cute to-do buddy",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          NeoBox(
            padding: const EdgeInsets.all(18),
            child: Text(
              "Planit helps you organise your day the fun way. Add tasks, "
              "sort them into cute categories, focus with a Pomodoro timer, "
              "and watch your progress grow.",
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: AppColors.ink.withValues(alpha: 0.85),
              ),
            ),
          ),

          const SizedBox(height: 28),
          const Text(
            "What's inside",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          ..._features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FeatureCard(
                icon: f.icon,
                color: f.color,
                title: f.title,
                subtitle: f.subtitle,
              ),
            ),
          ),

          const SizedBox(height: 16),
          NeoBox(
            color: AppColors.pastels[1],
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Created with care by",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Joshitha",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: NeoButton(
                    color: AppColors.surfaceLight,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onTap: () => GithubLauncher().openGitHub(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.star_rounded, color: AppColors.ink),
                        SizedBox(width: 8),
                        Text(
                          "Star on GitHub",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child: Text(
              "v1.0.0",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      color: color,
      shadowOffset: const Offset(3, 3),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: AppStyles.border(),
            ),
            child: Icon(icon, color: AppColors.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
