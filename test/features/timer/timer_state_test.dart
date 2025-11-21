import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_mirror/features/timer/presentation/state/timer_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock platform channels for FlutterRingtonePlayer and Vibration
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_ringtone_player'),
          (MethodCall methodCall) async {
            return null; // Mock response
          },
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('vibration'), (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'hasVibrator') {
            return true;
          }
          return null;
        });
  });

  group('TimerState', () {
    setUp(() {
      TimerState.stop();
    });

    test('initial state is correct', () {
      expect(TimerState.duration.value, Duration.zero);
      expect(TimerState.remaining.value, Duration.zero);
      expect(TimerState.isRunning.value, false);
      expect(TimerState.isDone.value, false);
    });

    test('setDuration updates duration and remaining', () {
      const duration = Duration(minutes: 5);
      TimerState.setDuration(duration);

      expect(TimerState.duration.value, duration);
      expect(TimerState.remaining.value, duration);
      expect(TimerState.isRunning.value, false);
    });

    test('start sets isRunning to true', () {
      TimerState.setDuration(const Duration(seconds: 10));
      TimerState.start();
      expect(TimerState.isRunning.value, true);
    });

    test('pause sets isRunning to false', () {
      TimerState.setDuration(const Duration(seconds: 10));
      TimerState.start();
      TimerState.pause();
      expect(TimerState.isRunning.value, false);
    });

    test('reset restores remaining time', () {
      const duration = Duration(seconds: 10);
      TimerState.setDuration(duration);
      TimerState.start();

      // Simulate some time passing (manual manipulation for test)
      TimerState.remaining.value = const Duration(seconds: 5);

      TimerState.reset();
      expect(TimerState.remaining.value, duration);
      expect(TimerState.isRunning.value, false);
    });

    test('stop clears everything', () {
      TimerState.setDuration(const Duration(seconds: 10));
      TimerState.start();
      TimerState.stop();

      expect(TimerState.duration.value, Duration.zero);
      expect(TimerState.remaining.value, Duration.zero);
      expect(TimerState.isRunning.value, false);
    });

    test('formatDuration formats correctly', () {
      expect(TimerState.formatDuration(const Duration(seconds: 5)), '00:05');
      expect(
        TimerState.formatDuration(const Duration(minutes: 1, seconds: 30)),
        '01:30',
      );
      expect(
        TimerState.formatDuration(
          const Duration(hours: 1, minutes: 5, seconds: 5),
        ),
        '01:05:05',
      );
    });
  });
}
