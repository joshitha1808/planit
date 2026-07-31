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

  void _showDurationSheet(
    BuildContext context,
    PomodoroState state,
    PomodoroViewModel notifier,
  ) {
    int focus = state.focusMinutes;
    int brk = state.breakMinutes;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(20),
                border: AppStyles.border(),
                boxShadow: AppStyles.shadow(offset: const Offset(5, 5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Timer settings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),
                  _StepperRow(
                    label: "Focus",
                    value: focus,
                    color: AppColors.primary,
                    onChanged: (v) => setSheet(() => focus = v),
                  ),
                  const SizedBox(height: 14),
                  _StepperRow(
                    label: "Break",
                    value: brk,
                    color: AppColors.secondary,
                    onChanged: (v) => setSheet(() => brk = v),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: NeoButton(
                      color: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onTap: () {
                        notifier.setDurations(
                          focusMinutes: focus,
                          breakMinutes: brk,
                        );
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroViewModelProvider);
    final notifier = ref.read(pomodoroViewModelProvider.notifier);
    final isFocus = state.mode == PomodoroMode.focus;
    final accent = isFocus ? AppColors.primary : AppColors.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: NeoButton(
              padding: const EdgeInsets.all(8),
              shadowOffset: const Offset(3, 3),
              onTap: () => _showDurationSheet(context, state, notifier),
              child: const Icon(Icons.tune_rounded, color: AppColors.ink),
            ),
          ),
        ],
      ),
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

class _StepperRow extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;

  const _StepperRow({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      color: color,
      shadowOffset: const Offset(3, 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
          ),
          _RoundIconButton(
            icon: Icons.remove_rounded,
            onTap: () => onChanged(
              (value - 1).clamp(
                PomodoroViewModel.minMinutes,
                PomodoroViewModel.maxMinutes,
              ),
            ),
          ),
          SizedBox(
            width: 66,
            child: Text(
              "$value min",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
          ),
          _RoundIconButton(
            icon: Icons.add_rounded,
            onTap: () => onChanged(
              (value + 1).clamp(
                PomodoroViewModel.minMinutes,
                PomodoroViewModel.maxMinutes,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          shape: BoxShape.circle,
          border: AppStyles.border(),
        ),
        child: Icon(icon, size: 20, color: AppColors.ink),
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
