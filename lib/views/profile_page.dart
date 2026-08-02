import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/constants/app_constants.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/models/task_model.dart';
import 'package:planit/models/user_profile.dart';
import 'package:planit/viewmodels/pomodoro_viewmodel.dart';
import 'package:planit/viewmodels/profile_viewmodel.dart';
import 'package:planit/viewmodels/task_viewmodel.dart';
import 'package:planit/views/profile_setup_page.dart';
import 'package:planit/views/widgets/mascot_image.dart';
import 'package:planit/views/widgets/neo_box.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskViewModelProvider);
    final profile = ref.watch(profileViewModelProvider).valueOrNull;
    final focusSessions = ref.watch(
      pomodoroViewModelProvider.select((s) => s.completedSessions),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
        data: (raw) {
          final tasks = raw.whereType<Task>().toList();
          final total = tasks.length;
          final done = tasks.where((t) => t.isCompleted).length;
          final pending = total - done;
          final completion = total == 0 ? 0.0 : done / total;

          // Count tasks per category.
          final byCategory = <String, int>{};
          for (final t in tasks) {
            byCategory[t.category] = (byCategory[t.category] ?? 0) + 1;
          }
          final categories = byCategory.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              _Header(
                profile: profile,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileSetupPage(existing: profile),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              const _SectionLabel("Statistics"),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: "$total",
                      label: "Total",
                      color: AppColors.pastels[5],
                      icon: Icons.list_alt_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: "$done",
                      label: "Done",
                      color: AppColors.pastels[3],
                      icon: Icons.check_circle_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: "$pending",
                      label: "Pending",
                      color: AppColors.pastels[1],
                      icon: Icons.hourglass_bottom_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _CompletionCard(completion: completion, done: done, total: total),
              const SizedBox(height: 16),
              _FocusCard(sessions: focusSessions),
              const SizedBox(height: 28),
              const _SectionLabel("By category"),
              const SizedBox(height: 14),
              if (categories.isEmpty)
                _EmptyHint()
              else
                ...categories.map(
                  (e) => _CategoryRow(
                    name: e.key,
                    count: e.value,
                    total: total,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UserProfile? profile;
  final VoidCallback onEdit;

  const _Header({required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final name = profile?.name.isNotEmpty == true ? profile!.name : "Planit User";
    final email = profile?.email.isNotEmpty == true
        ? profile!.email
        : "staying organized, one task at a time";
    final avatar = profile?.avatar ?? '';

    return NeoBox(
      color: AppColors.primary,
      shadowOffset: const Offset(5, 5),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: AppStyles.border(),
            ),
            clipBehavior: Clip.antiAlias,
            child: avatar.isEmpty
                ? const Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: AppColors.ink,
                  )
                : Image.asset(
                    avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: AppColors.ink,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: AppStyles.border(),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 18,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      color: color,
      shadowOffset: const Offset(3, 3),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Column(
        children: [
          Icon(icon, color: AppColors.ink, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  final double completion;
  final int done;
  final int total;

  const _CompletionCard({
    required this.completion,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (completion * 100).round();
    return NeoBox(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Completion",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  if (total > 0 && percent == 100) ...[
                    const SizedBox(width: 8),
                    const MascotImage(
                      asset: AppConstants.mascotHearts,
                      fallback: Icons.favorite_rounded,
                      size: 22,
                    ),
                  ],
                ],
              ),
              Text(
                "$percent%",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _NeoProgressBar(value: completion),
          const SizedBox(height: 8),
          Text(
            "$done of $total tasks done",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeoProgressBar extends StatelessWidget {
  final double value; // 0..1

  const _NeoProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(30),
            border: AppStyles.border(),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(30),
                  border: value > 0.02 ? AppStyles.border() : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FocusCard extends StatelessWidget {
  final int sessions;

  const _FocusCard({required this.sessions});

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      color: AppColors.pastels[6],
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: AppStyles.border(),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Focus sessions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Text(
                  "completed pomodoros",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Text(
            "$sessions",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String name;
  final int count;
  final int total;

  const _CategoryRow({
    required this.name,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeoBox(
        color: AppColors.pastelFor(name),
        shadowOffset: const Offset(3, 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(30),
                border: AppStyles.border(),
              ),
              child: Text(
                "$count",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeoBox(
      color: AppColors.pastels[2],
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const MascotImage(
            asset: AppConstants.mascotChick,
            fallback: Icons.add_task_rounded,
            size: 44,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Add some tasks to see your stats here.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
