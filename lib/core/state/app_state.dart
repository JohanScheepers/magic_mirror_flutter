import 'package:signals_flutter/signals_flutter.dart';

class AppState {
  static final showClock = signal(true);
  static final showWeather = signal(true);
  static final showShoppingList = signal(true);
}
