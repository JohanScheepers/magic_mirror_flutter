import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../state/timer_state.dart';

import '../../../../core/presentation/widgets/mirror_scaffold.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return MirrorScaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Watch((context) {
        final duration = TimerState.duration.value;
        final remaining = TimerState.remaining.value;
        final isRunning = TimerState.isRunning.value;
        final isDone = TimerState.isDone.value;

        // If timer is active or paused (but set), show countdown view
        if (duration.inSeconds > 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Large Countdown Display
                Text(
                  TimerState.formatDuration(remaining),
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: isDone ? Colors.red : Colors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 40),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reset / Stop Button
                    ElevatedButton(
                      onPressed: () {
                        TimerState.stop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                        backgroundColor: Colors.grey[800],
                      ),
                      child: const Icon(Icons.stop, size: 32),
                    ),
                    const SizedBox(width: 30),

                    // Play / Pause Button
                    if (!isDone)
                      ElevatedButton(
                        onPressed: () {
                          if (isRunning) {
                            TimerState.pause();
                          } else {
                            TimerState.start();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(30),
                          shape: const CircleBorder(),
                          backgroundColor: isRunning
                              ? Colors.orange
                              : Colors.green,
                        ),
                        child: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          size: 48,
                        ),
                      ),
                  ],
                ),
                if (isDone)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        TimerState.stop();
                      },
                      icon: const Icon(Icons.alarm_off),
                      label: const Text('Dismiss Alarm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        // Setup View (Set Duration)
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Set Timer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 40),

              // Time Pickers
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimePicker(
                    'Hours',
                    _hours,
                    23,
                    (val) => setState(() => _hours = val),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  _buildTimePicker(
                    'Min',
                    _minutes,
                    59,
                    (val) => setState(() => _minutes = val),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  _buildTimePicker(
                    'Sec',
                    _seconds,
                    59,
                    (val) => setState(() => _seconds = val),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Start Button
              FilledButton.icon(
                onPressed: (_hours == 0 && _minutes == 0 && _seconds == 0)
                    ? null
                    : () {
                        final duration = Duration(
                          hours: _hours,
                          minutes: _minutes,
                          seconds: _seconds,
                        );
                        TimerState.setDuration(duration);
                        TimerState.start();
                      },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Timer'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTimePicker(
    String label,
    int value,
    int max,
    Function(int) onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54)),
        const SizedBox(height: 8),
        Container(
          height: 150,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: max + 1,
              builder: (context, index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: index == value
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: index == value ? Colors.white : Colors.white38,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
