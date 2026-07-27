import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/viewmodels/pomodoro_viewmodel.dart';
import 'package:planit/views/widgets/neo_box.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroViewModelProvider);
    final notifier = ref.read(pomodoroViewModelProvider.notifier);
    final isFocus = state.mode == PomodoroMode.focus;
    final accent = isFocus ? AppColors.primary : AppColors.secondary;

    return Scaffold(
      appBar: AppBar(title: const Text("Pomodoro")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          children: [
            // Mode switch
            Row(
              children: [
                Expanded(
                  child: _ModeChip(
                    label: "Focus",
                    icon: Icons.bolt_rounded,
                    selected: isFocus,
                    color: AppColors.primary,
                    onTap: () => notifier.switchMode(PomodoroMode.focus),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModeChip(
                    label: "Break",
                    icon: Icons.free_breakfast_rounded,
                    selected: !isFocus,
                    color: AppColors.secondary,
                    onTap: () => notifier.switchMode(PomodoroMode.shortBreak),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Timer dial
            NeoBox(
              color: accent,
              shadowOffset: const Offset(6, 6),
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    isFocus ? "TIME TO FOCUS" : "TAKE A BREAK",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _format(state.remaining),
                    style: const TextStyle(
                      fontSize: 82,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _CompletedBadge(count: state.completedSessions),
            const Spacer(),

            // Controls
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: NeoButton(
                    color: state.isRunning
                        ? AppColors.pastels[0]
                        : AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    onTap: state.isRunning ? notifier.pause : notifier.start,
                    child: Center(
                      child: Text(
                        state.isRunning ? "Pause" : "Start",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeoButton(
                    color: AppColors.surfaceLight,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    onTap: notifier.reset,
                    child: const Center(
                      child: Icon(Icons.refresh_rounded, color: AppColors.ink),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeoButton(
      color: selected ? color : AppColors.surfaceLight,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shadowOffset: const Offset(3, 3),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.ink),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  final int count;

  const _CompletedBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      color: AppColors.pastels[2],
      shadowOffset: const Offset(3, 3),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppColors.ink),
          const SizedBox(width: 8),
          Text(
            "$count focus ${count == 1 ? 'session' : 'sessions'} done",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
