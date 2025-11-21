import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../state/timer_state.dart';
import '../pages/timer_page.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final duration = TimerState.duration.value;
      final remaining = TimerState.remaining.value;
      final isRunning = TimerState.isRunning.value;
      final isDone = TimerState.isDone.value;

      // Hide if no timer is set
      if (duration.inSeconds == 0) {
        return const SizedBox.shrink();
      }

      // Calculate progress (1.0 to 0.0)
      double progress = 0.0;
      if (duration.inSeconds > 0) {
        progress = remaining.inSeconds / duration.inSeconds;
      }

      // Flashing effect when done
      final isFlashing = isDone && (DateTime.now().millisecond % 1000 < 500);

      return GestureDetector(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const TimerPage()));
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isDone
                ? (isFlashing
                      ? Colors.red.withValues(alpha: 0.8)
                      : Colors.black54)
                : Colors.black54,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone ? Colors.red : Colors.white24,
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular Progress
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDone
                        ? Colors.transparent
                        : (remaining.inSeconds < 60
                              ? Colors.orange
                              : Colors.blue),
                  ),
                ),
              ),
              // Time Display
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isDone)
                    const Icon(Icons.alarm, color: Colors.white, size: 32)
                  else ...[
                    Text(
                      TimerState.formatDuration(remaining),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
