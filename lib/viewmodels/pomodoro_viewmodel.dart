import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pomodoro_viewmodel.g.dart';

enum PomodoroMode { focus, shortBreak }

class PomodoroState {
  final PomodoroMode mode;
  final int remaining; // seconds left in the current session
  final bool isRunning;
  final int completedSessions; // number of finished focus sessions

  const PomodoroState({
    required this.mode,
    required this.remaining,
    required this.isRunning,
    required this.completedSessions,
  });

  PomodoroState copyWith({
    PomodoroMode? mode,
    int? remaining,
    bool? isRunning,
    int? completedSessions,
  }) {
    return PomodoroState(
      mode: mode ?? this.mode,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }
}

@Riverpod(keepAlive: true)
class PomodoroViewModel extends _$PomodoroViewModel {
  Timer? _timer;

  static const int focusDuration = 25 * 60;
  static const int breakDuration = 5 * 60;

  int _durationFor(PomodoroMode mode) =>
      mode == PomodoroMode.focus ? focusDuration : breakDuration;

  @override
  PomodoroState build() {
    ref.onDispose(() => _timer?.cancel());
    return const PomodoroState(
      mode: PomodoroMode.focus,
      remaining: focusDuration,
      isRunning: false,
      completedSessions: 0,
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
      remaining: _durationFor(state.mode),
      isRunning: false,
    );
  }

  void switchMode(PomodoroMode mode) {
    _timer?.cancel();
    state = state.copyWith(
      mode: mode,
      remaining: _durationFor(mode),
      isRunning: false,
    );
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

    state = state.copyWith(
      mode: nextMode,
      remaining: _durationFor(nextMode),
      isRunning: false,
      completedSessions: finishedFocus
          ? state.completedSessions + 1
          : state.completedSessions,
    );
  }
}
