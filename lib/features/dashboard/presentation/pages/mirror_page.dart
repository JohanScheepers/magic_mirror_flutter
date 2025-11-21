import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/state/app_state.dart';
import '../../../clock/clock.dart';
import '../../../weather/weather.dart';
import '../../../shopping/shopping.dart';
import '../../../timer/timer.dart';
import '../../../settings/settings.dart';
import '../../../camera/camera.dart';

class MirrorPage extends StatelessWidget {
  const MirrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background: Camera Preview (Full Screen)
          const Positioned.fill(child: CameraPreviewWidget()),

          // UI Overlay (Safe Area)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  // Clock (Top Left)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Watch(
                      (context) => Visibility(
                        visible: AppState.showClock.value,
                        child: const ClockWidget(),
                      ),
                    ),
                  ),
                  // Weather (Bottom Left)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Watch(
                      (context) => Visibility(
                        visible: AppState.showWeather.value,
                        child: const WeatherWidget(),
                      ),
                    ),
                  ),
                  // Shopping List (Top Right)
                  Positioned(
                    top: 100,
                    right: 0,
                    child: Watch(
                      (context) => Visibility(
                        visible: AppState.showShoppingList.value,
                        child: const ShoppingListWidget(),
                      ),
                    ),
                  ),
                  // Timer (Top Center)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(child: TimerWidget()),
                  ),
                  // Settings Button (Bottom Right)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.grid_view, color: Colors.white54),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MenuPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
