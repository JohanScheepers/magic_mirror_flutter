import 'dart:async';
import 'package:signals_flutter/signals_flutter.dart';

class TimerState {
  // State signals
  static final duration = signal<Duration>(Duration.zero);
  static final remaining = signal<Duration>(Duration.zero);
  static final isRunning = signal(false);
  static final isDone = signal(false);

  static Timer? _timer;

  /// Start the timer
  static void start() {
    if (remaining.value.inSeconds <= 0 && duration.value.inSeconds > 0) {
      remaining.value = duration.value;
    }

    if (remaining.value.inSeconds > 0) {
      isRunning.value = true;
      isDone.value = false;
      _startTicker();
    }
  }

  /// Pause the timer
  static void pause() {
    isRunning.value = false;
    _timer?.cancel();
  }

  /// Reset the timer to initial duration
  static void reset() {
    pause();
    remaining.value = duration.value;
    isDone.value = false;
  }

  /// Stop and clear the timer
  static void stop() {
    pause();
    duration.value = Duration.zero;
    remaining.value = Duration.zero;
    isDone.value = false;
  }

  /// Set a new duration
  static void setDuration(Duration newDuration) {
    stop();
    duration.value = newDuration;
    remaining.value = newDuration;
  }

  /// Internal ticker
  static void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaining.value.inSeconds > 0) {
        remaining.value = Duration(seconds: remaining.value.inSeconds - 1);
      } else {
        _timer?.cancel();
        isRunning.value = false;
        isDone.value = true;
      }
    });
  }

  /// Format duration as HH:MM:SS
  static String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    if (d.inHours > 0) {
      return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
