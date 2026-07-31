import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pomodoro_viewmodel.g.dart';

enum PomodoroMode { focus, shortBreak }

class PomodoroState {
  final PomodoroMode mode;
  final int remaining; // seconds left in the current session
  final bool isRunning;
  final int completedSessions; // number of finished focus sessions
  final int focusMinutes; // user-configurable focus length
  final int breakMinutes; // user-configurable break length

  const PomodoroState({
    required this.mode,
    required this.remaining,
    required this.isRunning,
    required this.completedSessions,
    required this.focusMinutes,
    required this.breakMinutes,
  });

  PomodoroState copyWith({
    PomodoroMode? mode,
    int? remaining,
    bool? isRunning,
    int? completedSessions,
    int? focusMinutes,
    int? breakMinutes,
  }) {
    return PomodoroState(
      mode: mode ?? this.mode,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      completedSessions: completedSessions ?? this.completedSessions,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
    );
  }
}

@Riverpod(keepAlive: true)
class PomodoroViewModel extends _$PomodoroViewModel {
  Timer? _timer;

  static const int defaultFocusMinutes = 25;
  static const int defaultBreakMinutes = 5;
  static const int minMinutes = 1;
  static const int maxMinutes = 90;

  int _durationFor(PomodoroMode mode, PomodoroState s) =>
      (mode == PomodoroMode.focus ? s.focusMinutes : s.breakMinutes) * 60;

  @override
  PomodoroState build() {
    ref.onDispose(() => _timer?.cancel());
    return const PomodoroState(
      mode: PomodoroMode.focus,
      remaining: defaultFocusMinutes * 60,
      isRunning: false,
      completedSessions: 0,
      focusMinutes: defaultFocusMinutes,
      breakMinutes: defaultBreakMinutes,
    );
  }

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remaining: _durationFor(state.mode, state),
      isRunning: false,
    );
  }

  void switchMode(PomodoroMode mode) {
    _timer?.cancel();
    state = state.copyWith(
      mode: mode,
      remaining: _durationFor(mode, state),
      isRunning: false,
    );
  }

  /// Update the focus / break lengths. Resets the current (stopped) session so
  /// the new length takes effect immediately.
  void setDurations({required int focusMinutes, required int breakMinutes}) {
    _timer?.cancel();
    final focus = focusMinutes.clamp(minMinutes, maxMinutes);
    final brk = breakMinutes.clamp(minMinutes, maxMinutes);
    final updated = state.copyWith(
      focusMinutes: focus,
      breakMinutes: brk,
      isRunning: false,
    );
    state = updated.copyWith(remaining: _durationFor(updated.mode, updated));
  }

  void _tick() {
    if (state.remaining > 1) {
      state = state.copyWith(remaining: state.remaining - 1);
      return;
    }

    // Session finished.
    _timer?.cancel();
    final finishedFocus = state.mode == PomodoroMode.focus;
    final nextMode = finishedFocus
        ? PomodoroMode.shortBreak
        : PomodoroMode.focus;

    final next = state.copyWith(
      mode: nextMode,
      isRunning: false,
      completedSessions: finishedFocus
          ? state.completedSessions + 1
          : state.completedSessions,
    );
    state = next.copyWith(remaining: _durationFor(nextMode, next));
  }
}
